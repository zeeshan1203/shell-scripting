#!/bin/bash

# Fundamentally there are two loops 1. while 2. for
# Inverse the logic of those two loops we have another tow more loops 3. until 4. select

# Syntax
# while [ expression ] ; do
# commands
#done

i=10
while [ $i -gt 0 ]; do
  echo $i
  i=$(($i-1))
done

# for var in values ; do
# commands
# done

for fruit in apple banana orange ; do
  echo Fruit Name = $fruit
  sleep 1
done
