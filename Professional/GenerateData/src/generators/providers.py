import random
import pandas as pd


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
