#!/bin/bash

# Set the path to domain-scan.
export DOMAIN_SCAN_PATH=/opt/scan/domain-scan/scan

# Set the path to the pshtt CLI.
export PSHTT_PATH=/opt/scan/pshtt/pshtt_cli

# go to pulse environment home
cd $HOME/pulse/$PULSE_ENV/current

# load environment and virtualenv
source $HOME/.bashrc
workon pulse-$PULSE_ENV
# source $HOME/.virtualenvs/pulse-$PULSE_ENV/bin/activate

# run the relevant env-specific data update path
make update_$PULSE_ENV
