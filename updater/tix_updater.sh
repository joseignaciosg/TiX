#!/usr/bin/env bash

# shopt -s extglob
# set -o errtrace
# set -o errexit

tix_update_initialize()
{
  DEFAULT_SOURCES=(github.com/joseignaciosg/TiX)
  export HOME
  export tix_trace_flag tix_debug_flag tix_path
}

log()  { printf "%b\n" "$*"; }
debug(){ [[ ${tix_debug_flag:-0} -eq 0 ]] || printf "Running($#): $*"; }
fail() { log "\nERROR: $*\n" ; exit 1 ; }


get_sha_for_file() {
  current_sha=$(curl -sSL https://api.github.com/repos/joseignaciosg/TiX/git/refs/tags/linux/test/head | sed 's/[{}]/''/g' | grep "\"sha\"" | awk '{ print $2 }' | sed 's/\"//g' | sed 's/,//g')
  export current_sha;
}

get_and_unpack() {
  typeset _url
  _url=${1}
  _file="release.zip"
  if [[ $current_sha == $(cat release.zip.sha) ]]; then
    echo "Avoiding redownload based on githubs' SHA"
  else
    echo Downloading from $_url;
    $(which curl) -sSL ${_url} -o ./${_file}
    sha=$(unzip -l ${_file} | head -n 2 | tail -n 1)
    echo $sha > release.zip.sha
  fi
}

get_os() {
  os="linux"
  case `uname` in
    Linux)
      os="linux"
      ;;
    Darwin)
      os="mac"
      ;;
  esac
  os="linux"
}

get_variant() {
  variant="mavericks";
  case $os in
    linux)
      uname=$(uname -a)
      if [[ $uname =~ "x86" ]]; then
        variant="x86"
      fi
      if [[ $uname =~ "i386" ]]; then
        variant="x86"
      fi
      if [[ $uname =~ "i686" ]]; then
        variant="x86"
      fi
      if [[ $uname =~ "x86_64" ]]; then
        variant="x64"
      fi
      if [[ $uname =~ "x64" ]]; then
        variant="x64"
      fi
      ;;
    mac)
      ver=$(uname -a | awk '{ print $3 }');
      if [[ $ver =~ "13" ]]; then
        variant="mavericks"
      fi
      if [[ $ver =~ "12" ]]; then
        variant="mountain_lion"
      fi
      ;;
  esac
  variant="test";
}

tix_get_latest_version_for_platform()
{
  DEFAULT_SOURCES=(github.com/joseignaciosg/TiX)
  typeset _source _sources _url _version
  get_os
  get_variant
  _sources=$DEFAULT_SOURCES
  _version="$os/$variant/head"
  for _source in "${_sources[@]}"
  do
    case ${_source} in
      (bitbucket.org*)
        _url=https://${_source}/get/${_version}.zip
        echo "UNSUPPORTED API CALL ON BITBUCKET"
        ;;
      (*)
        _url=https://${_source}/archive/${_version}.zip
        _api_url=https://api.$(echo $_source | sed 's/github\.com/github\.com\/repos/')/git/refs/tags/${_version}
        ;;
    esac
    get_sha_for_file ${_api_url}
    get_and_unpack ${_url} && return
  done
  return;
}

# Chino
tix_update_files_and_restart() {
  mkdir -p downloaded;
  invalid_file=$(file release.zip | grep ASCII | wc -l)
  if [[ $invalid_file -eq 1 ]]; then
    echo "INVALID UPDATE FILE -- PLEASE CHECK THE DOWNLOAD URL";
  fi
  if [[ $invalid_file -eq 0 ]]; then
    unzip release.zip downloaded;

    # matando proceso
    for i in $(ps aux | grep "/etc/TIX/app/TixClientApp" | grep -v grep | awk '{ print $2 }' | sort -n)
    do
       echo killing process with pid ${i}
       kill -9 ${i}
    done

    echo "Restarint server"
    # /etc/TIX/app/startupAppCaller.sh
    return;
  fi
}


tix_update()
{
  # Hace las validaciones iniciales para garantizar que el script funcione, o falla y deja algo en algún log.
  tix_update_initialize
  # Obtiene la última versión del servidor (a definir) y lo extrae en /tmp/tix_update/
  tix_get_latest_version_for_platform
  # Agarra los archivos /tmp/tix_update/ y los copia sobre donde se encuentre la instalación actual, o instala el update, según la plataforma.
  tix_update_files_and_restart
}

tix_update "$@"

