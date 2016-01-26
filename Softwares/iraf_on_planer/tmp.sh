#!/bin/bash

#$ -cwd
#$ -S /bin/bash
#$ -V

set -x
set -e

source /dsm/upgal/data/dliu/Superdeblending/Softwares/SETUP
cd /dsm/upgal/data/dliu/Superdeblending/Softwares/iraf_on_planer/
cl < tmp.cl



