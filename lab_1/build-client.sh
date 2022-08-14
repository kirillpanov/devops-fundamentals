#!/bin/bash

projectDir=../../shop-angular-cloudfront

function install {
    cd $projectDir
    pwd
    npm install
}

if [[ $1 == "i" ]]
then
  install
fi

function build {
  if [[ $1 == "--configuration" ]]
  then
    local configuration=$2
  fi

  cd $projectDir
  npm run build --configuration=$configuration

  clientBuildFile=./dist/app/client-app.zip

  if [ -e "$clientBuildFile" ]; then
    rm "$clientBuildFile"
    echo "$clientBuildFile was removed."
  fi

  zip -r $clientBuildFile ./dist/app
}

"$@"