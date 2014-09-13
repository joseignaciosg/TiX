#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/tix_lib.sh

get_os
get_variant

echo "Moving to 'releases' branch"
git checkout origin/releases;
git checkout releases;
echo "Creating or moving to branch release/$os/$variant"
git checkout -b release/$os/$variant

echo "Clearing 'releases' folder"
rm -rf releases/*
echo "Copying files from master"
git checkout master -- releases/
echo "Creating tag"
git tag $os/$variant/head --force
