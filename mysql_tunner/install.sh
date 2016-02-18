#!/bin/bash

WGET=$(which wget)

$WGET http://mysqltuner.pl/ -O mysqltuner
$WGET https://raw.githubusercontent.com/major/MySQLTuner-perl/master/basic_passwords.txt -O basic_passwords.txt
$WGET https://raw.githubusercontent.com/major/MySQLTuner-perl/master/vulnerabilities.csv -O vulnerabilities.csv

cp mysqltunner $ROOT_DIR/bin



