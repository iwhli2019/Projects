import sqlite3
import pandas as pd
import numpy as np
import random
import datetime
from faker import Faker
import yaml
import logging
import sys
from pathlib import Path


def setup_logging(config):
    """Configures logging to write to a timestamped file and the console."""
    log_config = config["logging"]
    log_dir = Path(log_config["log_directory"])
    log_dir.mkdir(parents=True, exist_ok=True)
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file_path = log_dir / f"{log_config['log_prefix']}{timestamp}.log"

    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s - %(levelname)s - %(message)s",
        handlers=[
            logging.FileHandler(log_file_path, encoding="utf-8"),
            logging.StreamHandler(sys.stdout),
        ],
    )
    return log_file_path


def get_age(birthdate):
    """Calculates age from a birthdate."""
    today = datetime.date.today()
    return (
        today.year
        - birthdate.year
        - ((today.month, today.day) < (birthdate.month, birthdate.day))
    )


def generate_policies(config):
    """Generates a table of insurance policies directly from the config file."""
    logging.info("Loading policy definitions from config.yaml...")
    policies_data = config["policy_definitions"]
    return pd.DataFrame(policies_data)


def generate_households(config, fake):
    """Generates base household information to enforce consistency."""
    num_households = int(config["record_counts"]["num_members_base"] / 1.8)
    households = []
    for i in range(num_households):
        households.append(
            {
                "household_id": f"HID_{10000 + i}",
                "last_name": fake.last_name(),
                "address": fake.street_address(),
                "city": fake.city(),
                "postal_code": fake.postalcode(),
                "unit_number": (
                    f"Apt {random.randint(100, 2000)}"
                    if random.random() < 0.3
                    else None
                ),
            }
        )
    return households


