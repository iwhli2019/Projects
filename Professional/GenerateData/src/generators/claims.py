import random
import logging
import datetime
import pandas as pd


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
