#!/bin/bash
# 

set -e


version=9

if [[ ! -f "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.fits" ]] || [[ 1 == 1 ]]; then
    topcat -stilts tmatchn \
                            nin=9 \
                            in1=RadioOwenMIPS24_priors_dzliu_20170905_CPFmJy.txt ifmt1=ascii \
                            in2=RadioOwenMIPS24_priors_dzliu_20170828_Origin_20cm.txt ifmt2=ascii \
                            in3=RadioOwenMIPS24_priors_dzliu_20170828_ref_z_phot.txt ifmt3=ascii \
                            in4=RadioOwenMIPS24_priors_dzliu_20170905_Spec_z_done_version_03_revision_02.simple.txt ifmt4=ascii \
                            in5=ResLMT_RadioOwenMIPS24_priors_dzliu_20170905.txt ifmt5=ascii \
                            in6=ResLMTfluxes_RadioOwenMIPS24_priors_dzliu_20170905.txt ifmt6=ascii \
                            in7=ResLMTparams_RadioOwenMIPS24_priors_dzliu_20170905.txt ifmt7=ascii \
                            in8=RadioOwenMIPS24_priors_dzliu_20170905_chisq_and_n_chisq.txt ifmt8=ascii \
                            in9=RadioOwenMIPS24_priors_dzliu_20170905_SFR_total.txt ifmt9=ascii \
                            values1='index' values2='index' values3='index' values4='index' \
                            values5='index' values6='index' values7='index' values8='index' values9='index' \
                            suffix1='' suffix4='_4' \
                            matcher=exact multimode=pairs iref=1 \
                            ocmd='replacecol -name ID -desc "GOODS-Spitzer IRAC catalog RA Dec." id id' \
                            ocmd='replacecol -name RA -units degree -desc "GOODS-Spitzer IRAC catalog RA Dec." ra "ra"' \
                            ocmd='replacecol -name Dec -units degree -desc "GOODS-Spitzer IRAC catalog RA Dec." de "de"' \
                            ocmd='replacecol -name z_FIRmm -desc "FIR+mm SED fitted (or spectroscopic) redshift." z "z"' \
                            ocmd='replacecol -name e_z_FIRmm -desc "Error in FIR+mm SED fitted redshift (or 0 if spectroscopic redshift)." ez "(ez>=0) ? ( (ez<(1+z_FIRmm)*0.05) ? (1+z_FIRmm)*0.05 : ez ) : 0"' \
                            ocmd='addcol -before z_FIRmm z_spec -desc "Spectroscopic redshift from literature works." "(zSpec_4<=0) ? -99 : zSpec_4"' \
                            ocmd='addcol -before z_FIRmm ref_z_spec -desc "Spectroscopic redshift from literature works." "zssn"' \
                            ocmd='replacecol -name z_phot -desc "Optical/near-infrared photometric redshift from literature works." z_phot "(z_phot<0) ? -99 : z_phot"' \
                            ocmd='replacecol -name SNR_FIRmm -desc "Spectroscopic redshift from literature works." SNR "SNR"' \
                            ocmd='replacecol -name SFR_FIRmm -desc "FIR+mm dust SFR." SFR "SFR"' \
                            ocmd='replacecol -name e_SFR_FIRmm -desc "Error in FIR+mm dust SFR." eSFR "eSFR"' \
                            ocmd='replacecol -name Mstar -units "solMass" -desc "Stellar mass from literature works." Mstar "Mstar"' \
                            ocmd='replacecol -name sSFR -desc "SFR_FIRmm / Mstar." sSFR "sSFR"' \
                            ocmd='replacecol -name U_FIRmm -desc "Intestellar radiation field strength defined by the Draine & Li (2007) dust model." ubest "ubest"' \
                            ocmd='replacecol -name SFR_dust_over_SFR_total "SFR_IR/SFR_total" "SFR_IR/SFR_total"' \
                            ocmd='delcols "SAVEDid_* z_sp z_op zspec* zbest id_* ra_* de_* xf_zz xe_zz *chi2_min xmeSFR xfSFR xeSFR xmeAGN"' \
                            ocmd='keepcols "ID RA Dec z_phot ref_z_phot z_spec ref_z_spec z_FIRmm e_z_FIRmm fK dfK fch1 dfch1 fch2 dfch2 fch3 dfch3 fch4 dfch4 f16 df16 f24 df24 f100 df100 f160 df160 f250 df250 f350 df350 f500 df500 f850 df850 f1160 df1160 f20cm df20cm Origin_20cm SNR_FIRmm Mstar SFR_FIRmm e_SFR_FIRmm sSFR goodArea Type_* x* chisq_tot nfit_tot chisq_star nfit_star chisq_dust nfit_dust U_FIRmm SFR_total SFR_dust_over_SFR_total"' \
                            out="GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.unfinished.fits" ofmt=fits
                            # 
                            # set e_z_FIRmm not too small
                            #     (ez>=0) ? ((ez<(1+z)*0.05) ? (1+z)*0.05 : ez) : 0)
                            # 
                            # set zSpec=-99 if zSpec==0 
                            # 
    topcat -stilts tpipe in="GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.unfinished.fits" \
                            cmd="replacecol    -name      ID                        -units  \"---\"               -desc   \"GOODS-Spitzer/IRAC identifier\"                                                                   ID                             ID                                                                   " \
                            cmd="replacecol    -name      RA                        -units  \"deg\"               -desc   \"GOODS-Spitzer/IRAC Right Ascension in decimal degrees (J2000)\"                                   RA                             RA                                                                   " \
                            cmd="replacecol    -name      DEC                       -units  \"deg\"               -desc   \"GOODS-Spitzer/IRAC Declination in decimal degrees (J2000)\"                                       Dec                            Dec                                                                  " \
                            cmd="replacecol    -name      z_phot                    -units  \"---\"               -desc   \"Literature optical/near-infrared photometric redshift\"                                           z_phot                         z_phot                                                               " \
                            cmd="replacecol    -name    r_z_phot                    -units  \"---\"               -desc   \"Reference for zphot (1)\"                                                                         ref_z_phot                     ref_z_phot                                                           " \
                            cmd="replacecol    -name      z_spec                    -units  \"---\"               -desc   \"Literature spectroscopic redshift \"                                                              z_spec                         z_spec                                                               " \
                            cmd="replacecol    -name    r_z_spec                    -units  \"---\"               -desc   \"Reference for zspec (2)\"                                                                         ref_z_spec                     ref_z_spec                                                           " \
                            cmd="replacecol    -name      z_FIRmm                   -units  \"---\"               -desc   \"Super-deblended IR-to-radio SED fitting redshift (3)\"                                            z_FIRmm                        z_FIRmm                                                              " \
                            cmd="replacecol    -name    e_z_FIRmm                   -units  \"---\"               -desc   \"Error in z_FIRmm (4)\"                                                                            e_z_FIRmm                      e_z_FIRmm                                                            " \
                            cmd="replacecol    -name      FLUX_K                    -units  \"mJy\"               -desc   \"Literature K-band flux density (5)\"                                                              fK                             fK                                                                   " \
                            cmd="replacecol    -name    e_FLUX_K                    -units  \"mJy\"               -desc   \"Error in FLUX_K\"                                                                                 dfK                            dfK                                                                  " \
                            cmd="replacecol    -name      FLUX_IRAC1                -units  \"mJy\"               -desc   \"Spitzer/IRAC 3.4um flux density (6)\"                                                             fch1                           fch1                                                                 " \
                            cmd="replacecol    -name    e_FLUX_IRAC1                -units  \"mJy\"               -desc   \"Error in FLUX_IRAC1\"                                                                             dfch1                          dfch1                                                                " \
                            cmd="replacecol    -name      FLUX_IRAC2                -units  \"mJy\"               -desc   \"Spitzer/IRAC 4.5um flux density (6)\"                                                             fch2                           fch2                                                                 " \
                            cmd="replacecol    -name    e_FLUX_IRAC2                -units  \"mJy\"               -desc   \"Error in FLUX_IRAC2\"                                                                             dfch2                          dfch2                                                                " \
                            cmd="replacecol    -name      FLUX_IRAC3                -units  \"mJy\"               -desc   \"Spitzer/IRAC 5.8um flux density (6)\"                                                             fch3                           fch3                                                                 " \
                            cmd="replacecol    -name    e_FLUX_IRAC3                -units  \"mJy\"               -desc   \"Error in FLUX_IRAC3\"                                                                             dfch3                          dfch3                                                                " \
                            cmd="replacecol    -name      FLUX_IRAC4                -units  \"mJy\"               -desc   \"Spitzer/IRAC 8.0um flux density (6)\"                                                             fch4                           fch4                                                                 " \
                            cmd="replacecol    -name    e_FLUX_IRAC4                -units  \"mJy\"               -desc   \"Error in FLUX_IRAC4\"                                                                             dfch4                          dfch4                                                                " \
                            cmd="replacecol    -name      FLUX_16                   -units  \"mJy\"               -desc   \"Super-deblended Spitzer/IRS PUI  flux density\"                                                   f24                            f24                                                                  " \
                            cmd="replacecol    -name    e_FLUX_16                   -units  \"mJy\"               -desc   \"Error in FLUX_16\"                                                                                df24                           df24                                                                 " \
                            cmd="replacecol    -name      FLUX_24                   -units  \"mJy\"               -desc   \"Super-deblended Spitzer/MIPS 24um flux density\"                                                  f16                            f16                                                                  " \
                            cmd="replacecol    -name    e_FLUX_24                   -units  \"mJy\"               -desc   \"Error in FLUX_24\"                                                                                df16                           df16                                                                 " \
                            cmd="replacecol    -name      FLUX_100                  -units  \"mJy\"               -desc   \"Super-deblended Herschel/PACS 100um flux density\"                                                f100                           f100                                                                 " \
                            cmd="replacecol    -name    e_FLUX_100                  -units  \"mJy\"               -desc   \"Error in FLUX_100\"                                                                               df100                          df100                                                                " \
                            cmd="replacecol    -name      FLUX_160                  -units  \"mJy\"               -desc   \"Super-deblended Herschel/PACS 160um flux density\"                                                f160                           f160                                                                 " \
                            cmd="replacecol    -name    e_FLUX_160                  -units  \"mJy\"               -desc   \"Error in FLUX_160\"                                                                               df160                          df160                                                                " \
                            cmd="replacecol    -name      FLUX_250                  -units  \"mJy\"               -desc   \"Super-deblended Herschel/SPIRE 250um flux density\"                                               f250                           f250                                                                 " \
                            cmd="replacecol    -name    e_FLUX_250                  -units  \"mJy\"               -desc   \"Error in FLUX_250\"                                                                               df250                          df250                                                                " \
                            cmd="replacecol    -name      FLUX_350                  -units  \"mJy\"               -desc   \"Super-deblended Herschel/SPIRE 350um flux density\"                                               f350                           f350                                                                 " \
                            cmd="replacecol    -name    e_FLUX_350                  -units  \"mJy\"               -desc   \"Error in FLUX_350\"                                                                               df350                          df350                                                                " \
                            cmd="replacecol    -name      FLUX_500                  -units  \"mJy\"               -desc   \"Super-deblended Herschel/SPIRE 500um flux density\"                                               f500                           f500                                                                 " \
                            cmd="replacecol    -name    e_FLUX_500                  -units  \"mJy\"               -desc   \"Error in FLUX_500\"                                                                               df500                          df500                                                                " \
                            cmd="replacecol    -name      FLUX_850                  -units  \"mJy\"               -desc   \"Super-deblended JCMT/SCUBA2 850um flux density\"                                                  f850                           f850                                                                 " \
                            cmd="replacecol    -name    e_FLUX_850                  -units  \"mJy\"               -desc   \"Error in FLUX_850\"                                                                               df850                          df850                                                                " \
                            cmd="replacecol    -name      FLUX_1160                 -units  \"mJy\"               -desc   \"Super-deblended JCMT/AzTEC + IRAM 30m MAMBO 1.16mm flux density\"                                 f1160                          f1160                                                                " \
                            cmd="replacecol    -name    e_FLUX_1160                 -units  \"mJy\"               -desc   \"Error in FLUX_1160\"                                                                              df1160                         df1160                                                               " \
                            cmd="replacecol    -name      FLUX_20cm                 -units  \"mJy\"               -desc   \"Super-deblended VLA ~20cm  flux density\"                                                         f20cm                          f20cm                                                                " \
                            cmd="replacecol    -name    e_FLUX_20cm                 -units  \"mJy\"               -desc   \"Error in FLUX_20cm \"                                                                             df20cm                         df20cm                                                               " \
                            cmd="replacecol    -name    r_FLUX_20cm                 -units  \"---\"               -desc   \"Origin of FLUX_20cm (7)\"                                                                         Origin_20cm                    Origin_20cm                                                          " \
                            cmd="replacecol    -name      SNR_FIRmm                 -units  \"---\"               -desc   \"Super-deblended 100um-to-1mm S/N; combined in quadrature\"                                        SNR_FIRmm                      SNR_FIRmm                                                            " \
                            cmd="replacecol    -name      Mstar                     -units  \"solMass\"           -desc   \"Literature stellar mass (8)\"                                                                     Mstar                          Mstar                                                                " \
                            cmd="replacecol    -name      SFR_FIRmm                 -units  \"solMass/yr\"        -desc   \"Super-deblended SED best-fit dust-obscured SFR\"                                                  SFR_FIRmm                      SFR_FIRmm                                                            " \
                            cmd="replacecol    -name    e_SFR_FIRmm                 -units  \"solMass/yr\"        -desc   \"Error in SFR-IR\"                                                                                 e_SFR_FIRmm                    \"e_SFR_FIRmm==1E10 ? abs(1.0*SFR_FIRmm) : e_SFR_FIRmm\"             " \
                            cmd="replacecol    -name      sSFR_FIRmm                -units  \"Gyr-1\"             -desc   \"Super-deblended SED best-fit specific-SFR;=SFR/Mstar\"                                            sSFR                           sSFR                                                                 " \
                            cmd="replacecol    -name      goodArea                  -units  \"---\"               -desc   \"Super-deblended goodArea flag (9)\"                                                               goodArea                       goodArea                                                             " \
                            cmd="replacecol    -name      Type_AGN                  -units  \"---\"               -desc   \"Super-deblended SED fitting Type_AGN flag\"                                                       Type_AGN                       Type_AGN                                                             " \
                            cmd="replacecol    -name      Type_SED                  -units  \"---\"               -desc   \"Super-deblended SED fitting Type_SED flag\"                                                       Type_SED                       Type_SED                                                             " \
                            cmd="replacecol    -name      Type_FIR                  -units  \"---\"               -desc   \"Super-deblended SED fitting Type_FIR flag\"                                                       Type_FIR                       Type_FIR                                                             " \
                            cmd="replacecol    -name      SED_AGN                   -units  \"10+10.solLum\"      -desc   \"Super-deblended SED best-fit AGN luminosity\"                                                     xfAGN                          xfAGN                                                                " \
                            cmd="replacecol    -name    e_SED_AGN                   -units  \"10+10.solLum\"      -desc   \"Error in SED_AGN\"                                                                                xeAGN                          xeAGN                                                                " \
                            cmd="replacecol    -name      SED_TOT                   -units  \"10+10.solLum\"      -desc   \"Super-deblended SED best-fit total luminosity\"                                                   xfTOT                          xfTOT                                                                " \
                            cmd="replacecol    -name    e_SED_TOT                   -units  \"10+10.solLum\"      -desc   \"Error in SED_TOT\"                                                                                xeTOT                          \"xe70==0 ? abs(1.0*SED_TOT) : xeTOT\"                               " \
                            cmd="replacecol    -name      SED_70                    -units  \"mJy\"               -desc   \"Super-deblended SED predicted 70um flux density\"                                                 xf70                           xf70                                                                 " \
                            cmd="replacecol    -name    e_SED_70                    -units  \"mJy\"               -desc   \"Error in SED_70\"                                                                                 xe70                           \"xe70==0 ? abs(1.0*SED_70) : xe70\"                                 " \
                            cmd="replacecol    -name      SED_100                   -units  \"mJy\"               -desc   \"Super-deblended SED predicted 100um flux density\"                                                xf100                          xf100                                                                " \
                            cmd="replacecol    -name    e_SED_100                   -units  \"mJy\"               -desc   \"Error in SED_100\"                                                                                xe100                          \"xe100==0 ? abs(1.0*SED_100) : xe100\"                              " \
                            cmd="replacecol    -name      SED_160                   -units  \"mJy\"               -desc   \"Super-deblended SED predicted 160um flux density\"                                                xf160                          xf160                                                                " \
                            cmd="replacecol    -name    e_SED_160                   -units  \"mJy\"               -desc   \"Error in SED_160 \"                                                                               xe160                          \"xe160==0 ? abs(1.0*SED_160) : xe160\"                              " \
                            cmd="replacecol    -name      SED_250                   -units  \"mJy\"               -desc   \"Super-deblended SED predicted 250um flux density\"                                                xf250                          xf250                                                                " \
                            cmd="replacecol    -name    e_SED_250                   -units  \"mJy\"               -desc   \"Error in SED_250\"                                                                                xe250                          \"xe250==0 ? abs(1.0*SED_250) : xe250\"                              " \
                            cmd="replacecol    -name      SED_350                   -units  \"mJy\"               -desc   \"Super-deblended SED predicted 350um flux density\"                                                xf350                          xf350                                                                " \
                            cmd="replacecol    -name    e_SED_350                   -units  \"mJy\"               -desc   \"Error in SED_350\"                                                                                xe350                          \"xe350==0 ? abs(1.0*SED_350) : xe350\"                              " \
                            cmd="replacecol    -name      SED_500                   -units  \"mJy\"               -desc   \"Super-deblended SED predicted 500um flux density\"                                                xf500                          xf500                                                                " \
                            cmd="replacecol    -name    e_SED_500                   -units  \"mJy\"               -desc   \"Error in SED_500\"                                                                                xe500                          \"xe500==0 ? abs(1.0*SED_500) : xe500\"                              " \
                            cmd="replacecol    -name      SED_850                   -units  \"mJy\"               -desc   \"Super-deblended SED predicted 850um flux density\"                                                xf850                          xf850                                                                " \
                            cmd="replacecol    -name    e_SED_850                   -units  \"mJy\"               -desc   \"Error in SED_850\"                                                                                xe850                          \"xe850==0 ? abs(1.0*SED_850) : xe850\"                              " \
                            cmd="replacecol    -name      SED_1160                  -units  \"mJy\"               -desc   \"Super-deblended SED predicted 1160um flux density\"                                               xf1160                         xf1160                                                               " \
                            cmd="replacecol    -name    e_SED_1160                  -units  \"mJy\"               -desc   \"Error in SED_1160\"                                                                               xe1160                         \"xe1160==0 ? abs(1.0*SED_1160) : xe1160\"                           " \
                            cmd="replacecol    -name      SED_1200                  -units  \"mJy\"               -desc   \"Super-deblended SED predicted 1200um flux density\"                                               xf1200                         xf1200                                                               " \
                            cmd="replacecol    -name    e_SED_1200                  -units  \"mJy\"               -desc   \"Error in SED_1200\"                                                                               xe1200                         \"xe1200==0 ? abs(1.0*SED_1200) : xe1200\"                           " \
                            cmd="replacecol    -name      SED_1250                  -units  \"mJy\"               -desc   \"Super-deblended SED predicted 1250um flux density\"                                               xf1250                         xf1250                                                               " \
                            cmd="replacecol    -name    e_SED_1250                  -units  \"mJy\"               -desc   \"Error in SED_1250\"                                                                               xe1250                         \"xe1250==0 ? abs(1.0*SED_1250) : xe1250\"                           " \
                            cmd="replacecol    -name      SED_2000                  -units  \"mJy\"               -desc   \"Super-deblended SED predicted 2000um flux density\"                                               xf2000                         xf2000                                                               " \
                            cmd="replacecol    -name    e_SED_2000                  -units  \"mJy\"               -desc   \"Error in SED_2000\"                                                                               xe2000                         \"xe2000==0 ? abs(1.0*SED_2000) : xe2000\"                           " \
                            cmd="replacecol    -name      SED_2050                  -units  \"mJy\"               -desc   \"Super-deblended SED predicted 2050um flux density\"                                               xf2050                         xf2050                                                               " \
                            cmd="replacecol    -name    e_SED_2050                  -units  \"mJy\"               -desc   \"Error in SED_2050\"                                                                               xe2050                         \"xe2050==0 ? abs(1.0*SED_2050) : xe2050\"                           " \
                            cmd="replacecol    -name      SED_10cm                  -units  \"mJy\"               -desc   \"Super-deblended SED predicted 10cm flux density\"                                                 xf10cm                         xf10cm                                                               " \
                            cmd="replacecol    -name    e_SED_10cm                  -units  \"mJy\"               -desc   \"Error in SED_10cm\"                                                                               xe10cm                         \"xe10cm==0 ? abs(1.0*SED_10cm) : xe10cm\"                           " \
                            cmd="replacecol    -name      SED_20cm                  -units  \"mJy\"               -desc   \"Super-deblended SED predicted 20cm flux density\"                                                 xf20cm                         xf20cm                                                               " \
                            cmd="replacecol    -name    e_SED_20cm                  -units  \"mJy\"               -desc   \"Error in SED_20cm\"                                                                               xe20cm                         \"xe20cm==0 ? abs(1.0*SED_20cm) : xe20cm\"                           " \
                            cmd="replacecol    -name      chisq_total               -units  \"---\"               -desc   \"Super-deblended SED chi-squ. of fitted data points for whole SED\"                                chisq_tot                      chisq_tot                                                            " \
                            cmd="replacecol    -name      nfit_total                -units  \"---\"               -desc   \"Number of fitted data points in chisqTot \"                                                       nfit_tot                       nfit_tot                                                             " \
                            cmd="replacecol    -name      chisq_stellar             -units  \"---\"               -desc   \"Super-deblended SED chi-sq. of fitted data points for stellar component of SED \"                 chisq_star                     chisq_star                                                           " \
                            cmd="replacecol    -name      nfit_stellar              -units  \"---\"               -desc   \"Number of fitted data points in chisq*\"                                                          nfit_star                      nfit_star                                                            " \
                            cmd="replacecol    -name      chisq_dust                -units  \"---\"               -desc   \"Super-deblended SED chi-sq. of fitted data points for dust component of the SED\"                 chisq_dust                     chisq_dust                                                           " \
                            cmd="replacecol    -name      nfit_dust                 -units  \"---\"               -desc   \"Number of fitted data points for chisqD\"                                                         nfit_dust                      nfit_dust                                                            " \
                            cmd="replacecol    -name      U_FIRmm                   -units  \"---\"               -desc   \"Super-deblended SED best-fit dust template mean interstellar radiation field strength (10)\"      U_FIRmm                        U_FIRmm                                                              " \
                            cmd="replacecol    -name      SFR_total                 -units  \"solMass/yr\"        -desc   \"Sum of UV-unattenuated SFR and super-deblended SED best-fit dust-obscured SFR\"                   SFR_total                      SFR_total                                                            " \
                            cmd="replacecol    -name      SFR_dust_over_SFR_total   -units  \"---\"               -desc   \"Ratio of UV-unattenuated and super-deblended SED best-fit dust-obscured SFRs\"                    SFR_dust_over_SFR_total        SFR_dust_over_SFR_total                                              " \
                            out="GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.fits"
    # 
    topcat -stilts tpipe in="GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.fits" omode=meta \
                           >"GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.header.txt"
    # 
    topcat -stilts tpipe in="GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.fits" \
                        out="GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.ascii.txt" ofmt=ascii
    # 
    topcat -stilts tpipe in="GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.fits" \
                        out="GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.csv" ofmt=csv
    # 
    # 
    # <DEBUG> 
    topcat -stilts tpipe in="GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.fits" \
                        cmd="delcols \"e_FLUX_K\"" \
                        out="GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}_no_dfK.fits"
    # 
    topcat -stilts tpipe in="GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}_no_dfK.fits" \
                        out="GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}_no_dfK.ascii.txt" ofmt=ascii
    # 
    topcat -stilts tpipe in="GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}_no_dfK.fits" \
                        out="GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}_no_dfK.csv" ofmt=csv
