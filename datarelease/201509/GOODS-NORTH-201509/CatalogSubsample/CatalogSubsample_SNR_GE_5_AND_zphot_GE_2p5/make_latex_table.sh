#!/bin/bash
#
CrabTable2latex "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.dat"   "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex"   -delux
sed -i -e 's/lgMstar/$\\log M_{*}$/g'                       "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex"
sed -i -e 's/lgSSFR/$\\log s$SFR/g'                         "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex"
sed -i -e 's/eSFR/$\\sigma$SFR/g'                         "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex"
sed -i -e 's/Mgas/$M_{ISM}$/g'                              "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex"
sed -i -e 's/zspec/$z_{spec}$/g'                            "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex"
sed -i -e 's/zphot/$z_{phot}$/g'                            "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex"
sed -i -e 's/TypeSBrst/${SB}$/g'                          "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex"
sed -i -e 's/TypeRLAGN/${RLAGN}$/g'                    "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex"
sed -i -e 's/snrIR/$S\/N$/g'                                 "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex"
sed -i -e 's/     -99/ \\nodata/g'                                 "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex"
sed -i -e 's/      ""/ \\nodata/g'                                 "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex"
sed -i -e 's/ "\(.*\)"/   \1/g'                                    "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex"


#sed -i -e 's/      9293 \&/  9293$^1$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex" # M23
#sed -i -e 's/       658 \&/   658$^2$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex" # GN20.2a
#sed -i -e 's/       564 \&/   564$^3$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex" # GN20, AzGN01
#sed -i -e 's/       659 \&/   659$^4$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex" # GN20.2b
#sed -i -e 's/    350056 \&/350056$^6$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex" # HDF850.1;GN14
#sed -i -e 's/     11303 \&/ 11303$^5$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex" # M18 (z=2.929)
#sed -i -e 's/      714 \&/  714$^3$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex" # BD29079
#sed -i -e 's/     9710 \&/ 9710$^5$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex" # GN10, AzGN03
#sed -i -e 's/    12788 \&/12788$^5$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex" # SMMJ123712.05+621212.3
#sed -i -e 's/    15346 \&/15346$^5$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex" # SMMJ123606+621047


#cat "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex" | sed -e 's/ & [ ]\{8\}/ & /g'

mv "goodsn-cat-table-high-z-full.tex" "goodsn-cat-table-high-z-full.tex.backup"

cp "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex" "goodsn-cat-table-high-z-full.tex"

head -n 20 "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex" > "goodsn-cat-table-high-z.tex"
cat "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex" | grep \
                                                     -e " 564 " \
                                                     -e " 658 " \
                                                     -e " 659 " \
                                                     -e " 12000 " \
                                                     -e " 11580 " \
                                                     -e " 18911 " \
                                                     -e " 16681 " \
                                                     -e " 6489 " \
                                                     -e " 17120 " \
                                                     -e " 11499 " \
                                                     -e " 13097 " \
                                                     -e " 1094 " \
                                                     -e " 1160054 " \
                                                     -e " 250003 " \
                                                     -e " 12646 " \
                                                     -e " 13616 " \
                                                     -e " 1160053 " \
                                                     -e " 350056 " \
                                                     >> "goodsn-cat-table-high-z.tex"
tail -n 3 "CatalogSubsample_SNR_GE_5_AND_zphot_GE_2p5.tex" >> "goodsn-cat-table-high-z.tex"


