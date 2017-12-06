#!/bin/bash
# 

if [[ ! -f "$HOME/Temp/20171023_GOODSN_UV_IR/goodsn_3dhst_selected_rest_frame_1400_1700.txt" ]]; then
topcat -stilts tmatchn \
                nin=2 \
                in1="$HOME/Temp/20171023_GOODSN_UV_IR/goodsn_3dhst.v4.1.cats/Catalog/goodsn_3dhst.v4.1.cat.FITS" \
                ifmt1=fits \
                values1="id" \
                suffix1="_3DHST" \
                in2="$HOME/Temp/20171023_GOODSN_UV_IR/goodsn_3dhst.v4.1.cats/RF_colors/goodsn_3dhst.v4.1.master.RF.FITS" \
                ifmt2=fits \
                values2="id" \
                suffix2="" \
                fixcols=all \
                matcher=exact \
                ocmd="addcol m1400 \"25.0-2.5*log10(L270)\"" \
                ocmd="addcol m1700 \"25.0-2.5*log10(L271)\"" \
                ocmd="addcol S1400 \"pow(10,m1400/(-2.5))*3630.780548\"" \
                ocmd="addcol S1700 \"pow(10,m1700/(-2.5))*3630.780548\"" \
                ocmd="keepcols \"id_3DHST ra_3DHST dec_3DHST m1400 m1700 S1400 S1700\"" \
                ofmt=ascii \
                out="$HOME/Temp/20171023_GOODSN_UV_IR/goodsn_3dhst_selected_rest_frame_1400_1700.txt"
                # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/tpipe.html
fi

if [[ ! -f "datatable_CrossMatched.txt" ]]; then
topcat -stilts tmatchn \
                nin=2 \
                in1="$HOME/Cloud/Github/DeepFields.SuperDeblending/datarelease/201706/Catalog/GOODSN_FIR+mm_Catalog_20170828_all_columns_v6.fits" \
                ifmt1=fits \
                values1="ra dec" \
                in2="$HOME/Temp/20171023_GOODSN_UV_IR/goodsn_3dhst_selected_rest_frame_1400_1700.txt" \
                ifmt2=ascii \
                values2="ra_3DHST dec_3DHST" \
                matcher=sky \
                params=1.0 \
                join1=always \
                ofmt=ascii \
                out="datatable_CrossMatched.txt"
                # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/tpipe.html
fi

if [[ ! -f "datatable_CrossMatched_selected_columns.txt" ]]; then
topcat -stilts tpipe \
                in="datatable_CrossMatched.txt" \
                ifmt=ascii \
                cmd="keepcols \"id ra dec id_3DHST ra_3DHST dec_3DHST z_IR ez_IR Mstar xfAGN xeAGN SFR eSFR sSFR SNR_IR goodArea m1400 m1700 S1400 S1700\"" \
                ofmt=ascii \
                out="datatable_CrossMatched_selected_columns.txt"
                # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/tpipe.html
sed -i -e 's/"" /-99/g' "datatable_CrossMatched_selected_columns.txt"
fi


