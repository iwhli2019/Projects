import logging
import pandas as pd
import random
import datetime

logger = logging.getLogger(__name__)


def generate_claims(
    config,
    df_member_policies,
    df_affiliations,
    df_link,
    df_fee_schedule,
    df_policies,
    fake,
):
    """Generates the main Claims fact table based on active policy enrollments."""
    logger.info("Generating claims...")
    claims_data = []

    # --- CORRECTED LOGIC ---
    # Find active enrollments from the member_policies table, not the members table
    active_policies_df = df_member_policies[
        df_member_policies["policy_end_date"].isnull()
    ].copy()

    params = config["claim_parameters"]
    fraud_rate_range = config["proportions"]["fraud_rate"]
    FRAUD_RATE = random.uniform(fraud_rate_range[0], fraud_rate_range[1])

    for i in range(config["record_counts"]["num_claims"]):
        valid_link = df_link.sample(1).iloc[0]

        if active_policies_df.empty:
            logger.warning(
                "No active policies found to generate claims for. Skipping claim generation."
            )
            break

        # Sample from active policies, not active members
        active_policy_enrollment = active_policies_df.sample(1).iloc[0]
        member_policy_details = df_policies[
            df_policies["policy_id"] == active_policy_enrollment["policy_id"]
        ].iloc[0]

        affiliation = df_affiliations.sample(1).iloc[0]
        is_fraudulent = 1 if random.random() < FRAUD_RATE else 0
        base_fee = df_fee_schedule[
            df_fee_schedule["procedure_code"] == valid_link["procedure_code"]
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

        agreed_fee = df_fee_schedule.loc[
            (df_fee_schedule["procedure_code"] == valid_link["procedure_code"])
            & (df_fee_schedule["network_status"] != "Out-of-Network"),
            "agreed_fee",
        ].mean()

        paid_amt = round(
            max(0, agreed_fee - member_policy_details["copay_amt"])
            * (1 - member_policy_details["coinsurance_pct"]),
            2,
        )
        if is_fraudulent:
            paid_amt = submitted_amt

        service_date = fake.date_time_between(start_date="-2y", end_date="now")
        submit_lag = random.randint(*params["submit_date_lag_days"])

        claims_data.append(
            {
                "claim_id": f"CLM_{50001 + i}",
                "member_id": active_policy_enrollment[
                    "member_id"
                ],  # Get member_id from the enrollment
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
