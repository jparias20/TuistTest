#!/bin/bash
set -e
SOURCE=$1
if grep --include \*.swift --exclude-dir=./Tuist --exclude-dir=./**/Tests -R -E \
    "^(public\s)(\w+\s)?(enum|struct|class|protocol|actor|typealias){1}\s${PRODUCT_NAME}(:\s|\s{|\s=}{1})" $SOURCE
then
    echo "There is a public symbol with the same name as the package $PRODUCT_NAME. This is a error, modify the symbol's name."
    exit 1
fi

if grep --include \*.swift --exclude-dir=./Tuist --exclude-dir=./**/Tests -R -E \
    "^(open\s)(\w+\s)?(enum|struct|class|protocol|actor|typealias){1}\s${PRODUCT_NAME}(:\s|\s{|\s=}{1})" $SOURCE
then
    echo "There is an open symbol with the same name as the package $PRODUCT_NAME. This is a error, modify the symbol's name."
    exit 1
fi