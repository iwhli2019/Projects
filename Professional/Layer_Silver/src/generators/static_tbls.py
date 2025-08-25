import logging
import datetime
import pandas as pd


def generate_policies(config):
    """Generates a table of insurance policies directly from the config file."""
    logging.info("Loading policy definitions from config.yaml...")
    policies_data = config["policy_definitions"]
    return pd.DataFrame(policies_data)


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
