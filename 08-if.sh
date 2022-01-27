#!/bin/bash

## String comparision

read -p 'Enter Username: ' username

if [ "$username" == "root" ]; then
  echo "Hey, User $username is a Admin User"
else
  echo "Hey, User $username is a Normal User"
fi

read -p 'Enter filename: ' filename

if [ -f "$filename" ]; then
  echo "File Exists"
else
  echo "File Not Found"
fi

## Note: Always try to use variable inside quotes in expressions
