from pathlib import Path
import os
import datetime
from utils import load_and_parse_config  # Import the correct function

# --- Configuration ---

config = load_and_parse_config()
script_dir = Path(__file__).parent
# print(f"script_dir: {script_dir}")

# Get the parent directory (the 'Professional' folder)
project_root = script_dir.parent
# print(f"project_root: {project_root}")

# Construct the path to the source directory
source_dir = project_root / "Layer_Silver" / "output"

try:
    db_files = [
        f
        for f in source_dir.glob("*.db")
        if not f.name.endswith((".db-journal", ".db-wal", ".db-shm"))
    ]

    if not db_files:
        print("No valid .db files found.")
        exit(1)

    latest_file = max(db_files, key=lambda f: f.name)
    absolute_path = latest_file.resolve().as_posix()
    print(f"Latest source selected: {latest_file.name}")

    # Check for and create the output data folder
    output_dir = script_dir / "datamarts_dbt" / "data"
    output_dir.mkdir(parents=True, exist_ok=True)

    # Define the path for the output database
    output_db_path = output_dir / "layer_gold.db"

    # Store both paths in a single environment file
    env_file_path = script_dir / "latest_source_path.env"
    with open(env_file_path, "w") as f:
        f.write(f"DBT_SOURCE_FILE_PATH={absolute_path}\n")
        f.write(f"DBT_OUTPUT_FILE_PATH={output_db_path.resolve().as_posix()}")

except FileNotFoundError as e:
    print(f"Error: Directory not found - {e}")
    exit(1)
