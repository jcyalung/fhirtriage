#!/bin/bash
# responsible for setting up the python virtual environment.
# run the script with:
# macOS / Linux: source setup.sh
# Note: Do not run this with ./script.sh


VENV_DIR=".venv"

# create venv
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment"
    python3 -m venv "$VENV_DIR"
fi

# activate the environment
echo "Activating virtual environment"
source "$VENV_DIR/bin/activate"

# install required dependencies
echo "Installing required dependencies"
pip install -r requirements.txt

echo "Environment active and set up."