fi




echo "ID                                       I5             " >  "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "RA                                       F11.7          " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "Dec                                      F10.7          " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "z_phot                                   F6.2           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "ref_z_phot                               I3             " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "z_spec                                   F8.4           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "ref_z_spec                               I4             " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "z_FIRmm                                  F5.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_z_FIRmm                                F5.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "FLUX_K                                  E10.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_FLUX_K                                 E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "FLUX_IRAC1                              E10.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_FLUX_IRAC1                             E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "FLUX_IRAC2                              E10.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_FLUX_IRAC2                             E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "FLUX_IRAC3                              E10.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_FLUX_IRAC3                             E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "FLUX_IRAC4                              E10.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_FLUX_IRAC4                             E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "FLUX_16                                 E10.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_FLUX_16                                E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "FLUX_24                                 E10.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_FLUX_24                                E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "FLUX_100                                E10.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_FLUX_100                               E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "FLUX_160                                E10.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_FLUX_160                               E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "FLUX_250                                E10.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_FLUX_250                               E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "FLUX_350                                E10.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_FLUX_350                               E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "FLUX_500                                E10.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_FLUX_500                               E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "FLUX_850                                E10.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_FLUX_850                               E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "FLUX_1160                               E10.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_FLUX_1160                              E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "FLUX_20cm                               E10.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_FLUX_20cm                              E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "r_FLUX_20cm                              I1             " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SNR_FIRmm                                F7.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "Mstar                                    E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SFR_FIRmm                                F8.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_SFR_FIRmm                              F9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "sSFR_FIRmm                               F9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "goodArea                                 I1             " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "Type_AGN                                 I1             " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "Type_SED                                 I2             " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "Type_FIR                                 I1             " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SED_AGN                                  F8.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_SED_AGN                                F8.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SED_TOT                                  F8.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_SED_TOT                                F8.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SED_70                                   E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_SED_70                                 E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SED_100                                  E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_SED_100                                E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SED_160                                  E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_SED_160                                E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SED_250                                  E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_SED_250                                E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SED_350                                  E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_SED_350                                E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SED_500                                  E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_SED_500                                E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SED_850                                  E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_SED_850                                E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SED_1160                                 E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_SED_1160                               E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SED_1200                                 E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_SED_1200                               E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SED_1250                                 E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_SED_1250                               E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SED_2000                                 E10.3          " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_SED_2000                               E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SED_2050                                 E10.3          " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_SED_2050                               E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SED_10cm                                 E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_SED_10cm                               E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SED_20cm                                 E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "e_SED_20cm                               E9.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "chisq_total                              F7.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "nfit_total                               I2             " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "chisq_stellar                            F7.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "nfit_stellar                             I1             " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "chisq_dust                               F7.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "nfit_dust                                I2             " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "U_FIRmm                                  F5.1           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SFR_total                                F8.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"
echo "SFR_dust_over_SFR_total                  F5.3           " >> "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt"






