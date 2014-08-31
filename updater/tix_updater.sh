#!/usr/bin/env bash

# shopt -s extglob
# set -o errtrace
# set -o errexit

tix_update_initialize()
{
  DEFAULT_SOURCES=(github.com/joseignaciosg/TiX)

  BASH_MIN_VERSION="3.2.25"
  if
    [[ -n "${BASH_VERSION:-}" &&
      "$(\printf "%b" "${BASH_VERSION:-}\n${BASH_MIN_VERSION}\n" | LC_ALL=C \sort -t"." -k1,1n -k2,2n -k3,3n | \head -n1)" != "${BASH_MIN_VERSION}"
    ]]
  then
    echo "BASH ${BASH_MIN_VERSION} required (you have $BASH_VERSION)"
    exit 1
  fi

  export HOME
  export tix_trace_flag tix_debug_flag tix_path
}

log()  { printf "%b\n" "$*"; }
debug(){ [[ ${tix_debug_flag:-0} -eq 0 ]] || printf "Running($#): $*"; }
fail() { log "\nERROR: $*\n" ; exit 1 ; }

tix_get_latest_version_for_platform()
{
  return;
}

tix_update_files_and_restart() {
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