def generate_members(config, policies_df, households, fake):
    """
    Generates the Members table with SCD Type 2 and detailed business logic.
    Active records are denoted by a rec_end_date of None.
    """
    members_data = []
    member_counter = 1001

    # Get lists of Group and Individual policy IDs
    group_policies = policies_df[policies_df["policy_id"].str.startswith("G_")][
        "policy_id"
    ].tolist()
    personal_policies = policies_df[policies_df["policy_id"].str.startswith("I_")][
        "policy_id"
    ].tolist()

    # Determine the dynamic proportion for this run
    group_prop_range = config["proportions"]["group_members"]
    GROUP_PROPORTION = random.uniform(group_prop_range[0], group_prop_range[1])

    # --- Main loop to generate the base member records ---
    for i in range(config["record_counts"]["num_members_base"]):
        household = random.choice(households)

        # Assign policy based on the dynamic G/I split
        policy_id = (
            random.choice(group_policies)
            if random.random() < GROUP_PROPORTION
            else random.choice(personal_policies)
        )

        dob = fake.date_of_birth()
        age = get_age(dob)
        sex = random.choice(["M", "F"])

        # Sophisticated last name logic based on household and gender
        last_name = household["last_name"]
        if random.random() > 0.5 and age > 18:  # Simulate a partner in the household
            if (
                sex == "F" and random.random() > 0.80
            ):  # ~20% of women keep a different name
                last_name = fake.last_name()
            if (
                sex == "M" and random.random() > 0.95
            ):  # <5% of men take a different name
                last_name = fake.last_name()

        # Generate sex, gender, and title
        gender, title = ("Male", "Mr.") if sex == "M" else ("Female", "Ms.")
        if random.random() > 0.98:  # Small chance for non-binary gender
            gender, title = "Non-binary", "Mx."

        # Assign company name only to working-age members on group plans
        company_name = (
            fake.company()
            if policy_id.startswith("G_") and age >= 16 and random.random() < 0.6
            else None
        )

        # Set policy status (lapsed/cancelled for a small subset)
        policy_status, status_change_date = ("Active", None)
        if random.random() > 0.95:
            policy_status = random.choice(["Lapsed", "Cancelled"])
            status_change_date = fake.date_this_year()

        # Generate initial SCD Type 2 record dates
        rec_start_date = fake.date_between(start_date="-10y", end_date="-2y")

        members_data.append(
            {
                "member_id": f"MID_{member_counter}",
                "household_id": household["household_id"],
                "policy_id": policy_id,
                "first_name": fake.first_name(),
                "last_name": last_name,
                "dob": dob,
                "sex": sex,
                "gender": gender,
                "title": title,
                "salary": (
                    round(random.uniform(45000, 150000), -3)
                    if age >= 18 and company_name
                    else None
                ),
                "address": household["address"],
                "city": household["city"],
                "postal_code": household["postal_code"],
                "unit_number": household["unit_number"],
                "company_name": company_name,
                "is_transfer_policy": 0,  # Default to 0
                "is_deleted": 0,  # Default to 0
                "policy_status": policy_status,
                "status_change_date": status_change_date,
                "rec_start_date": rec_start_date,
                "rec_end_date": None,  # Active records have a NULL end date
            }
        )
        member_counter += 1

    df = pd.DataFrame(members_data)

    # --- Post-processing to simulate history and special cases ---

    # 1. Simulate SCD Type 2 changes for a subset of members
    scd_change_indices = df.sample(frac=0.1).index
    new_rows = []
    for idx in scd_change_indices:
        old_record = df.loc[idx].to_dict()
        change_date = fake.date_between(
            start_date=old_record["rec_start_date"], end_date="-1y"
        )

        # Expire the old record by setting its end date
        df.loc[idx, "rec_end_date"] = change_date

        # Create the new, now-active record
        new_record = old_record.copy()
        new_record["rec_start_date"] = change_date + datetime.timedelta(days=1)
        new_record["rec_end_date"] = None  # The new record is active
        new_record["address"] = fake.street_address()  # Simulate an address change
        if pd.notna(new_record["salary"]):
            new_record["salary"] = round(
                new_record["salary"] * random.uniform(1.05, 1.2)
            )
        new_rows.append(new_record)

    df = pd.concat([df, pd.DataFrame(new_rows)], ignore_index=True)

    # 2. Flag a subset of Individual policyholders as "Transfer Policies"
    individual_indices = df[df["policy_id"].str.startswith("I_")].index
    if len(individual_indices) > 0:
        num_transfers = int(len(individual_indices) * 0.15)
        transfer_indices = random.sample(list(individual_indices), k=num_transfers)
        df.loc[transfer_indices, "is_transfer_policy"] = 1

    return df


def generate_providers_and_physicians(config, fake):
    """Generates the normalized provider network tables using parameters from config."""
    physicians, providers, affiliations = [], [], []

    # Load parameters from the config file
    prov_data = config["provider_data"]
    specialties = prov_data["specialties"]
    network_statuses = list(prov_data["network_status_weights"].keys())
    network_weights = list(prov_data["network_status_weights"].values())

    # Generate Physicians (the people)
    for i in range(config["record_counts"]["num_physicians"]):
        physicians.append(
            {
                "physician_id": f"PHY_{3001 + i}",
                "physician_name": f"Dr. {fake.first_name()} {fake.last_name()}",
                "specialty": random.choice(specialties),
            }
        )

    # Generate Providers (the locations/organizations)
    for i in range(config["record_counts"]["num_providers"]):
        network_status = random.choices(network_statuses, weights=network_weights, k=1)[
            0
        ]
        providers.append(
            {
                "provider_id": f"PRV_{2001 + i}",
                "provider_name": fake.company() + " Medical Center",
                "network_status": network_status,
                "address": fake.street_address(),
                "city": fake.city(),
                "postal_code": fake.postalcode(),
            }
        )

    # Generate Affiliations (the link)
    affiliation_counter = 1
    for physician in physicians:
        num_affiliations = random.choices([1, 2], weights=[0.8, 0.2], k=1)[0]
        for workplace in random.sample(providers, k=num_affiliations):
            affiliations.append(
                {
                    "affiliation_id": f"AFF_{5001 + affiliation_counter}",
                    "physician_id": physician["physician_id"],
                    "provider_id": workplace["provider_id"],
                }
            )
            affiliation_counter += 1

    return pd.DataFrame(physicians), pd.DataFrame(providers), pd.DataFrame(affiliations)


