#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd ${DIR}
install -d build
cd build
cmake ../c

PROC_COUNT=`getconf _NPROCESSORS_ONLN`

make -j${PROC_COUNT} install

echo "Done"
