#!/bin/bash
# 

# 
# 20171030: now updated SFR_UV and SFR_total in '/Users/dzliu/Cloud/Github/DeepFields.SuperDeblending/datarelease/201706/Catalog/'
#           re-plot all figures!
# 


cd Plot_z_Mstar_SFR/Plot_Mstar_Histogram/

export output_date="20171030a_DR_v201706"
./a_dzliu_code_Plot_Mstar_Histogram.bash

export input_date="20171030a_DR_v201706"
export output_date="20171030b_DR_v201706"
./a_dzliu_code_Plot_Mstar_Histogram_Renormalized.bash

cd ../../



cd Plot_z_Mstar_SFR/Plot_Mstar_SFR/

./a_dzliu_code_Plot_Mstar_SFR.bash

cd ../../



cd Calc_Vmax_and_CSFRD/

export data_version="201706"
export output_date="20171030b_DR_v{data_version}"
./a_dzliu_code_calc_Vmax_with_DataRelease_201706.bash

cd ../



cd Plot_CSFRD/

export input_date="20171030b_DR_v201706"
echo "$input_date" > "set_input_date"
export output_date="20171030b_DR_v201706"
echo "$output_date" > "set_output_date"

if [[ ! -d "datatable_CSFRD_dzliu_v${input_date}" ]]; then
    cp -r "../Calc_Vmax_and_CSFRD/datatable_CSFRD_dzliu_v${input_date}" .
fi
if [[ -f datatable__CSFRD_correction__Go.txt ]]; then 
    mv datatable__CSFRD_correction__Go.txt datatable__CSFRD_correction__Go.txt.backup
fi
if [[ -f datatable__CSFRD_correction__Go.readme.txt ]]; then 
    mv datatable__CSFRD_correction__Go.readme.txt datatable__CSFRD_correction__Go.readme.txt.backup
fi
echo "0" > "set_do_corr"
echo "macro read a_dzliu_code_Plot_CSFRD.sm plot_CSFRD" | sm | tee "log_plot_CSFRD.txt"

echo "../Plot_z_Mstar_SFR/Plot_Mstar_Histogram/results_Plots_v${input_date}_Renormalized/datatable__CSFRD_correction__SMF_renormalization.txt" \
                                                                                        "datatable__CSFRD_correction__Go.readme.txt"
cp   "../Plot_z_Mstar_SFR/Plot_Mstar_Histogram/results_Plots_v${input_date}_Renormalized/datatable__CSFRD_correction__SMF_renormalization.txt" \
                                                                                        "datatable__CSFRD_correction__Go.txt"

echo "1" > "set_do_corr"
echo "macro read a_dzliu_code_Plot_CSFRD.sm plot_CSFRD" | sm | tee "log_plot_CSFRD_do_corr.txt"

echo "macro read a_dzliu_code_Plot_CSFRD_correction_Go.sm plot_CSFRD_correction_Go" | sm

echo "macro read a_dzliu_code_fit_CSFRD.sm fit_CSFRD_Gladders2013" | sm
echo "macro read a_dzliu_code_fit_CSFRD.sm fit_CSFRD_MadauDickinson2014" | sm
echo "macro read a_dzliu_code_fit_CSFRD.sm analyze_chi2_Gladders2013" | sm
echo "macro read a_dzliu_code_fit_CSFRD.sm analyze_chi2_MadauDickinson2014" | sm

# edit a_dzliu_code_Plot_CSFRD.sm, modify "if($setDoCorr)" "calc_MadauDickinson2014_CSFRD" "calc_Gladders2013_CSFRD" parameters!!!
# then run again: 
# echo "1" > "set_do_corr"
# echo "macro read a_dzliu_code_Plot_CSFRD.sm plot_CSFRD" | sm | tee "log_plot_CSFRD_do_corr.txt"

cp "Plot_CSFRD_v1_CompletenessCorrected.pdf"    "Plot_CSFRD_v${output_date}_CompletenessCorrected.pdf"
cp "Plot_CSFRD_v1_VmaxCorrected.pdf"            "Plot_CSFRD_v${output_date}_VmaxCorrected.pdf"
cp "Plot_CSFRD_correction_Go_v1.pdf"            "Plot_CSFRD_correction_Go_v${output_date}.pdf"

cd ../






export result_date="20171030b_DR_v201706"
mkdir "a_dzliu_result_v${result_date}"

export input_date="20171030a_DR_v201706"
cp "Plot_z_Mstar_SFR/Plot_Mstar_Histogram/results_Plots_v${input_date}/"*".pdf"                                     "a_dzliu_result_v${result_date}"/

export input_date="20171030b_DR_v201706"
cp "Plot_z_Mstar_SFR/Plot_Mstar_Histogram/results_Plots_v${input_date}/Plot_Mstar_SFR_Contribution_"*"_Renorm.pdf"  "a_dzliu_result_v${result_date}"/
cp "Plot_z_Mstar_SFR/Plot_Mstar_SFR/Plot_Mstar_SFR_z_bin_"*".pdf"                                                   "a_dzliu_result_v${result_date}"/
# Fig. 26, 27, C53

cp "Plot_CSFRD/Plot_CSFRD_v${input_date}_CompletenessCorrected.pdf"                                                 "a_dzliu_result_v${result_date}"/
cp "Plot_CSFRD/Plot_CSFRD_v${input_date}_VmaxCorrected.pdf"                                                         "a_dzliu_result_v${result_date}"/
cp "Plot_CSFRD/Plot_CSFRD_correction_Go_v${input_date}.pdf"                                                         "a_dzliu_result_v${result_date}"/
# Fig. 28, 29, 30







