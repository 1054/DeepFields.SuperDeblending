#!/bin/bash
# 

if [[ $(echo "load astroPhot2.sm" | sm 2>&1 | wc -l) -eq 1 ]]; then
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

echo "macro read do_plot_sed_templates.sm Plot_SED_Templates" | sm

echo "macro read do_plot_sed_templates_flux_versus_z.sm Plot_SED_Templates_Flux_versus_z" | sm

