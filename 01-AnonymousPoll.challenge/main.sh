#!/bin/bash

read SEARCH_STR

NUM=1;
while read SEARCH_STR; do
    STUDENTS=$(grep "$SEARCH_STR" 01-AnonymousPoll.challenge/students | cut -d ',' -f 1 | sort -u | paste -s -d ',' -)
    echo "Case #$NUM: ${STUDENTS:=NONE}"
    let NUM++
done