def generate_codes_and_fees(config):
    """Generates clinical code and fee tables directly from the config file."""
    logging.info("Loading clinical data definitions from config.yaml...")
    cl_data = config["clinical_data"]

    diagnoses_df = pd.DataFrame(
        cl_data["icd10_codes"].items(), columns=["diagnosis_code", "description"]
    )
    procedures_df = pd.DataFrame(
        cl_data["procedure_codes"].items(), columns=["procedure_code", "description"]
    )
    link_df = pd.DataFrame(cl_data["procedure_diagnosis_link"]).rename(
        columns={"pc": "procedure_code", "vdc": "valid_diagnosis_code"}
    )

    fees_list = []
    for code, base_fee in cl_data["base_fees"].items():
        fees_list.append(
            {
                "procedure_code": code,
                "network_status": "In-Network (HealthLink)",
                "base_fee": base_fee,
                "agreed_fee": round(base_fee * 0.9, 2),
            }
        )
        fees_list.append(
            {
                "procedure_code": code,
                "network_status": "In-Network (Partner)",
                "base_fee": base_fee,
                "agreed_fee": round(base_fee * 1.1, 2),
            }
        )
    fee_schedule_df = pd.DataFrame(fees_list)

    return diagnoses_df, procedures_df, link_df, fee_schedule_df


def generate_claims(
    config, members_df, affiliations_df, link_df, fee_schedule_df, policies_df, fake
):
    """Generates the main Claims fact table with realistic financial calculations from config."""
    claims_data = []
    active_members_df = members_df[members_df["rec_end_date"].isnull()].copy()

    # Load parameters from the config file
    params = config["claim_parameters"]
    fraud_rate_range = config["proportions"]["fraud_rate"]
    FRAUD_RATE = random.uniform(fraud_rate_range[0], fraud_rate_range[1])

    for i in range(config["record_counts"]["num_claims"]):
        valid_link = link_df.sample(1).iloc[0]
        if active_members_df.empty:
            logging.warning(
                "No active members found to generate claims for. Skipping claim generation."
            )
            break
        active_member = active_members_df.sample(1).iloc[0]
        member_policy = policies_df[
            policies_df["policy_id"] == active_member["policy_id"]
        ].iloc[0]
        affiliation = affiliations_df.sample(1).iloc[0]
        is_fraudulent = 1 if random.random() < FRAUD_RATE else 0
        base_fee = fee_schedule_df[
            fee_schedule_df["procedure_code"] == valid_link["procedure_code"]
        ].iloc[0]["base_fee"]

        # Calculate submitted_amt using ranges from config
        if is_fraudulent:
            submitted_amt = round(
                base_fee * random.uniform(*params["fraud_upcharge_range"]), 2
            )
        else:
            submitted_amt = round(
                base_fee * random.uniform(*params["normal_variance_range"]), 2
            )

        agreed_fee = fee_schedule_df.loc[
            (fee_schedule_df["procedure_code"] == valid_link["procedure_code"])
            & (fee_schedule_df["network_status"] != "Out-of-Network"),
            "agreed_fee",
        ].mean()
        paid_amt = round(
            max(0, agreed_fee - member_policy["copay_amt"])
            * (1 - member_policy["coinsurance_pct"]),
            2,
        )
        if is_fraudulent:
            paid_amt = submitted_amt
        service_date = fake.date_time_between(start_date="-2y", end_date="now")

        # Calculate submit_date using lag from config
        submit_lag = random.randint(*params["submit_date_lag_days"])

        claims_data.append(
            {
                "claim_id": f"CLM_{50001 + i}",
                "member_id": active_member["member_id"],
                "affiliation_id": affiliation["affiliation_id"],
                "service_date": service_date.date(),
                "submit_date": service_date.date()
                + datetime.timedelta(days=submit_lag),
                "procedure_code": valid_link["procedure_code"],
                "diagnosis_code": valid_link["valid_diagnosis_code"],
                "submitted_amt": submitted_amt,
                "paid_amt": paid_amt,
                "is_fraudulent": is_fraudulent,
            }
        )

    return pd.DataFrame(claims_data)


