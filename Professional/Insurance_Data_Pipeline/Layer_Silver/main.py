import logging
import random
import sys
import yaml
from datetime import datetime
from pathlib import Path

from faker import Faker

# Import functions from your custom modules
from src.generators.claims import generate_claims
from src.generators.companies import generate_companies
from src.generators.financials import generate_financial_transactions
from src.generators.members import (
    generate_households,
    generate_members,
    generate_member_policies,
)
from src.generators.providers import generate_providers_and_physicians
from src.generators.static_tbls import (
    generate_codes_and_fees,
    generate_date_dimension,
    generate_policies,
)
from src.utils.db import create_oltp_database
from src.utils.logging_config import setup_logging


def main():
    """Main function to orchestrate the entire data generation pipeline."""
    try:
        with open("config.yaml", "r") as f:
            config = yaml.safe_load(f)
    except (FileNotFoundError, yaml.YAMLError) as e:
        print(f"FATAL ERROR: Could not load or parse config.yaml. Details: {e}")
        sys.exit(1)

    # --- Setup ---
    log_file = setup_logging(config)
    logging.info(f"Log file for this run: {log_file}")

    try:
        # --- CONFIGURATION & SEED ---
        random.seed(config["seed"])
        Faker.seed(config["seed"])

        db_base_name = config["db_base_name"]
        timestamp = datetime.now().strftime("%Y%m%d_%H%M")
        DB_NAME = f"{db_base_name}_{timestamp}.db"

        fake = Faker("en_CA")

        logging.info("--- Starting OLTP Database Generation ---")
        logging.info(f"Target Database: {DB_NAME}")
        logging.info(f"Reproducible Seed: {config['seed']}")

        # --- GENERATE ALL DATA IN LOGICAL ORDER ---
        logging.info("Generating foundational tables...")
        df_policies = generate_policies(config)
        df_companies = generate_companies(config, fake)
        list_households = generate_households(config, fake)
        df_diagnoses, df_procedures, df_proc_diag_link, df_fee_schedule = (
            generate_codes_and_fees(config)
        )
        df_physicians, df_providers, df_affiliations = (
            generate_providers_and_physicians(config, fake)
        )
        df_date_dimension = generate_date_dimension(config)

        logging.info("Generating main transactional tables...")

        # --- CORRECTED LINE ---
        # Pass df_companies as the fourth argument
        df_members = generate_members(
            config, df_policies, list_households, df_companies, fake
        )

        df_member_policies = generate_member_policies(
            config, df_members, df_policies, fake
        )
        df_financial_transactions = generate_financial_transactions(
            config, df_member_policies, fake
        )
        df_claims = generate_claims(
            config,
            df_member_policies,
            df_affiliations,
            df_proc_diag_link,
            df_fee_schedule,
            df_policies,
            fake,
        )

        # --- PACKAGE & LOAD TO DATABASE ---
        oltp_dataframes = {
            "Dim_Policy": df_policies,
            "Dim_Company": df_companies,
            "Dim_Member": df_members,
            "Dim_Member_Policies": df_member_policies,
            "Dim_Physician": df_physicians,
            "Dim_Provider": df_providers,
            "Dim_Date": df_date_dimension,
            "Fact_Claims": df_claims,
            "Fact_Financial_Transactions": df_financial_transactions,
            "ProviderAffiliations": df_affiliations,  # Bridge Table
            "Diagnoses": df_diagnoses,  # Lookup Table
            "Procedures": df_procedures,  # Lookup Table
            "ProcedureDiagnosisLink": df_proc_diag_link,  # Lookup Table
            "FeeSchedule": df_fee_schedule,  # Lookup Table
        }

        create_oltp_database(oltp_dataframes, config["column_dtypes"], DB_NAME)

        # --- FINAL SUMMARY ---
        logging.info("\n--- Generation Summary ---")
        for name, df in oltp_dataframes.items():
            logging.info(f"- Table '{name}' created with {len(df)} records.")

        logging.info(f"\nSuccess! Your OLTP database is ready in the file: '{DB_NAME}'")

    except Exception as e:
        logging.error("A fatal error occurred during script execution.", exc_info=True)
        sys.exit(1)


if __name__ == "__main__":
    main()
