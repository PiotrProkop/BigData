#/usr/bin/env bash

if [ "$1" == "" ]
then
  echo "Please provide directory"
  exit 1
fi

DIRECTORY=$1

rm -rf $1/*.log.*
rm -rf $1/*.out.*