def generate_date_dimension(config):
    dates_data = []
    current_date = datetime.date(2015, 1, 1)
    while current_date <= datetime.date(2030, 12, 31):
        dates_data.append(
            {
                "date": current_date,
                "year": current_date.year,
                "month": current_date.month,
                "day": current_date.day,
                "day_of_week": current_date.strftime("%A"),
                "quarter": f"Q{(current_date.month - 1) // 3 + 1}",
                "is_weekday": 1 if current_date.weekday() < 5 else 0,
            }
        )
        current_date += datetime.timedelta(days=1)
    return pd.DataFrame(dates_data)


def create_oltp_database(dataframes, column_schemas, db_name):
    conn = sqlite3.connect(db_name)
    logging.info(f"Connecting to database '{db_name}'...")
    for table_name, df in dataframes.items():
        logging.info(f"Writing table '{table_name}'...")
        df_copy = df.copy()
        for col in df_copy.columns:
            if df_copy[col].dtype == "object" and not df_copy[col].dropna().empty:
                if isinstance(
                    df_copy[col].dropna().iloc[0], (datetime.date, datetime.datetime)
                ):
                    df_copy[col] = pd.to_datetime(df_copy[col]).dt.strftime("%Y-%m-%d")

        table_schema = {
            col: column_schemas[col] for col in df_copy.columns if col in column_schemas
        }
        df_copy.to_sql(
            table_name, conn, if_exists="replace", index=False, dtype=table_schema
        )

    logging.info("OLTP Database creation complete.")
    conn.close()


if __name__ == "__main__":
    try:
        with open("config.yaml", "r") as f:
            config = yaml.safe_load(f)
    except (FileNotFoundError, yaml.YAMLError) as e:
        print(f"FATAL ERROR: Could not load config.yaml. Details: {e}")
        sys.exit(1)

    log_file = setup_logging(config)
    logging.info(f"Log file for this run: {log_file}")

    try:
        random.seed(config["seed"])
        Faker.seed(config["seed"])
        DB_NAME = config["db_name"]

        # --- INITIALIZE FAKER INSTANCE ---
        fake = Faker("en_CA")

        logging.info("--- Starting OLTP Database Generation ---")
        logging.info(f"Reproducible Seed: {config['seed']}")

        policies_df = generate_policies(config)
        households_list = generate_households(config, fake)
        diagnoses_df, procedures_df, proc_diag_link_df, fee_schedule_df = (
            generate_codes_and_fees(config)
        )
        physicians_df, providers_df, affiliations_df = (
            generate_providers_and_physicians(config, fake)
        )
        members_df = generate_members(config, policies_df, households_list, fake)
        claims_df = generate_claims(
            config,
            members_df,
            affiliations_df,
            proc_diag_link_df,
            fee_schedule_df,
            policies_df,
            fake,
        )
        date_dimension_df = generate_date_dimension(config)

        oltp_dataframes = {
            "Policies": policies_df,
            "Members": members_df,
            "Physicians": physicians_df,
            "Providers": providers_df,
            "ProviderAffiliations": affiliations_df,
            "Diagnoses": diagnoses_df,
            "Procedures": procedures_df,
            "ProcedureDiagnosisLink": proc_diag_link_df,
            "FeeSchedule": fee_schedule_df,
            "Claims": claims_df,
            "DateDimension": date_dimension_df,
        }

        create_oltp_database(oltp_dataframes, config["column_dtypes"], DB_NAME)

        logging.info("--- Generation Summary ---")
        for name, df in oltp_dataframes.items():
            logging.info(f"- Table '{name}' created with {len(df)} records.")

        logging.info(f"Success! Your OLTP database is ready in the file: '{DB_NAME}'")

    except Exception as e:
        logging.error("A fatal error occurred during script execution.", exc_info=True)
        sys.exit(1)
