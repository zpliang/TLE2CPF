# purpose: transform TLE file into TEF file
# usage: [==] <tle file> <begin mjd> <span> <freq> > <teffile>
# example: ${scrdir}/TransTLEtoTEF.sh tle.txt 56100 5 1440 > <teffile>

tle=$1
mjdb=$2
span=$3
mjde=$(($mjdb+$span))
freq=$4; if [ -z $4 ]; then freq=1440; fi

# set paths
fullname=`readlink -f $0`
mypath=${fullname%/*}

fnameext=${0##*/}
thisname=${fnameext%%.*}
sfx=${thisname}.tmp

# first calculate TLE to TEF format orbit file. 
# spacing 1 min.

eopfile=eop_$sfx
teftmp=tef_$sfx

TLE2TEF=${mypath}/Tle2Tef.exe

${mypath}/makeEOPfile.sh ${mjdb} ${span} > ${eopfile}

if [ -s ${tle} ]; then
${TLE2TEF}  ${tle} ${eopfile} ${mjdb} ${freq} ${mjde} \
 | grep -E "^  [0-9]{5}\." > ${teftmp} 
fi 

if [ -s ${teftmp} ]; then 
cat ${teftmp} 
fi 



#> ${teftmp}
# then convert TEF to TEF2 format.
# TEF_2_TEF2=${scrdir}/tef_to_tef2.sh
# ${TEF_2_TEF2} ${teftmp} > ${tef2tmp}
