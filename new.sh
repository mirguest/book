#!/bin/bash
# Author: Tao Lin
# create a new entry.

## Global INFO
export STOREDIR=$(pwd)/store
export DOUBANDIR=$(pwd)/douban

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

## create an record from CSV
# 
#    编号,书名,作者,ISBN,价格,京东链接,位置/地点,相对位置,Label:
#    1    2    3    4    5    6        7         8        9
##
csv() {
    local line="$*"
    local _isbn="$(echo "$line" | cut -d, -f4)"
    local _title="$(echo "$line" | cut -d, -f2)"
    local _link="$(echo "$line" | cut -d, -f6)"
    local _room="$(echo "$line" | cut -d, -f7)"
    local _pos="$(echo "$line" | cut -d, -f8)"
    local _tag="$(echo "$line" | cut -d, -f9)"

    TITLE="${_title}" LINK="${_link}" ROOM="${_room}" POSITION="${_pos}" TAG="${_tag}" isbn "${_isbn}"
}

## douban API
function create-template-douban() {
    curl 'https://douban.uieee.com/v2/book/isbn/'$ISBN > $FN
}


## create an record (douban API) from isbn
douban() {
    local isbn=$1
    if [ -z "$isbn" ]; then
        echo "Missing ISBN"
        return
    fi

    local fn=$DOUBANDIR/${isbn}.json
    if [ -f "$fn" ]; then
        echo "Record $fn already exists"
        return
    fi

    FN=$fn ISBN=$isbn create-template-douban

}

import-to-douban() {
    local f
    local isbn
    for f in $(ls $STOREDIR); do
        isbn=${f%.json}
        douban $isbn
    done
}

$*
