import logging
import pandas as pd
import random
import datetime

logger = logging.getLogger(__name__)


def generate_financial_transactions(config, member_policies_df, fake):
    """Generates financial transactions for members based on their policies."""
    logger.info("Generating financial transactions...")
    transactions = []
    transaction_id_counter = 10001

    for _, row in member_policies_df.iterrows():
        # --- Generate Premium Payments ---
        start_date = pd.to_datetime(row["policy_start_date"])
        end_date = (
            pd.to_datetime(row["policy_end_date"])
            if pd.notna(row["policy_end_date"])
            else datetime.datetime.now()
        )

        current_date = start_date
        while current_date < end_date:
            transactions.append(
                {
                    "transaction_id": f"TRN_{transaction_id_counter}",
                    "member_id": row["member_id"],
                    "policy_id": row["policy_id"],
                    "transaction_date": current_date.date(),
                    "transaction_type": "Premium Payment",
                    "transaction_amount": -random.uniform(
                        150, 500
                    ),  # Negative for payment
                    "description": f"Monthly premium for policy {row['policy_id']}",
                }
            )
            transaction_id_counter += 1
            # Move to next month
            current_date = current_date + pd.DateOffset(months=1)

    # In a full script, you would also link salary deposits and claim payouts here.
    return pd.DataFrame(transactions)
