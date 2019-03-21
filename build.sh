#!/usr/bin/env bash

set -u -e -o pipefail

readonly currentDir=$(cd $(dirname $0); pwd)
readonly distFolder=${currentDir}/dist

export NODE_PATH=${NODE_PATH:-}:${currentDir}/node_modules
VERBOSE=false
TRACE=false

source ${currentDir}/scripts/ci/_travis-fold.sh
source ${currentDir}/util-functions.sh

travisFoldStart "clean dist" "no-xtrace"
rm -rf ${distFolder}
travisFoldEnd "clean dist"

mkdir -p ${distFolder}

travisFoldStart "build package" "no-xtrace"

logInfo "Copy essential files in dist"
syncOptions=(-a --include="README.md" --include="LICENSE" --include="package.json" --exclude="*" --exclude="**/*")
syncFiles ${currentDir} ${distFolder} "${syncOptions[@]}"
unset syncOptions

logInfo "Copy lib content in dist"
syncOptions=(-a)
syncFiles "${currentDir}/lib" ${distFolder} "${syncOptions[@]}"
unset syncOptions

logInfo "Generate npm package (tgz file)"
cd ${distFolder} > /dev/null
npm pack ./ --silent

travisFoldEnd "build package"
