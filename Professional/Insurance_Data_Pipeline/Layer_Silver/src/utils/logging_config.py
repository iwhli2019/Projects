import logging
import sys
from pathlib import Path
import datetime


def setup_logging(config):
    """Configures logging to write to a timestamped file and the console."""
    log_config = config["logging"]
    log_dir = Path(log_config["log_directory"])
    log_dir.mkdir(parents=True, exist_ok=True)
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file_path = log_dir / f"{log_config['log_prefix']}{timestamp}.log"

    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s - %(levelname)s - %(message)s",
        handlers=[
            logging.FileHandler(log_file_path, encoding="utf-8"),
            logging.StreamHandler(sys.stdout),
        ],
    )
    return log_file_path
