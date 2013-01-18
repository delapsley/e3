#!/bin/bash

curl -X PUT\
    -H "Content-Type: text/plain"\
    -T 'test.txt'\
    http://localhost:8000/file/1