# 
# <DEBUG>
cat "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt" | grep -v "^e_FLUX_K" > "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}_no_dfK.colfmt.txt"






#python2.7 << EOF
#import astropy
#import astropy.io.ascii as asciitable
#dt = asciitable.read('GOODSN_FIR+mm_Catalog_20170905_all_columns_v7.ascii.txt')
#asciitable.write(dt, 'GOODSN_FIR+mm_Catalog_20170905_all_columns_v7.ascii.cds', Writer=asciitable.Cds)
#EOF


#idl << EOF
#dfmt = read_table("GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt", /TEXT)
#dtab = read_table("GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.ascii.txt", HEAD=1, /double)
#CrabTablePrintF, "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.ascii.cds", dtab, format=dfmt[1,*], padding=' '
#EOF


#idl << EOF
#dfmt = read_table("GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt", /TEXT)
#dtab = make_array([90, 3306], /double)
#for i=0,90-1 do begin ftab_ext, "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.fits", i, dcol & dtab[i,*] = double(dcol) & endfor
#CrabTablePrintF, "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.ascii.cds", dtab, format=dfmt[1,*], padding=' '
#EOF


idl << EOF
ncol = 90
nrow = 3306
dfmt = read_table("GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.colfmt.txt", /TEXT)
stab = READ_CSV("GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.csv", N_TABLE_HEADER=1, TYPES=REPLICATE("String",ncol))
dtab = make_array([ncol, nrow], /double)
for i=0,ncol-1 do begin dtab[i,*] = stab.(i) & endfor
CrabTablePrintF, "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}.ascii.cds", dtab, format=dfmt[1,*], padding=' '
EOF


