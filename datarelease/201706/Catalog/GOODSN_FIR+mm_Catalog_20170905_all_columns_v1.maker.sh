#!/bin/bash
# 


topcat -stilts tmatchn \
               nin=6 \
               in1='RadioOwenMIPS24_priors_dzliu_20170905_CPFmJy.txt' \
               ifmt1=ascii \
               values1="index" \
               in2='ResLMT_RadioOwenMIPS24_priors_dzliu_20170905.txt' \
               ifmt2=ascii \
               values2="index" \
               in3='ResLMTfluxes_RadioOwenMIPS24_priors_dzliu_20170905.txt' \
               ifmt3=ascii \
               values3="index" \
               in4='ResLMTparams_RadioOwenMIPS24_priors_dzliu_20170905.txt' \
               ifmt4=ascii \
               values4="index" \
               in5='RadioOwenMIPS24_priors_dzliu_20170905_chisq_and_n_chisq.txt' \
               ifmt5=ascii \
               values5="index" \
               in6='RadioOwenMIPS24_priors_dzliu_20170905_SFR_total.txt' \
               ifmt6=ascii \
               values6="index" \
               matcher=exact \
               ofmt=fits \
               out='GOODSN_FIR+mm_Catalog_20170905_all_columns_v1.fits'
               # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/tmatchn-usage.html

topcat 'GOODSN_FIR+mm_Catalog_20170905_all_columns_v1.fits' \
        '../Catalog_Photo_z/GOODS_N_IRAC_priors_all_19437.fits' \
        &

