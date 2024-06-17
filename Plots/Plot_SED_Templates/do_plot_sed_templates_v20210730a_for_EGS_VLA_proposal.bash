#!/bin/bash
# 

if [[ $(echo "load astroPhot.sm" | sm 2>&1 | wc -l) -eq 1 ]]; then
    if [[ ! -d "$HOME/Cloud/Github/DeepFields.SuperDeblending" ]]; then
        echo "The SuperDeblending code \"$HOME/Cloud/Github/DeepFields.SuperDeblending\" was not found? Please download from \"https://github.com/1054/DeepFields.SuperDeblending\" and source the \"Softwares/SETUP\" file by yourself!"
        exit 1
    else
        source $HOME/Cloud/Github/DeepFields.SuperDeblending/Softwares/SETUP
    fi
fi

if [[ ! -f "fit_engine_v20210130a_fixed_qIR_2p5.sm" ]]; then
    echo "Error! \"fit_engine_v20210130a_fixed_qIR_2p5.sm\" was not found under current directory!"
    exit 1
fi

if [[ ! -d "BC03/" ]]; then
    echo "Error! \"BC03/\" was not found under current directory!"
    exit 1
fi

if [[ ! -d "Magdis/" ]]; then
    echo "Error! \"Magdis/\" was not found under current directory!"
    exit 1
fi

#SFR=600

echo "macro read do_plot_sed_templates_v20210730a_S3GHz_1p8uJy.sm Plot_SED_Templates" | sm > /dev/null 2>/dev/null

cp "Plot_SED_Templates_v1.eps" "Output_v20210730a/"
cp "Plot_SED_Templates_v1.pdf" "Output_v20210730a/"
cp Plot_SED_Templates_v1.pdf Output_v20210730a/Plot_SED_Templates_v20210730a_S10cm_1sig_0p6uJy.pdf
ls -1d "Output_v20210730a"

echo "macro read do_plot_sed_templates_flux_versus_z_v20210730a_24um_3GHz.sm Plot_SED_Templates_Flux_versus_z" | sm > /dev/null

#ls -1d "Output_v20210730a"
#ls "Output_v20210130a/Plot_SED_Templates_Flux_versus_z_v1.pdf"









