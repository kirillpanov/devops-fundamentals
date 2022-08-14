#!/bin/bash

projectDir=../../shop-angular-cloudfront
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

cd $projectDir
declare -i exitCode=0

if [[ $(npm audit | grep "high severity") ]]
then
  echo -e "${RED}Audit failed${NC}"
  exitCode=1
else
  echo -e "${GREEN}Audit passed${NC}"
fi
if [[ $(node ./node_modules/@angular/cli/bin/ng test --watch false) ]]
then
  echo -e "${RED}Tests failed${NC}"
  exitCode=1
fi
if [[ $(npm run lint) ]]
then
  echo -e "${GREEN}Lint passed${NC}"
else
  echo -e "${RED}Lint failed${NC}"
  exitCode=1
fi
exit $exitCode
