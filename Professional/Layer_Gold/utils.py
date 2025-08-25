# Layer_Gold/utils.py
from pathlib import Path
import yaml
import re


def parse_config_variables(config):
    """
    Parses a config dictionary to replace ${{ ... }} variables.
    """
    raw_config_str = str(config)
    variables = re.findall(r"\$\{\{ ([\w.]+) \}\}", raw_config_str)

    for var in variables:
        keys = var.split(".")
        value = config
        for key in keys:
            value = value[key]
        raw_config_str = raw_config_str.replace(f"'${{{{ {var} }}}}'", f"'{value}'")

    return eval(raw_config_str)


def load_and_parse_config():
    """
    Loads the config.yml file from the script's directory and parses its variables.
    """
    # This correctly finds the config.yml in the same folder as this utils.py file
    config_path = Path(__file__).parent / "config.yaml"
    with open(config_path, "r") as f:
        raw_config = yaml.safe_load(f)
    return parse_config_variables(raw_config)
