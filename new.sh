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
function create-template-json-in-store() {
    local fn=${FN}
    cat <<EOF | sed -e 's/\r//g' > $fn
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
    if [ -f "$fn" ]; then
        echo "Record $fn is created"
    fi
}

## create an record from ISBN
function create-template-using-isbn() {
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

    FN=$fn ISBN=$isbn create-template-json-in-store
}

## create an record from CSV
# 
#    编号,书名,作者,ISBN,价格,京东链接,位置/地点,相对位置,Label:
#    1    2    3    4    5    6        7         8        9
##
function create-template-using-csv() {
    local line="$*"
    local _isbn="$(echo "$line" | cut -d, -f4)"
    local _title="$(echo "$line" | cut -d, -f2)"
    local _link="$(echo "$line" | cut -d, -f6)"
    local _room="$(echo "$line" | cut -d, -f7)"
    local _pos="$(echo "$line" | cut -d, -f8)"
    local _tag="$(echo "$line" | cut -d, -f9)"

    if [ -z "${_isbn}" ]; then
        echo "Missing ISBN. The current line is: $line"
        return
    fi
    if [ "${_isbn}" = "ISBN" ]; then
        return
    fi
    
    TITLE="${_title}" LINK="${_link}" ROOM="${_room}" POSITION="${_pos}" TAG="${_tag}" create-template-using-isbn "${_isbn}"
}

## remove windows EOL
function remove-windows-eol() {

    local f
    for f in $(ls $STOREDIR); do
        sed -i 's/\r//g' $STOREDIR/$f
    done

}

## add a new entry all toghter
#    input: CSV
#    编号,书名,作者,ISBN,价格,京东链接,位置/地点,相对位置,Label:
#    1    2    3    4    5    6        7         8        9
function all-in-oneline() {
    local line="$*"
    local _isbn="$(echo "$line" | cut -d, -f4)"
    
    # create an entry in store/
    create-template-using-csv "$line"
    # create an entry in douban/
    # create-template-using-douban "${_isbn}"
}

import-from-cvs() {
    local filename=${1}; shift
    if [ -z "$filename" ]; then
        filename=mybooks.utf8.csv
    fi

    local line
    while read line; do
        # trim the windows CRLF
        line=$(echo "$line" | tr -d '\r')
        if [ -z "$line" ]; then
            continue
        fi
        # echo $line
        all-in-oneline "$line"
    done < $filename
}

if [ -z "$*" ]; then
    import-from-cvs
else
    $*
fi
