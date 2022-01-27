#!/bin/bash

## Declare a function

SAMPLE() {
  echo Welcome to SAMPLE Function
  return 5
  echo Value of a = $a
  b=20
  echo First Argument = $1
}

## Access your function
a=10
SAMPLE xyz
SAMPLE $1
echo Exit Status of SAMPLE Function = $?
echo Value of b = $b
