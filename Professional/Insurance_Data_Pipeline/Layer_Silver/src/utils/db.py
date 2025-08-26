import sqlite3
import pandas as pd
import logging
import datetime
from pathlib import Path

# Get a logger for this module
logger = logging.getLogger(__name__)


def create_oltp_database(dataframes, column_schemas, db_name):
    """
    Loads all dataframes into a SQLite database using a master column schema.
    It will create the output directory if it does not exist.
    """
    try:
        # Ensure the output directory exists before trying to connect.
        db_path = Path(db_name)
        db_path.parent.mkdir(parents=True, exist_ok=True)

        conn = sqlite3.connect(db_name)
        logger.info(f"Connecting to database '{db_name}'...")

        for table_name, df in dataframes.items():
            logger.info(f"Writing table '{table_name}'...")
            df_copy = df.copy()

            # Convert date-like objects to strings for SQLite compatibility
            for col in df_copy.columns:
                if df_copy[col].dtype == "object" and not df_copy[col].dropna().empty:
                    if isinstance(
                        df_copy[col].dropna().iloc[0],
                        (datetime.date, datetime.datetime),
                    ):
                        df_copy[col] = df_copy[col].apply(
                            lambda x: x.strftime("%Y-%m-%d") if pd.notna(x) else None
                        )

            table_schema = {
                col: column_schemas[col]
                for col in df_copy.columns
                if col in column_schemas
            }
            df_copy.to_sql(
                table_name, conn, if_exists="replace", index=False, dtype=table_schema
            )

        logging.info("OLTP Database creation complete.")

    except sqlite3.Error as e:
        logger.error(f"A database error occurred: {e}")
        # Re-raise the exception to be caught by the main try-except block
        raise
    finally:
        if "conn" in locals() and conn:
            conn.close()
