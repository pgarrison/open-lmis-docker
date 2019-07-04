#!/bin/sh

if [ -r open_lmis.dump ];
then
    echo "Loading open_lmis database..."
    dropdb -U postgres open_lmis
    createdb -U postgres open_lmis
    psql -U postgres open_lmis -f open_lmis.dump
    echo "... db loaded"
else
    echo "No database found to load, using default open_lmis"
fi
