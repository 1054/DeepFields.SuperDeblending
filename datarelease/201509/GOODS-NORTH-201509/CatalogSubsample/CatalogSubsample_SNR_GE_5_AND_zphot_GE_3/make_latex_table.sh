#!/bin/bash
#
CrabTable2latex CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.dat             "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex"
sed -i -e 's/-9.900e+01/       .../g'                                    "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex"
sed -i -e 's/-9.9e+01/     .../g'                                        "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex"
sed -i -e 's/-99.000/    .../g'                                          "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex"
sed -i -e 's/-1.000/   .../g'                                            "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex"
sed -i -e 's/-99.00/   .../g'                                            "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex"
sed -i -e 's/-99.0/  .../g'                                              "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex"
sed -i -e 's/-99/.../g'                                                  "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex"
sed -i -e 's/ [ ]\{11\}\([0-9.]*\)e\+\([0-9]*\)/ $\1\\times10^{\2}$/g'   "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex"
sed -i -e 's/   Mstar / $M_{*}$ /g'                                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex"
sed -i -e 's/      Mgas / $M_{ISM}$ /g'                                  "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex"
sed -i -e 's/      zspec / $z_{spec}$ /g'                                "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex"
sed -i -e 's/      zphot / $z_{phot}$ /g'                                "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex"
sed -i -e 's/      flagSB / flag$_{SB}$ /g'                              "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex"
sed -i -e 's/      flagAGN / flag$_{AGN}$ /g'                            "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex"
sed -i -e 's/          snrIR / $S\/N_{FIR\/mm}$ /g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex"


sed -i -e 's/      9293 \&/  9293$^1$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex" # M23
sed -i -e 's/       658 \&/   658$^2$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex" # GN20.2a
sed -i -e 's/       564 \&/   564$^3$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex" # GN20, AzGN01
sed -i -e 's/       659 \&/   659$^4$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex" # GN20.2b
sed -i -e 's/    350056 \&/350056$^6$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex" # HDF850.1;GN14
#sed -i -e 's/     11303 \&/ 11303$^5$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex" # M18 (z=2.929)
#sed -i -e 's/      714 \&/  714$^3$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex" # BD29079
#sed -i -e 's/     9710 \&/ 9710$^5$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex" # GN10, AzGN03
#sed -i -e 's/    12788 \&/12788$^5$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex" # SMMJ123712.05+621212.3
#sed -i -e 's/    15346 \&/15346$^5$ \&/g'                      "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex" # SMMJ123606+621047


#cat "CatalogSubsample_SNR_GE_5_AND_zphot_GE_3.tex" | sed -e 's/ & [ ]\{8\}/ & /g'
