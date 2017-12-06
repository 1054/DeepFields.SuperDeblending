#!/bin/bash
# 
# 
# 
# 


if [[ -z "$input_date" ]]; then
#input_date="20171016a_DR_v201612"
input_date="20171027a_DR_v201706"
input_date="20171030a_DR_v201706"
fi


if [[ -z "$output_date" ]]; then
#input_date="20171016a_DR_v201612"
output_date="20171027b_DR_v201706"
output_date="20171030a_DR_v201706"
fi


# check previous non-normalized run list_files
if [[ ! -d "results_Plots_v${input_date}/list_files/" ]]; then 
    echo "Error! \"results_Plots_v${input_date}/list_files/\" was not found! Please run \"a_dzliu_code_Plot_Mstar_Histogram.bash\" first!"; exit
fi
cp "results_Plots_v${input_date}/list_files/"list_* .


# prepare renormalization file
if [[ ! -f "datatable__CSFRD_correction__SMF_renormalization_v${output_date}.txt" ]]; then
    echo "macro read a_dzliu_code_calc_CSFRD_incompleteness_correction.sm calc_CSFRD_incompleteness_correction" | sm | tee "a_dzliu_log_calc_CSFRD_incompleteness_correction_v${output_date}.txt"
    cp "datatable__CSFRD_correction__v1.txt" "datatable__CSFRD_correction__v${output_date}.txt"
    cp "datatable__CSFRD_correction__v1.txt" "datatable__CSFRD_correction__SMF_renormalization_v${output_date}.txt"
fi
cp "datatable__CSFRD_correction__SMF_renormalization_v${output_date}.txt" "datatable__CSFRD_correction__SMF_renormalization.txt"
rm list_*


# make Mstar Histograms
echo "macro read a_dzliu_code_Plot_Mstar_Histogram.sm plot_all" | sm | tee "a_dzliu_log_Plot_Mstar_Histogram_v${output_date}_Renormalized.txt"


# prepare output dir
results_dir="results_Plots_v${output_date}_Renormalized"


mkdir "$results_dir"
mv Plot_Mstar_Histogram_z_bin_*_broadened.pdf Plot_Mstar_SFR_Contribution_z_bin_*_broadened.pdf "$results_dir"/
rm Plot_Mstar_Histogram_z_bin_*_broadened.eps; mv datatable__CSFRD_correction__SMF_renormalization.txt "$results_dir"/

mkdir "$results_dir"/SMF_intrinsic
mv Plot_Mstar_Histogram_z_bin_*_intrinsic.pdf Plot_Mstar_SFR_Contribution_z_bin_*_intrinsic.pdf "$results_dir"/SMF_intrinsic/
rm Plot_Mstar_Histogram_z_bin_*_intrinsic.eps

mkdir "$results_dir"/list_files
mv list_* "$results_dir"/list_files/



list_pdf=($(ls -1 "$results_dir"/Plot_*.pdf | sed -e 's/.pdf$//g'))
for name_pdf in "${list_pdf[@]}"; do
echo mv "${name_pdf}.pdf" "${name_pdf}_Renorm.pdf"
mv "${name_pdf}.pdf" "${name_pdf}_Renorm.pdf"
done





