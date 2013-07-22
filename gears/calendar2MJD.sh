# purpose: convert calendar date to MJD.
# synopsis: ./[==] <yyyymmdd>
# use case: ./calendar2MJD.sh 20100301					(output:55256)

calendar=$1

# set paths
fullname=`readlink -f $0`
mypath=${fullname%/*}

c2m=${mypath}/calendar2MJD.pl_

echo $calendar | ${c2m}

