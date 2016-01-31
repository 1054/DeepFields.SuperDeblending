#!/bin/bash -e
echo $(date +%Y-%m-%d:%H:%M:%S)
cd /home/dzliu/Data/DeepFields/daddi_goodsn_2015/S02_Superdeblending_FIR/Galsed_Template_EnlargedURange_Test
echo $PATH
echo CATALOGFILE=RadioOwenMIPS24_priors_v6_20160106_Tuned.txt
echo EXCLUDEFILE=
echo macro read AGN_N.sm AGN_Parallel RadioOwenMIPS24_priors_v6_20160106_Tuned.txt 659 | sm | tee fit_parallel_HDFN/log_659.txt
