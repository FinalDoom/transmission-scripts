#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z ${TR_AUTH+x} ] || [ ! -z ${1+x} ]
then
    if [ -f $SCRIPT_DIR/.transmissionUser -a -f $SCRIPT_DIR/.transmissionPassword ]
    then
        export TRANSMISSION_USER="$(cat $SCRIPT_DIR/.transmissionUser)"
        export TRANSMISSION_PASSWORD="$(cat $SCRIPT_DIR/.transmissionPassword)"
    else
        read -p 'Enter user for Transmission: ' TRANSMISSION_USER
        read -sp 'Enter password for Transmission: ' TRANSMISSION_PASSWORD
        export TRANSMISSION_USER="$TRANSMISSION_USER"
        export TRANSMISSION_PASSWORD="$TRANSMISSION_PASSWORD"
        read -p "Do you want to record these in .transmissionUser and .transmissionPassword (skip future prompts)? [y/N] " yn
        case $yn in
            [Yy]* ) 
                    echo $TRANSMISSION_USER > $SCRIPT_DIR/.transmissionUser
                    echo $TRANSMISSION_PASSWORD > $SCRIPT_DIR/.transmissionPassword
                    ;;
            [Nn]* )
                    ;;
            * )
                    ;;
        esac
    fi

    export TR_AUTH="$TRANSMISSION_USER:$TRANSMISSION_PASSWORD"
fi
