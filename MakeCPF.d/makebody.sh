#!/usr/bin/bash
# purpose: make CPF body. prediction span from argument.
# synopsis: $ ./makebody.sh <norad id> <start MJD> <stop MJD> > <body file> <orbit cue>
# example:  $ ./makebody.sh 16908 55256 55257 REF > cpfbody.tmp

# 

norad=$1
startmjd=$2
stop_mjd=$3
cue=$4
qryfile=bodyquery.tmp
scr=PosInfoExport.sql

# query needed info.
grid=$(psql slrdata -At -c "SELECT Grid FROM satellite WHERE ( NORADID=${norad} );" | grep '[0-9]') # '240'

# generate export script.
cat /dev/null > $scr 
echo "SELECT nMJD,nSOD,X,Y,Z FROM ${cue}orbit" >> $scr
echo "WHERE ( NORADID=${norad} " >> $scr
echo " AND nSOD%${grid}=0 " >> $scr
echo " AND ( (nMJD=${startmjd}-1 AND nSOD>=86400-${grid}*5) " >> $scr
echo "        OR (nMJD>=${startmjd} AND nMJD<=${stop_mjd}) " >> $scr
echo "        OR (nMJD=${stop_mjd}+1 AND nSOD<=${grid}*5) " >> $scr
echo "     )"  >> $scr
echo " )"  >> $scr
echo "ORDER BY (nMJD+nSOD/86400.0) ASC" >> $scr
echo "; " >> $scr
# so now there is the export script!
rm ${qryfile}
psql slrdata -At -F" " -f $scr > ${qryfile}

# awk to re-format the text.
awk '{printf("10 0 %5d%7d.00000  0%17.3lf%17.3lf%17.3lf\n",$1,$2,$3,$4,$5)}' ${qryfile}
echo "99"
