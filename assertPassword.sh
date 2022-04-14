#!/usr/bin/env bash

if [ -z ${TRANSMISSION_PASSWORD+x} ]
then
    if [ -f .transmissionUser -a -f .transmissionPassword ]
    then
        export TRANSMISSION_USER="$(cat .transmissionUser)"
        export TRANSMISSION_PASSWORD="$(cat .transmissionPassword)"
    else
        read -p 'Enter user for Transmission: ' TRANSMISSION_USER
        read -sp 'Enter password for Transmission: ' TRANSMISSION_PASSWORD
        export TRANSMISSION_USER="$TRANSMISSION_USER"
        export TRANSMISSION_PASSWORD="$TRANSMISSION_PASSWORD"
        read -p "Do you want to record these in .transmissionUser and .transmissionPassword (skip future prompts)? [y/N] " yn
        case $yn in
            [Yy]* ) 
                    echo $TRANSMISSION_USER > .transmissionUser
                    echo $TRANSMISSION_PASSWORD > .transmissionPassword
                    ;;
            [Nn]* )
                    ;;
            * )
                    ;;
        esac
    fi
fi

export TRANSMISSION_CREDENTIALS="$TRANSMISSION_USER:$TRANSMISSION_PASSWORD"