#!/bin/bash

function validateLatinLetters {
  if [[ $1 =~ ^[A-Za-z_]+$ ]]; 
    then return 0; 
  else 
    return 1; 
  fi
}

