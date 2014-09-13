#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/tix_lib.sh

get_os
get_variant

current_branch = $(git rev-parse --abbrev-ref HEAD)

echo "Moving to 'releases' branch"
git checkout origin/releases;
git checkout releases;
echo "Creating or moving to branch release/$os/$variant"
git checkout -b release/$os/$variant

echo "Clearing 'releases' folder"
rm -rf releases/*
echo "Copying files from $current_branch"
git checkout $current_branch -- releases/
echo "Commiting release"
git commit -m "Release sources for $os/$variant/head"
echo "Creating tag"
git tag $os/$variant/head --force
echo "Created tag $os/$variant/head on branch release/$os/$variant"
echo "Finishing..."
git checkout $current_branch
echo "DONE!"

