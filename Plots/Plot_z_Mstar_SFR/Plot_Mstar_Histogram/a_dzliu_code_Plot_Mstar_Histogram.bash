#!/bin/bash
# 
# 20170116 - fixed \ast\sigma
# 20170126 - now try Schreiber MS -- see calc_SMF_*.sm
# 

if [[ -z "$output_date" ]]; then
output_date="20171027a_DR_v201706"
output_date="20171030a_DR_v201706"
fi


# make sure no renormalization file
if [[ -f "datatable__CSFRD_correction__SMF_renormalization.txt" ]]; then 
    mv "datatable__CSFRD_correction__SMF_renormalization.txt" "datatable__CSFRD_correction__SMF_renormalization.txt.backup"
fi


# make Mstar Histograms
echo "macro read a_dzliu_code_Plot_Mstar_Histogram.sm plot_all" | sm | tee "a_dzliu_log_Plot_Mstar_Histogram_v${output_date}.txt"


# prepare output dir
results_dir="results_Plots_v${output_date}"


mkdir "$results_dir"
mv Plot_Mstar_Histogram_z_bin_*_broadened.pdf Plot_Mstar_SFR_Contribution_z_bin_*_broadened.pdf "$results_dir"/
rm Plot_Mstar_Histogram_z_bin_*_broadened.eps

mkdir "$results_dir"/SMF_intrinsic
mv Plot_Mstar_Histogram_z_bin_*_intrinsic.pdf Plot_Mstar_SFR_Contribution_z_bin_*_intrinsic.pdf "$results_dir"/SMF_intrinsic/
rm Plot_Mstar_Histogram_z_bin_*_intrinsic.eps

mkdir "$results_dir"/list_files
mv list_* "$results_dir"/list_files/






# 
# -- see 'a_dzliu_code_Plot_Mstar_Histogram_Renormalized.bash'
# 
#if [[ $(ls -1 "$results_dir"/list_files/list_* | wc -l) -gt 0 ]]; then
#    echo "macro read a_dzliu_code_calc_CSFRD_incompleteness_correction.sm calc_CSFRD_incompleteness_correction" | sm | tee "a_dzliu_log_calc_CSFRD_incompleteness_correction_v${output_date}.txt"
#    cp "$results_dir"/list_files/datatable__CSFRD_correction__v1.txt "$results_dir"/
#    cp -i "$results_dir"/list_files/datatable__CSFRD_correction__v1.txt ./datatable__CSFRD_correction__v${output_date}.txt
#fi






