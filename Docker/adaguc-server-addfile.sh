#!/bin/bash

# TODO: https://github.com/KNMI/adaguc-server/issues/71

DOCKER_ADAGUC_PATH=/adaguc/adaguc-server-master
DOCKER_ADAGUC_CONFIG=/adaguc/adaguc-server-config.xml

THISSCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

### Check if ADAGUC_PATH is set externally, if not set it to default ###
if [ ! -f "${ADAGUC_PATH}/bin/adagucserver" ]; then
  export ADAGUC_PATH=${DOCKER_ADAGUC_PATH}
fi

### Check if we can find adaguc executable at default location, otherwise try it from this location ###
if [ ! -f "${ADAGUC_PATH}/bin/adagucserver" ]; then
  export ADAGUC_PATH=${THISSCRIPTDIR}/../
fi

### Check if we could find adaguc executable ###
if [ ! -f "${ADAGUC_PATH}/bin/adagucserver" ]; then
  >&2 echo "No adagucserver executable found in path ADAGUC_PATH/bin/adagucserver [${ADAGUC_PATH}/bin/adagucserver] "
  exit 1
fi

### Check configuratiion file location ###
if [ ! -f "${ADAGUC_CONFIG}" ]; then
  export ADAGUC_CONFIG=${DOCKER_ADAGUC_CONFIG}
fi

### Checks if configuration file exists
if [ ! -f "${ADAGUC_CONFIG}" ]; then
  >&2 echo "No configuration file found ADAGUC_CONFIG variable [${ADAGUC_CONFIG}] "
  exit 1
fi

echo "Using adagucserver from  ${ADAGUC_PATH}"
echo "Using config from ${ADAGUC_CONFIG}"


export ADAGUC_TMP=/tmp
export ADAGUC_ONLINERESOURCE=""

if [ -n "$1" ]; then
  echo "Adding $1 to the available datasets."
else
  echo "You did not supply a file to add!"
  exit 1
fi

# Update all datasets
for configfile in /data/adaguc-datasets/*xml ;do
  filename=/data/adaguc-datasets/"${configfile##*/}" 
  filebasename=${filename##*/}
  if [[ "${ADAGUC_DATASET_MASK}" && `echo ${filebasename} | grep -E ${ADAGUC_DATASET_MASK}` != ${filebasename} ]] ; then
      if [[ "${ADAGUC_DATASET_MASK}" ]] ; then
          echo "${filebasename} doesn't match ${ADAGUC_DATASET_MASK}"
      fi
      continue
  fi
  echo ""
  echo "Starting update for ${filename}" 
  ${ADAGUC_PATH}/bin/adagucserver --updatedb --config ${ADAGUC_CONFIG},${filename} --path $1
  OUT=$?
  if [ -d /servicehealth ]; then
    echo "$OUT" > /servicehealth/${filebasename%.*}
  fi
done
