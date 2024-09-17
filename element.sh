#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if argument is provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Check if the argument is a number
if [[ $1 =~ ^[0-9]+$ ]]; then
  QUERY_CONDITION="elements.atomic_number = $1"
else
  # The argument is a string (symbol or name)
  QUERY_CONDITION="elements.symbol = '$1' OR elements.name = '$1'"
fi

# Query for atomic number, symbol, or name
RESULT=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number=properties.atomic_number INNER JOIN types ON properties.type_id=types.type_id WHERE $QUERY_CONDITION")

# Check if result exists
if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
else
  # Read and format the result
  IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$RESULT"

  # Formatting the output
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi