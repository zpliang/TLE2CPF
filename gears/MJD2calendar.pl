#!/usr/bin/perl
# purpose: calculate calendar date from Modified Julian Day
# usage:   ./MJD2calendar.pl <MJD>
# example: ./MJD2calendar.pl 55256
$str_mjd="$ARGV[0]";
$jd	= $str_mjd + 2400000.5;

$temp= $jd - 2415019.5;
$tu	= $temp / 365.25;
$year= 1900 + int($tu);
$leapyrs	= int(($year-1901)*0.25);

$days = $temp - (($year - 1900) * 365.0 + $leapyrs) + 0.00000000001;

     if ($days < 1.0){
         $year    = $year - 1;
         $leapyrs = int(($year - 1901) * 0.25);
         $days    = $temp - (($year - 1900) * 365.0 + $leapyrs);
     }
@lmonth=(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
$dayofyr=int($days);
if(($year%4)==0) {$lmonth[1]=29;}

	$i=1; $inttemp=0;
	while(($dayofyr > $inttemp + @lmonth[$i-1]) && ($i < 12)){
       $inttemp = $inttemp + @lmonth[$i-1];
       $i++;
	}
$mon = $i;
$day = $dayofyr - $inttemp;

printf("%4d%02d%02d\n",$year,$mon,$day);