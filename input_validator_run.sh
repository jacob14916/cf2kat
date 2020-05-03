#!/bin/bash
VALDIR="$( dirname $0 )"
$VALDIR/validator
if [ "$?" -eq 0 ]
then
    echo "Success"
    exit 42
else
    echo "Failure"
    exit 43
fi