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


def generate_members(config, policies_df, households, df_companies, fake):
    """
    Generates the Dim_Member table by building households as cohesive units
    with logical marital statuses and relationships.
    """
    logger.info("Generating member dimension table by household...")
    members_data = []
    member_counter = 1001

    group_policies = policies_df[policies_df["policy_id"].str.startswith("G_")][
        "policy_id"
    ].tolist()
    personal_policies = policies_df[policies_df["policy_id"].str.startswith("I_")][
        "policy_id"
    ].tolist()

    group_prop_range = config["proportions"]["group_members"]
    company_ids = df_companies["company_id"].tolist()

    # --- NEW: Loop through each household to build it as a unit ---
    for household in households:
        GROUP_PROPORTION = random.uniform(*group_prop_range)
        policy_id = (
            random.choice(group_policies)
            if random.random() < GROUP_PROPORTION
            else random.choice(personal_policies)
        )

        # Decide household composition
        composition = random.choices(
            ["single_adult", "married_couple", "family_with_kids"],
            weights=[0.3, 0.4, 0.3],
            k=1,
        )[0]

        adults_to_create = []
        if composition == "single_adult":
            adults_to_create.append(
                {"marital_status": random.choice(["Single", "Divorced", "Widowed"])}
            )
        elif composition in ["married_couple", "family_with_kids"]:
            adults_to_create.append({"marital_status": "Married"})
            adults_to_create.append({"marital_status": "Married"})

        # Create the adult members for the household
        created_adults = []
        for adult_spec in adults_to_create:
            dob = fake.date_of_birth(minimum_age=25, maximum_age=70)
            age = get_age(dob)
            sex = random.choice(["M", "F"])

            gender, title = ("Male", "Mr.") if sex == "M" else ("Female", "Ms.")
            if random.random() > 0.98:
                gender, title = "Non-binary", "Mx."

            company_id = None
            if policy_id.startswith("G_") and age >= 16 and random.random() < 0.6:
                company_id = random.choice(company_ids)

            member_record = {
                "member_id": f"MID_{member_counter}",
                "household_id": household["household_id"],
                "policy_id": policy_id,
                "first_name": fake.first_name(),
                "last_name": household["last_name"],
                "dob": dob,
                "sex": sex,
                "gender": gender,
                "title": title,
                "marital_status": adult_spec["marital_status"],
                "salary": (
                    round(random.uniform(45000, 150000), -3)
                    if age >= 18 and company_id
                    else None
                ),
                "address": household["address"],
                "city": household["city"],
                "postal_code": household["postal_code"],
                "unit_number": household["unit_number"],
                "company_id": company_id,
                "is_transfer_policy": 0,
                "is_deleted": 0,
                "policy_status": "Active",
                "status_change_date": None,
                "rec_start_date": fake.date_between(start_date="-10y", end_date="-2y"),
                "rec_end_date": None,
            }
            members_data.append(member_record)
            created_adults.append(member_record)
            member_counter += 1

        # Logic to handle partner's last name
        if len(created_adults) > 1:
            partner1, partner2 = created_adults[0], created_adults[1]
            if partner1["sex"] != partner2["sex"]:
                male, female = (
                    (partner1, partner2)
                    if partner1["sex"] == "M"
                    else (partner2, partner1)
                )
                if random.random() > 0.80:
                    female["last_name"] = fake.last_name()
                if random.random() > 0.95:
                    male["last_name"] = female["last_name"]

        # Create children for the household if it's a family
        # Create children for the household if it's a family
        if composition == "family_with_kids":
            num_kids = random.randint(1, 3)
            for _ in range(num_kids):
                dob = fake.date_of_birth(minimum_age=0, maximum_age=18)

                # CORRECTED LOGIC: The end_date must be 'now' to create a valid range
                rec_start_date = fake.date_between(start_date=dob, end_date="now")

                members_data.append(
                    {
                        "member_id": f"MID_{member_counter}",
                        "household_id": household["household_id"],
                        "policy_id": policy_id,
                        "first_name": fake.first_name(),
                        "last_name": household["last_name"],
                        "dob": dob,
                        "sex": random.choice(["M", "F"]),
                        "gender": "Child",
                        "title": "",
                        "marital_status": "Single",
                        "salary": None,
                        "address": household["address"],
                        "city": household["city"],
                        "postal_code": household["postal_code"],
                        "unit_number": household["unit_number"],
                        "company_id": None,
                        "is_transfer_policy": 0,
                        "is_deleted": 0,
                        "policy_status": "Active",
                        "status_change_date": None,
                        "rec_start_date": rec_start_date,  # Use the corrected variable
                        "rec_end_date": None,
                    }
                )
                member_counter += 1

    # Run post-processing for SCD2 changes and transfer policies on the final, complete dataframe
    df = pd.DataFrame(members_data)
    # (The SCD2 and Transfer Policy logic from the previous version would be run here on the complete df)

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
