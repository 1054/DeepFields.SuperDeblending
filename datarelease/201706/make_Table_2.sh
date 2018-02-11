#!/bin/bash
# 

if [[ ! -f "Catalog/GOODSN_FIR+mm_Catalog_20170828_all_columns_v6.with_SFR_total.fits" ]] || [[ 1 == 1 ]]; then
topcat -stilts tmatchn \
               nin=2 \
               in1="Catalog/GOODSN_FIR+mm_Catalog_20170828_all_columns_v6.fits" \
               ifmt1=fits \
               values1="index" \
               in2="Catalog/RadioOwenMIPS24_priors_dzliu_20170905_SFR_total.txt" \
               ifmt2=ascii \
               values2="index" \
               matcher=exact \
               ofmt=fits \
               ocmd="addcol \"id\" \"id_1\"" \
               ocmd="addcol \"SFR_IR\" -before SFR \"SFR\"" \
               ocmd="addcol \"eSFR_IR\" -before eSFR \"eSFR\"" \
               ocmd="delcols \"id_1 id_2 SFR eSFR\"" \
               out="Catalog/GOODSN_FIR+mm_Catalog_20170828_all_columns_v6.with_SFR_total.fits"
               # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/tmatchn-usage.html
fi


topcat -stilts tpipe \
                in="Catalog/GOODSN_FIR+mm_Catalog_20170828_all_columns_v6.with_SFR_total.fits" \
                ifmt=fits \
                cmd="select \"(SNR_IR>=10 && z_IR>=3.0)\"" \
                cmd="sort -down \"SNR_IR\"" \
                cmd="addcol id_input -before 1 \"id\"" \
                cmd="delcols \"id\"" \
                cmd="addcol \"ID\"                                        -before id_input \"id_input\"" \
                cmd="addcol \"R.A.\"                                      -before id_input \"formatDecimal(ra,\\\"#.0000000\\\")\"" \
                cmd="addcol \"Dec.\"                                      -before id_input \"formatDecimal(dec,\\\"#.0000000\\\")\"" \
                cmd="addcol \"\$z_{\mathrm{IR}}\$\"                       -before id_input \"formatDecimal(z_IR,\\\"#.00\\\")\"" \
                cmd="addcol \"\$z_{\mathrm{spec}}\$\"                     -before id_input \"formatDecimal(z_spec,\\\"#.000\\\")\"" \
                cmd="addcol \"\$S_{500}\$\"                               -before id_input \"formatDecimal(FLUX_500,\\\"#.0\\\")\"" \
                cmd="addcol \"\$\sigma_{500}\$\"                          -before id_input \"formatDecimal(FLUXERR_500,\\\"#.0\\\")\"" \
                cmd="addcol \"S/N\"                                       -before id_input \"formatDecimal(SNR_IR,\\\"#.0\\\")\"" \
                cmd="addcol \"\$\log M_{*}\$\"                            -before id_input \"formatDecimal(log10(Mstar),\\\"#.00\\\")\"" \
                cmd="addcol \"\$\mathrm{SFR}_{\mathrm{total}}\$\"         -before id_input \"formatDecimal(SFR_total,\\\"#.0\\\")\"" \
                cmd="addcol \"\$\mathrm{SFR}_{\mathrm{IR}}\$\"            -before id_input \"formatDecimal(SFR_IR,\\\"#.0\\\")\"" \
                cmd="addcol \"\$\sigma_{\mathrm{SFR}_{\mathrm{IR}}}\$\"   -before id_input \"formatDecimal(eSFR_IR,\\\"#.0\\\")\"" \
                cmd="addcol \"\textit{goodArea}\"                         -before id_input \"goodArea\"" \
                cmd="addcol \"T\$_{20\mathrm{cm}}\$\"                     -before id_input \"Type_AGN\"" \
                cmd="addcol \"T\$_{\mathrm{SED}}\$\"                      -before id_input \"Type_SED\"" \
                cmd="keepcols \"1 2 3 4 5 6 7 8 9 10 11 12 13 14 15\"" \
                ofmt=latex \
                out="Table_2_latex.tex"
                # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/tpipe.html



