#!/bin/sh

function extract() {
    if [ ! -f ${BLUDIT_ZIP} ]
    then
	echo "${BLUDIT_ZIP} -- file not found!"
	exit 1
    fi

    TMP_DIR=/tmp/bludit
    echo "  - Extracting ${BLUDIT_ZIP} to ${TMP_DIR} ..."
    test -d ${TMP_DIR} || mkdir ${TMP_DIR}
    cd ${TMP_DIR}
    unzip -q -d ${TMP_DIR} ${BLUDIT_ZIP}
    chown -R nginx:nginx ${TMP_DIR}

    echo "  - Copying ${TMP_DIR}/* to ${TARGET_PATH} ..."
    ( cd ${TMP_DIR}/* && cp -a . ${TARGET_PATH}/ )
    rm -rf ${TMP_DIR}
}

if [ "$1" = "-u" -o "$1" = "--upgrade" ]
then
    UPGRADE=1
    test -n "$2" && SOURCE_ARCHIVE="$2"
fi

# Check for existance of TARGET_PATH
if [ ! -d "${TARGET_PATH}" ]; then
    echo "${TARGET_PATH} -- directory not found!"
    exit 1
fi

if [ -z "$(ls ${TARGET_PATH})" ]
then
    UPGRADE=1
    
    echo "[+] Installing bludit ..."

    BLUDIT_ZIP=/bludit.zip
    extract
fi

if [ -n "${UPGRADE}" -a -n "${SOURCE_ARCHIVE}" ]
then
    echo "  - Upgrading from ${SOURCE_ARCHIVE} ..."
    BLUDIT_ZIP=/tmp/bludit.zip
    curl -L --output ${BLUDIT_ZIP} "${SOURCE_ARCHIVE}"
    extract
fi
