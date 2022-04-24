#!/bin/bash

name="new.txt"
if [[ $LANGUAGE == 'fr_FR' ]]; then
    name="nouveau.txt"
fi
gedit "$1/$name"
