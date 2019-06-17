#!/usr/bin/env bash
# 


source $(dirname "${BASH_SOURCE[0]}")/Softwares/bin_setup.bash -check do_Galfit do_Galsim astrodepth_prior_extraction_photometry

source $(dirname "${BASH_SOURCE[0]}")/Pipelines/bin_setup.bash -check deepfields-superdeblending-prior-extraction-photometry

export SUPERDEBLENDDIR=$(dirname "${BASH_SOURCE[0]}")/Softwares


