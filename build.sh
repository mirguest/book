#!/bin/bash

function print-header() {
    echo "["
}

function print-element() {
    local f=$1
    cat $f
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

main > store.json