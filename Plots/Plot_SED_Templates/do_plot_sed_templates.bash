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

if [[ ! -f "fit_engine.sm" ]]; then
    echo "Error! \"fit_engine.sm\" was not found under current directory!"
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

SFR=600

echo "macro read do_plot_sed_templates.sm Plot_SED_Templates $SFR" | sm > /dev/null 2>/dev/null

ls -1d "Output"
ls "Plot_SED_Templates_v1.eps"
ls "Plot_SED_Templates_v1.pdf"

echo "macro read do_plot_sed_templates_flux_versus_z_IRAC.sm Plot_SED_Templates_Flux_versus_z" | sm > /dev/null

ls -1d "Output"
ls "Output/Plot_SED_Templates_Flux_versus_z_IRAC_v1.pdf"
