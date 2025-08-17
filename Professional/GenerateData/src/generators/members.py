import random
import logging
import datetime
import pandas as pd
from ..utils.helpers import get_age

logger = logging.getLogger(__name__)


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


def generate_member_policies(config, df_members, df_policies, fake):
    """
    Generates the Dim_Member_Policies junction table with a robust chronological approach.
    """
    logger.info("Generating member policy enrollments...")

    params = config["enrollment_parameters"]
    start_range = [
        f"-{params['initial_start_date_years_ago'][1]}y",
        f"-{params['initial_start_date_years_ago'][0]}y",
    ]

    unique_member_ids = df_members["member_id"].unique()
    group_policies = df_policies[df_policies["policy_id"].str.startswith("G")][
        "policy_id"
    ].tolist()
    personal_policies = df_policies[df_policies["policy_id"].str.startswith("I")][
        "policy_id"
    ].tolist()

    group_prop_range = config["proportions"]["group_members"]
    GROUP_PROPORTION = random.uniform(group_prop_range[0], group_prop_range[1])

    policies_data = []
    member_policy_id_counter = 1

    for member_id in unique_member_ids:
        # Decide if a member has a history of more than one policy
        num_policies = random.choices([1, 2], weights=[0.9, 0.1], k=1)[0]

        # This will track the end date of the previously generated policy
        last_policy_end_date = None

        for i in range(num_policies):
            policy_id = (
                random.choice(group_policies)
                if random.random() < GROUP_PROPORTION
                else random.choice(personal_policies)
            )

            # --- NEW CHRONOLOGICAL LOGIC ---
            if last_policy_end_date:
                # If there was a previous policy, the new one must start after it.
                # We'll add a random gap of 30 to 180 days.
                start_date_for_new_policy = last_policy_end_date + datetime.timedelta(
                    days=random.randint(30, 180)
                )
            else:
                # This is the member's first policy.
                start_date_for_new_policy = fake.date_between(
                    start_date=start_range[0], end_date=start_range[1]
                )

            # Determine if this is the last (and therefore active) policy for this member
            is_active_policy = i == num_policies - 1

            if is_active_policy:
                end_date_for_this_policy = None
            else:
                # This is a historical policy, so it needs an end date.
                if policy_id.startswith("I"):
                    # Individual policies lapse around their anniversary
                    end_date_for_this_policy = fake.date_between(
                        start_date=start_date_for_new_policy
                        + datetime.timedelta(days=360),
                        end_date=start_date_for_new_policy
                        + datetime.timedelta(days=400),
                    )
                else:
                    # Group policies can terminate any time after a minimum period (e.g., 90 days)
                    end_date_for_this_policy = fake.date_between(
                        start_date=start_date_for_new_policy
                        + datetime.timedelta(days=90)
                    )

                # Keep track of this end date for the next loop iteration
                last_policy_end_date = end_date_for_this_policy

            policies_data.append(
                {
                    "member_policy_id": f"MP_{member_policy_id_counter}",
                    "member_id": member_id,
                    "policy_id": policy_id,
                    "policy_start_date": start_date_for_new_policy,
                    "policy_end_date": end_date_for_this_policy,
                }
            )
            member_policy_id_counter += 1

    return pd.DataFrame(policies_data)