idl << EOF
ncol = 89
nrow = 3306
dfmt = read_table("GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}_no_dfK.colfmt.txt", /TEXT)
stab = READ_CSV("GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}_no_dfK.csv", N_TABLE_HEADER=1, TYPES=REPLICATE("String",ncol))
dtab = make_array([ncol, nrow], /double)
for i=0,ncol-1 do begin dtab[i,*] = stab.(i) + stab.(i) * 1e-10 & endfor
CrabTablePrintF, "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}_no_dfK.ascii.cds", dtab, format=dfmt[1,*], padding=' '
EOF

perl -i -p -e 's/([0-9]+)\.0 / \1. /g' "GOODSN_FIR+mm_Catalog_20170905_all_columns_v${version}_no_dfK.ascii.cds"



#ftab_ext, "GOODSN_FIR+mm_Catalog_20170905_all_columns_v9_no_dfK.fits", 42, rows=[11], dcol
#stab = READ_CSV("GOODSN_FIR+mm_Catalog_20170905_all_columns_v9_no_dfK.csv", N_TABLE_HEADER=1, TYPES=REPLICATE("String",89))
#print, stab.(41)[11], size(stab.(41)[11])
#dtab = make_array([89, 3306], /float)
#for i=0,89-1 do begin dtab[i,*] = stab.(i) & endfor
#print, dtab[41,11], size(dtab[41,11])
#print, string(format='(F15.3)', dtab[41,11])


