#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/tix_lib.sh

get_os
get_variant

echo "Moving to 'releases' branch"
echo git checkout origin/releases;
echo git checkout releases;
echo "Creating or moving to branch release/$os/$variant"
echo git checkout -b release/$os/$variant

echo "Clearing 'releases' folder"
echo rm -rf releases/*
echo "Copying files from master"
echo git checkout master -- releases/
echo "Creating tag"
echo git tag $os/$variant/head --force
