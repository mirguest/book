#!/bin/bash

function print-header() {
    echo "{"
    echo '"data": ['
}

function print-element() {
    local f=$1

    local isbn=$(basename $f)

    local doubanurl="$(cat douban/$isbn | jq '.alt')"
    
    cat $f | jq '.links += ['${doubanurl}']'
}

function print-element-sep() {
    echo ","
}

function print-element-last() {
    cat <<EOF
{}
EOF
}

function print-tailer() {
    echo "]"
    echo "}"
}


function main() {
    print-header
    for f in store/*.json
    do
        print-element $f
        print-element-sep
    done
    print-element-last
    print-tailer
}

main | sed -e 's/\r//g' > store.json
