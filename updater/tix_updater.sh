#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/tix_lib.sh

tix_update_initialize()
{
  DEFAULT_SOURCES=(github.com/joseignaciosg/TiX)
  export HOME
  export tix_trace_flag tix_debug_flag tix_path tix_cancel
}
<<<<<<< HEAD
get_sha_for_file() { 
  current_sha=$( ( curl -sSL ${_api_url} || (wget -q -O- ${_api_url}) ) | sed 's/[{}]/''/g' | grep "\"sha\"" | awk '{ print $2 }' | sed 's/\"//g' | sed 's/,//g')
=======
get_sha_for_file() {
  current_sha=$(curl -sSL ${_api_url} | sed 's/[{}]/''/g' | grep "\"sha\"" | awk '{ print $2 }' | sed 's/\"//g' | sed 's/,//g')
>>>>>>> 452c3ca15b685e80d62a1526e915373bbb26da2e
  export current_sha;
}

no_release_found() {
  echo ERROR: No release found for the current operating system!
  tix_cancel=true
  export tix_cancel
}

get_and_unpack() {
  typeset _url
  _url=${1}
  _file="release.zip"
  if [[ $current_sha == "" ]]; then
    no_release_found
  else
    if [[ $current_sha == $(cat release.zip.sha) ]]; then
      echo "Avoiding redownload based on githubs' SHA"
    else
      echo Downloading from $_url;
      curl -sSL ${_url} -o ./${_file} || (wget -q -O- ${_url} > ./${_file})
      sha=$(unzip -l ${_file} | head -n 2 | tail -n 1)
      if [[ $sha =~ /release\.zip/ ]]; then
        no_release_found
      else
        echo $sha > release.zip.sha
      fi
    fi
  fi
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
    _url=https://${_source}/archive/${_version}.zip
    _api_url=https://api.$(echo $_source | sed 's/github\.com/github\.com\/repos/')/git/refs/tags/${_version}
    get_sha_for_file ${_api_url}
    get_and_unpack ${_url} && return
  done
  return;
}

tix_extract_files() {
  echo "Extracting files to ./downloaded"
  unzip release.zip -d downloaded > /dev/null;
  mkdir downloaded.1
  mv downloaded/*/* downloaded.1;
  rm -rf downloaded
  mv downloaded.1 downloaded;
}

tix_kill_processes() {
  echo "Killing processes"
  for i in $(ps aux | grep "/etc/TIX/app/TixClientApp" | grep -v grep | awk '{ print $2 }' | sort -n)
  do
     kill -9 ${i} 2>&1;
  done
}

tix_update_files_and_restart() {
  rm -rf downloaded;
  mkdir -p downloaded;
  invalid_file=$(file release.zip | grep ASCII | wc -l)
  if [[ $invalid_file -eq 1 ]]; then
    echo "ERROR: INVALID UPDATE FILE -- PLEASE CHECK THE DOWNLOAD URL"
  else
    tix_extract_files
    tix_kill_processes
    get_os
    case $os in
      linux)

        sudo cp -rfv downloaded/releases/TixApp/* /usr/share/tix/
        ;;
      mac)
        sudo cp -rfv downloaded/releases/TixApp.app/* /Applications/TixApp.app/
		;;
    esac
  fi
}

tix_update()
{
  # Hace las validaciones iniciales para garantizar que el script funcione, o falla y deja algo en algún log.
  tix_update_initialize
  # Obtiene la última versión del servidor (a definir) y lo extrae en /tmp/tix_update/
  tix_get_latest_version_for_platform
  if [[ $tix_cancel == true ]]; then
    echo ERROR: Error getting the latest TiX release
  else
    # Agarra los archivos /tmp/tix_update/ y los copia sobre donde se encuentre la instalación actual, o instala el update, según la plataforma.
    tix_update_files_and_restart
  fi
}

tix_update "$@"

