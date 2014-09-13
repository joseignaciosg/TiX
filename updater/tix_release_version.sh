#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/tix_lib.sh

get_os
get_variant

current_branch=$(git rev-parse --abbrev-ref HEAD)

create_new_tag() {
  echo "Commiting the package"
  git add -A . > /dev/null
  git commit -m "Release sources for $os/$variant/head" > /dev/null
  echo "Moving to 'releases' branch"
  git checkout origin/releases > /dev/null
  git checkout releases > /dev/null
  echo "Clearing 'releases' folder"
  rm -rfv *
  echo "Copying files from $current_branch"
  git checkout $current_branch -- releases/ > /dev/null
  echo "Commiting release"
  git add -A . > /dev/null
  git commit -m "Release sources for $os/$variant/head" > /dev/null
  echo "Creating tag"
  git tag $os/$variant/head --force > /dev/null
  echo "Created tag $os/$variant/head on branch releases"
  echo "Finishing..."
  git checkout $current_branch > /dev/null
  echo "DONE!"
}

package_os() {
  echo "Packaging TIX..."
  get_os
  case $os in
    linux)
      $DIR/../scripts/package_linux.sh 2>&1 | xargs echo > /dev/null
      ;;
    mac)
      $DIR/../scripts/package_osx.sh 2>&1 | xargs echo > /dev/null
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
      cp -r $DIR/../dist/TixApp.app $DIR/../releases/
      ;;
  esac
}

tix_release_version() {
  package_os
  prepare_files
  create_new_tag
}

tix_release_version "$@"
