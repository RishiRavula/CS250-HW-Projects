#!/bin/bash

rm ./*.class
javac ./*.java
java cachesim $1 $2 $3 $4 $5
