# src/generators/companies.py
import logging
import pandas as pd
import random

logger = logging.getLogger(__name__)


def generate_companies(config, fake):
    """Generates a dimension table of companies with geographically correct area codes from config."""
    logger.info("Generating company dimension table...")

    # Load all parameters from the config file
    area_code_map = config["geography_data"]["area_code_map"]
    params = config["company_parameters"]

    companies_data = []
    company_id_counter = 101

    # Use the company count from config
    company_names = [fake.company() for _ in range(params["base_company_count"])]

    for name in company_names:
        # Use the location weights from config
        num_locations = random.choices(
            [1, 2, 3], weights=params["location_weights"], k=1
        )[0]

        for _ in range(num_locations):
            # ... (rest of the function is the same)
            province_abbr = fake.province_abbr()

            if province_abbr in area_code_map:
                area_code = random.choice(area_code_map[province_abbr])
            else:
                area_code = str(random.randint(200, 999))

            country_code = "+1"
            phone_number = f"{random.randint(200, 999)}-{random.randint(1000, 9999)}"

            if random.random() > 0.95:
                area_code = None

            companies_data.append(
                {
                    "company_id": f"COMP_{company_id_counter}",
                    "company_name": name,
                    "company_address": fake.street_address(),
                    "company_website": fake.url(),
                    "company_email": fake.email(),
                    "company_province": province_abbr,
                    "city": fake.city(),
                    "postal_code": fake.postalcode(),
                    "company_phone_country_code": country_code,
                    "company_phone_area_code": area_code,
                    "company_phone_number": phone_number,
                }
            )
            company_id_counter += 1

    return pd.DataFrame(companies_data)
