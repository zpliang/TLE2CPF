#!/usr/bin/bash
# purpose: generate CPF header. prediction span from argument.
# synopsis: $ ./makeheader.sh <norad id> <start date> <stop date>
# example:  $ ./makeheader.sh 16908 20110831 20110904

# first query needed information. use a temporary script to get tmp output file.

norad=$1
startdate=$2
stop_date=$3
qryfile=headerquery.tmp
scr=SatInfoExport_sql.tmp
# to generate export script.
cat /dev/null > $scr 
echo "SELECT short_name,COSPARID,SIC,NORADID,Grid,CoM FROM satellite" >> $scr
echo "WHERE ( NORADID="$norad ")">> $scr
echo "; " >> $scr
# so now where is the export script?
psql slrdata  -At -F" " -f $scr > ${qryfile}

# then use awk to re-arrange the values.
# date -u +' %Y %m %d %H' >> ${qryfile}
H1a=`date -u +'%Y %m %d %H'`
H1b=$(cut -d' ' -f1 ${qryfile})
echo "H1 CPF  1  CHA ${H1a}  0000 ${H1b}      homer"

H2a=`awk '{printf("%7d %4d %8d",$2,$3,$4)}' ${qryfile}`
H2c=$(echo ${startdate} | cut -c1-4,5-6,7-8 --output-delimiter=' ') # '2011 08 31'
H2d=$(echo ${stop_date} | cut -c1-4,5-6,7-8 --output-delimiter=' ') # '2011 09 04'
H2e=$(awk '{printf("%5d",$5)}' ${qryfile}) # '  240'
echo "H2  ${H2a} ${H2c}  0  0  0 ${H2d}  0  0  0 ${H2e} 1 1  0 0 0"

H5a=$(awk '{printf("%7.4lf",$6*0.001)}' ${qryfile}) # ' 1.0100
echo "H5 ${H5a}"

echo "H9"
### $(<command>) is the string made by command.
### cut options: -d' ' delimiter=' '; -f1 field No.1(delimited); --output-delimiter=' ' ;
### echo ${somestring} would squeeze spaces. use echo "${somestring}" to avoid.

