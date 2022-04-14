#!/usr/bin/env bash

if [ -z ${TRANSMISSION_PASSWORD+x} ]
then
    if [ -f .transmissionPassword ]
    then
        export TRANSMISSION_PASSWORD="$(cat .transmissionPassword)"
    else
        read -sp 'Enter password for Transmission: ' TRANSMISSION_PASSWORD
        export TRANSMISSION_PASSWORD="$TRANSMISSION_PASSWORD"
    fi
fi