# purpose: use specified TLE to make CPF predictions.
# usage:    [==] <TLE> <MJD> <span/d>
# example:  ./TLE2CPF1020.sh tle.txt 56100 5

tle=$1
mjdb=$2
span=$3
mjde=$(($mjdb+$span))


# set paths
fullname=`readlink -f $0`
mypath=${fullname%/*}

fnameext=${0##*/}
thisname=${fnameext%%.*}
sfx=${thisname}.tmp

tef=f1_$sfx
cpfbody=f2_$sfx
header=f3_$sfx

caldb=`${mypath}/gears/MJD2calendar.pl ${mjdb}`
calde=`${mypath}/gears/MJD2calendar.pl ${mjde}`
noradid=`cat ${tle} | grep ^1 | head -n1 | cut -c3-7`
resultfile="CPF_${noradid}_${caldb}_${span}_TLE_CHA.txt"
grid=`psql slrdata  -At -c "select grid from satellite where noradid=${noradid};"`
freq=`perl -e "print 86400/${grid}"`

${mypath}/gears/tle2tef.sh tle.txt ${mjdb} ${span} ${freq}> ${tef}
${mypath}/gears/tef_to_cpfbody1020.sh ${tef} | grep -v ^20 > ${cpfbody}
${mypath}/gears/makecpfheader.sh ${noradid} ${caldb} ${calde} > ${header}

cat /dev/null > ${resultfile} 
cat ${header} >> ${resultfile} 
cat ${cpfbody} >> ${resultfile} 
echo "99" >> ${resultfile} 


rm *.tmp
