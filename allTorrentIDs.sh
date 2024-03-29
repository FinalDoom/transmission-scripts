#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source $SCRIPT_DIR/assertPassword.sh

transmission-remote -ne -l | awk '{ print $1 }' | grep -v 'Sum:\|ID' | tr -d '*'
