import logging
import random
import sys
import yaml
from datetime import datetime
from pathlib import Path

from faker import Faker

# Import functions from your custom modules
from src.generators.claims import generate_claims
from src.generators.members import generate_households, generate_members
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
        # If logging isn't set up yet, print is the only option
        print(f"FATAL ERROR: Could not load or parse config.yaml. Details: {e}")
        sys.exit(1)

    # --- Setup ---
    log_file = setup_logging(config)
    logging.info(f"Log file for this run: {log_file}")

    try:
        # --- CONFIGURATION & SEED ---
        random.seed(config["seed"])
        Faker.seed(config["seed"])

        # Dynamically create the timestamped database name
        db_base_name = config["db_base_name"]
        timestamp = datetime.now().strftime("%Y%m%d_%H%M")
        DB_NAME = f"{db_base_name}_{timestamp}.db"

        fake = Faker("en_CA")

        logging.info("--- Starting OLTP Database Generation ---")
        logging.info(f"Target Database: {DB_NAME}")
        logging.info(f"Reproducible Seed: {config['seed']}")

        # --- GENERATE ALL DATA IN LOGICAL ORDER ---
        logging.info("Generating foundational tables...")
        policies_df = generate_policies(config)
        households_list = generate_households(config, fake)
        diagnoses_df, procedures_df, proc_diag_link_df, fee_schedule_df = (
            generate_codes_and_fees(config)
        )
        physicians_df, providers_df, affiliations_df = (
            generate_providers_and_physicians(config, fake)
        )
        date_dimension_df = generate_date_dimension(config)

        logging.info("Generating main transactional tables...")
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

        # --- PACKAGE & LOAD TO DATABASE ---
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

        # --- FINAL SUMMARY ---
        logging.info("\n--- Generation Summary ---")
        for name, df in oltp_dataframes.items():
            logging.info(f"- Table '{name}' created with {len(df)} records.")

        logging.info(f"Success! Your OLTP database is ready in the file: '{DB_NAME}'")

    except Exception as e:
        logging.error("A fatal error occurred during script execution.", exc_info=True)
        sys.exit(1)


if __name__ == "__main__":
    main()
