#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/tix_lib.sh

get_os
get_variant

current_branch=$(git rev-parse --abbrev-ref HEAD)

create_new_tag() {
  echo "Commiting the package"
  git add -A .
  git commit -m "Release sources for $os/$variant/head"
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
  git add -A .
  git commit -m "Release sources for $os/$variant/head"
  echo "Creating tag"
  git tag $os/$variant/head --force
  echo "Created tag $os/$variant/head on branch release/$os/$variant"
  echo "Finishing..."
  git checkout $current_branch
  echo "DONE!"
}

package_os() {
  get_os
  case $os in
    linux)
      $DIR/../scripts/package_linux.sh
      ;;
    mac)
      $DIR/../scripts/package_osx.sh
      ;;
  esac
}

prepare_files() {
  get_os
  get_variant
  rm -rf $DIR/../releases/*
  case $os in
    linux)
      cp -r $DIR/../dist/TixApp $DIR/../releases/
      ;;
    mac)
      cp -r $DIR/../dist/Tix.app $DIR/../releases/
      ;;
  esac
}

tix_release_version() {
  package_os
  prepare_files
  create_new_tag
}

tix_release_version "$@"
