#!/bin/bash
# 

source $HOME/Cloud/Github/DeepFields.SuperDeblending/Softwares/SETUP

if [[ -z "$data_version" ]]; then
data_version="201706"
fi

if [[ -z "$SNR_limit" ]]; then
SNR_limit="5"
fi

if [[ -z "$output_date" ]]; then
output_date="20171030a_DR_v${data_version}"
fi


# 
# Firstly we copy SED files
# 
if [[ ! -d fit_matrix_HDFN ]]; then
	
	echo "Error! Directory \"fit_matrix_HDFN\" was not found!"
	exit 1
	
	tar -xzf "fit_matrix_HDFN.tar.gz"
	
	# 20171030 temporary
	#cp  '/Users/dzliu/Work/DeepFields/Works/GOODSN_Photometry/Galsed_Final_v20171027_before_fitting/fit_matrix_HDFN/fit_sed_885.txt' \
	#	'/Users/dzliu/Work/DeepFields/Works/GOODSN_Photometry/Galsed_Final_v20171027_before_fitting/fit_matrix_HDFN/fit_sed_8427.txt' \
	#	'/Users/dzliu/Work/DeepFields/Works/GOODSN_Photometry/Galsed_Final_v20171027_before_fitting/fit_matrix_HDFN/fit_sed_data_detected_885.txt' \
	#	'/Users/dzliu/Work/DeepFields/Works/GOODSN_Photometry/Galsed_Final_v20171027_before_fitting/fit_matrix_HDFN/fit_sed_data_detected_8427.txt' \
	#	'/Users/dzliu/Work/DeepFields/Works/GOODSN_Photometry/Galsed_Final_v20171027_before_fitting/fit_matrix_HDFN/fit_sed_data_undetect_885.txt' \
	#	'/Users/dzliu/Work/DeepFields/Works/GOODSN_Photometry/Galsed_Final_v20171027_before_fitting/fit_matrix_HDFN/fit_sed_data_undetect_8427.txt' \
 	#	fit_matrix_HDFN/
	
fi


# 
# Then we compute z_Vmax
# 
if [[ 1 == 1 ]]; then
	
	echo "$data_version" > "set_data_version"
	echo "$output_date" > "set_output_date"
	echo "$SNR_limit" > "set_SNR_limit"
	echo "macro read calc_Vmax.sm calc_Vmax" | sm | tee "log_of_calc_Vmax.txt"
	#rm fit_matrix_HDFN
	
fi

if [[ ! -f "RadioOwenMIPS24_priors_dzliu_${data_version}_zMax_for_SNR_${SNR_limit}.txt" ]]; then
	echo "Error! Failed to run calc_Vmax! Failed to output file \"RadioOwenMIPS24_priors_dzliu_${data_version}_zMax_for_SNR_${SNR_limit}.txt\"!"
	exit 1
fi


# 
# Then we compute CSFRD_Vmax
# This is time consuming!
# 
if [[ 1 == 1 ]]; then
	
	echo "macro read calc_CSFRD_bootstrap_without_withdrawal.sm calc_CSFRD_bootstrap" | sm | tee "log_of_calc_CSFRD_bootstrap.txt"
	
fi


# 
# Then we plot histograms
# 
if [[ 1 == 1 ]]; then
	
	echo "macro read calc_Vmax.sm plot_Vmax_histogram" | sm
	
fi




