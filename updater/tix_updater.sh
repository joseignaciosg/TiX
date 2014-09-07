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

get_and_unpack() {
  typeset _url
  _url=${1}
  _file="release.zip"
  echo Downloading from $_url;
  $(which curl) -sSL ${_url} -o ./${_file}
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
}

tix_get_latest_version_for_platform()
{
  DEFAULT_SOURCES=(github.com/joseignaciosg/TiX)
  typeset _source _sources _url _version
  _sources=$DEFAULT_SOURCES
  get_os
  get_variant
  _version="$os/$variant/head"
  for _source in "${_sources[@]}"
  do
    case ${_source} in
      (bitbucket.org*)
        _url=https://${_source}/get/${_version}.zip
        ;;
      (*)
        _url=https://${_source}/archive/${_version}.zip
        ;;
    esac
    get_and_unpack ${_url} && return
  done
  return;
}

# Chino
tix_update_files_and_restart() {
  # Borrar todo lo que está en /Applications/TixApp/
  # Reemplzar por todo o que bajé
  #
  return;
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

