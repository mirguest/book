#!/bin/bash
# Author: Tao Lin
# create a new entry.

## Global INFO
export STOREDIR=$(pwd)/store

if [ ! -d "$STOREDIR" ]; then
    echo "Failed to locate store dir: $STOREDIR"
    exit -1
fi

## create from template
function create-template() {
    local fn=${FN}
    cat <<EOF > $fn
{
    "isbn": "${ISBN}",
    "title": "${TITLE}",
    "links": [
        "${LINK}"
    ],
    "room": "${ROOM}",
    "position": "${POSITION}",
    "tags": ["${TAG}"]
}
EOF
}

## create an record from ISBN
isbn() {
    local isbn=$1
    if [ -z "$isbn" ]; then
        echo "Missing ISBN"
        return
    fi

    local fn=$STOREDIR/${isbn}.json
    if [ -f "$fn" ]; then
        echo "Record $fn already exists"
        return
    fi

    FN=$fn ISBN=$isbn create-template
}


$*
