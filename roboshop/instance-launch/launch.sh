#!/bin/bash

COMPONENT=$1

## -z validates the variable empty , true if it is empty.
if [ -z "${COMPONENT}" ]; then
  echo "Component Input is Needed"
  exit 1
fi

LID=lt-090f6832097248547
LVER=2

## Validate If Instance is already there

INSTANCE_CREATE() {
  INSTANCE_STATE=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}"  | jq .Reservations[].Instances[].State.Name | xargs -n1)
  if [ "${INSTANCE_STATE}" = "running" ]; then
    echo "${COMPONENT} Instance already exists!!"
    exit 0
  fi

  if [ "${INSTANCE_STATE}" = "stopped" ]; then
    echo "${COMPONENT} Instance already exists!!"
    exit 0
  fi

  aws ec2 run-instances --launch-template LaunchTemplateId=${LID},Version=${LVER}  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" | jq

}