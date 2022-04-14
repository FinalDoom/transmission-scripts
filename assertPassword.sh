#!/usr/bin/env bash

if [ -z ${TRANSMISSION_PASSWORD+x} ]
then
    read -sp 'Enter password for Transmission: ' TRANSMISSION_PASSWORD
    export TRANSMISSION_PASSWORD="$TRANSMISSION_PASSWORD"
fi