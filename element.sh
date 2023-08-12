#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

CHECK_IF_ARGUMENT_EXISTS() {
  if [[ ! $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  CHECK_ARGUMENT_VALUE $1
fi
}

CHECK_ARGUMENT_VALUE() {
  # check argument 
  if [[ $1 =~ ^[1-9] ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
    if [[ -z $ELEMENT ]] 
    then
      NO_ELEMENT
    else
      PRINT_ELEMENT $ELEMENT
    fi
  elif [[ $1 =~ ^[A-Z]$|^[A-Z][a-z]$ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1'")
    if [[ -z $ELEMENT ]] 
    then
      NO_ELEMENT
    else
      PRINT_ELEMENT $ELEMENT
    fi
  else
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1'")
    if [[ -z $ELEMENT ]] 
    then
      NO_ELEMENT
    else
      PRINT_ELEMENT $ELEMENT
    fi
  fi
}

PRINT_ELEMENT() {
  echo "$@" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELT BAR BOIL
  do
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  done
}

NO_ELEMENT() {
  echo 'I could not find that element in the database.'
}

CHECK_IF_ARGUMENT_EXISTS $1
