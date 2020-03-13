#!/bin/bash

DOWNLOADURL=https://storage.googleapis.com/golang

if [[ !(`wget -S --spider $DOWNLOADURL/go1.14.src.tar.gz  2>&1 | grep 'HTTP/1.1 200 OK'`) ]]
then
	echo "not found"
else
	echo "found"
fi

testnum=1.14
testnum=$(bc <<< "$testnum+0.01")
testnum=$(bc <<< "$testnum+0.01")

echo $testnum
