#!/usr/bin/bash
# purpose: turn TEF format to cpf body (10 and 20) format.
# format sample:
#      55256.00000000     -4008904.98696200      6542177.04137590     -1712867.93558810        -2916.72865892        -3146.39436014        -5236.20958568
# approach:
# calculate nMJD, nSOD, and n7S=0000000
# implementation: awk script
# synopsis: ./tef_to_tef2.sh <TEF file>
# example: ./tef_to_tef2.sh hod_res_2011_1008_01.txt

teffile=$1

# awk implementation: use $1 to calculate desired integers
awk '{
intpart=int($1);
fracpart=$1-intpart;
MJD=intpart;
SOD=int(fracpart*86400+0.5);
printf("10 0 %5d %13.6lf 0 %17.3lf %17.3lf %17.3lf\n",MJD,SOD,$2,$3,$4)
printf("20 0  %19.6lf %19.6lf %19.6lf\n",$5,$6,$7)
}' ${teffile}
# done. awk is awesome!



# printf("%5d%6d%22.8lf%22.8lf%22.8lf%22.8lf%22.8lf%22.8lf\n",
               # MJD,SOD,$2,$3,$4,$5,$6,$7)
# :'               
# 10 1 53098  84449.02096     -125015785900.315 -238593151366.328  113777817699.433
# 10 2 53099      0.00000     -157578821821.085 -218511517400.466  113800334257.752
# 20 1         -4900.351123        27002.440493       -11504.716991
# 20 2         -1033.856498        27424.269894       -11503.554375
# 30 1     14960874.918060    -6906109.317657     1955191.986389   19356.3
# 30 2    -13838706.981995     8961558.044586    -1956244.853897   19361.8               
# '
