#!/bin/bash

COMPONENT=$1

## -z validates the variable empty, true if it is empty.
if [ -z "${COMPONENT}"]; then
  echo "Component Input is Needed"
  exit 1
fi

LID=lt-0d29253072b5c5d49
LVER=1

## Validate if instance is already there

