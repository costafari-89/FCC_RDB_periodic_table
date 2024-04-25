#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#Defining function to be used in user input check
RETURN_INFO() {
#defining input as user_input
USER_INPUT=$1

#check if user input is a number
if [[ ! $USER_INPUT =~ ^[0-9]+$ ]]
then
  #Try to return data from user input
  ELEMENT_DATA=$($PSQL"SELECT * FROM elements WHERE symbol='$USER_INPUT' OR name='$USER_INPUT'")
  
  #check if name or symbol exists in elements
  if [[ -z $ELEMENT_DATA ]]
  then
    #if the user input does not exist
    echo I could not find that element in the database.
  else
    #if user input exists
    #get atomic number from elements table user symbol or name
    ATOMIC_NUMBER=$($PSQL"SELECT atomic_number FROM elements WHERE symbol='$USER_INPUT' OR name='$USER_INPUT'")
    #get symbol from elements using atomic number
    SYMBOL=$($PSQL"SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    #get element name from elements using atomic number
    ELEM_NAME=$($PSQL"SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")

    #get data from properties table
    ATOMIC_MASS=$($PSQL"SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL"SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL"SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    ELEM_TYPE=$($PSQL"SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

    #get data from types table
    ELEM_TYPE_NAME=$($PSQL"SELECT type FROM types WHERE type_id=$ELEM_TYPE")
    
    #echo output in the correct format
    echo -e "The element with atomic number $ATOMIC_NUMBER is $ELEM_NAME ($SYMBOL). It's a $ELEM_TYPE_NAME, with a mass of $ATOMIC_MASS amu. $ELEM_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
  
else
  #check if number exists
  ELEMENT_DATA=$($PSQL"SELECT * FROM elements WHERE atomic_number=$USER_INPUT")
  if [[ -z $ELEMENT_DATA ]]
  then
    #if the user input does not exist
    echo I could not find that element in the database.
  else
    #Assign user input to atomic number since we know it is a number and it exists
    ATOMIC_NUMBER=$USER_INPUT

    #Get info from elements table using atomic number
    SYMBOL=$($PSQL"SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")    
    ELEM_NAME=$($PSQL"SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")

    #Get info from properties table using atomic number
    ATOMIC_MASS=$($PSQL"SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL"SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL"SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    ELEM_TYPE=$($PSQL"SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

    #Get info from types table using elem type from properties
    ELEM_TYPE_NAME=$($PSQL"SELECT type FROM types WHERE type_id=$ELEM_TYPE")

    #echo output in the correct format
    echo -e "The element with atomic number $ATOMIC_NUMBER is $ELEM_NAME ($SYMBOL). It's a $ELEM_TYPE_NAME, with a mass of $ATOMIC_MASS amu. $ELEM_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
  
fi
}

#Check that the script is ran with an input
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  #calling function defined above using input from script
  RETURN_INFO $1
fi

