#!/bin/bash

source ./internal/validators.sh

fileName=users.db
fileDir=../data
filePath=$fileDir/$fileName

if [ "$1" == "" ]
then
  help
fi

if [[ "$1" != "" && "$1" != "help" && ! -f ../data/users.db ]];
then
  read -r -p "users.db does not exist. Do you want to create it? [Y/n] " createFile

	if [[ "$createFile" =~ ^(yes|y|Y)$ ]];
  then
  	touch $filePath
    echo "File ${fileName} was created."
  else
    echo "File ${fileName} must be created to continue. Try again."
    exit 1
  fi
fi


function add(){
  read -p "Enter user name: " username
  validateLatinLetters $username
  
	if [[ "$?" == 1 ]];                                     
	then                                                  
	  echo "Name must have only latin letters. Try again."                      
	  exit 1
  fi       

	read -p "Enter user role: " role
  validateLatinLetters $role

  if [[ "$?" == 1 ]]
  then
    echo "Role must have only latin letters. Try again."
    exit 1
  fi

  echo "${username}, ${role}" | tee -a $filePath 
}

function backup {
  backupFileName=$(date +'%F-%T')-users.db.backup
  cp $filePath $fileDir/$backupFileName

  echo "Backup $backupFileName is created."
}

function restore {
  lastBackupFile=$(ls $fileDir/*-$fileName.backup | tail -n 1)

  if [[ ! -f $lastBackupFile ]]
  then
    echo "No backup file(s) found."
    exit 1
  fi

  cat $lastBackupFile > $filePath

  echo "Backup is restored."
}

function find {
  read -p "Enter user name for search: " userName
  local searchResults=`grep -i $userName $filePath`

  if [ "$searchResults" ]
    then
      echo "$searchResults"
    else
      echo "User '$userName' not found"
  fi
}

function list {
  if [[ $1 == "inverse" ]]
  then
    #macOS workaround
    if ! command -v tac &> /dev/null
    then
      tac='tail -r'
      cat -n $filePath | $tac
    else
      cat -n $filePath | tac
    fi
  else
    cat -n $filePath
  fi
}

function help {
  echo "'$0' is intended for process operations with users database and supports next commands:"
  echo -e "\tadd -> add new entity to database;"
  echo -e "\thelp -> provide list of all available commands;"
  echo -e "\tbackup -> create a copy of current database;"
  echo -e "\trestore -> replaces database with its last created backup;"
  echo -e "\tfind -> found all entries in database by username;"
  echo -e "\tlist -> prints content of database and accepts optional 'inverse' param to print results in opposite order."
  exit 0
}


"$@"
