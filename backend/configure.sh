#!/bin/bash
virtualenv -p python3 .venv
source .venv/bin/activate
pip install poetry
poetry install
