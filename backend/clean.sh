#!/bin/bash
# remove the .venv directory and perform a basic cleanup of temporary files

VENV_DIR=".venv"

if [ -d "$VENV_DIR" ]; then
    echo "Removing virtual environment directory: $VENV_DIR"
    rm -rf "$VENV_DIR"
else
    echo "No virtual environment directory ($VENV_DIR) found."
fi

# Optionally clean up __pycache__ and .DS_Store files
echo "Removing Python cache files and macOS artifacts..."
find . -type d -name "__pycache__" -exec rm -rf {} +
find . -name ".DS_Store" -delete

echo "Cleanup complete."
