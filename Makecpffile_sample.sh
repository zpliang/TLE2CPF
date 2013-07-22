#!/usr/bin/bash

# purpose: query and make CPF file according to specified satellite and time span.
# synopsis: $ [==] <NORAD ID> <start date> <stop date> 
# example: $ ./MakeCPFfile.sh 16908 20110831 20110904 

norad=$1
date1=$2
date2=$3
cue=TLE

# set paths
fullname=`readlink -f $0`
mypath=${fullname%/*}

fnameext=${0##*/}
thisname=${fnameext%%.*}
sfx=${thisname}.tmp



tmp1=cpfheader_$sfx
tmp2=cpfbody_$sfx
resultfile="CPF_"${norad}"_"${cue}"_"${date1}"_"${date2}".txt"



# first convert formatted date to MJD
mjd1=$(${scrdir}/calendar2MJD.pl ${date1})
mjd2=$(${scrdir}/calendar2MJD.pl ${date2})

shdir=${mypath}/MakeCPF.d
# make header and body
# ${shdir}/makeheader.sh ${norad} ${date1} ${date2} > ${tmp1}
# ${shdir}/makebody.sh ${norad} ${mjd1} ${mjd2} ${cue} > ${tmp2}

# combine them.
cat ${tmp1} ${tmp2} > ${resultfile}


