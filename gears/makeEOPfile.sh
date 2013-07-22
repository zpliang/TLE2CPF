#!/usr/bin/bash
# usage:  [==] <nMJD-begin> <span>
# example:./MakeEOPfile.sh 55256 10 > eopfile.txt

mjdb=$1
span=$2
mjde=$(($mjdb+$span))

fnameext=${0##*/}
thisname=${fnameext%%.*}
sfx=${thisname}.tmp

f1=select_$sfx


psql PubData -At -F"," -c  " SELECT yy,mm,dd,nMJD,PMx,PMy,0.0,dUT1,dPSI,dEPS,0.0,0.0,0.0,0.0,0.0,0.0 
FROM EOP 
WHERE nMJD>${mjdb}-10 AND nMJD<${mjde}+10 
;" > ${f1}
dos2unix ${f1}_select.tmp &> /dev/null

cat ${f1} | awk -F, '{printf("%4d%4d%4d%7d%11.6lf%11.6lf%12.7lf%12.7lf%11.6lf%11.6lf%11.6lf%11.6lf%11.6lf%11.6lf%12.6lf%12.6lf\n",($1<1962)?$1+2000:$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16);}'

