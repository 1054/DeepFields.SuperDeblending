#!/bin/bash
# 

#topcat -stilts tpipe \
#                in="datatable_CrossMatched_selected_columns_converted_to_SFRs.txt" \
#                ifmt=ascii \
#                cmd="addcol SFR_UV_revised \"(xfAGN>1 && xfAGN>SFR_IR) ? SFR_UV_from_SFR_IR : SFR_UV\"" \
#                cmd="replacecol SFR_UV_revised \"(SFR_UV_revised<0) ? 0.0 : SFR_UV_revised\"" \
#                cmd="addcol SFR_total \"(SFR_UV_revised + SFR_IR)\"" \
#                cmd="addcol SFR_IR/SFR_total \"(SFR_IR/SFR_total)\"" \
#                ofmt=ascii \
#                out="datatable_CrossMatched_selected_columns_converted_to_SFRs_computed_SFR_total.txt"
#                # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/tpipe.html

# 20171030
topcat -stilts tpipe \
                in="datatable_CrossMatched_selected_columns_converted_to_SFRs.txt" \
                ifmt=ascii \
                cmd="addcol SFR_IR/SFR_total \"(SFR_IR/SFR_total)\"" \
                ofmt=ascii \
                out="datatable_CrossMatched_selected_columns_converted_to_SFRs_computed_SFR_total.txt"
                # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/tpipe.html

topcat -stilts tpipe \
                in="datatable_CrossMatched_selected_columns_converted_to_SFRs_computed_SFR_total.txt" \
                ifmt=ascii \
                cmd="select \"(SNR_IR>=5 && goodArea==1)\"" \
                ofmt=ascii \
                out="datatable_CrossMatched_selected_columns_converted_to_SFRs_computed_SFR_total_goodArea.txt"
                # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/tpipe.html

topcat -stilts tpipe \
                in="datatable_CrossMatched_selected_columns_converted_to_SFRs_computed_SFR_total.txt" \
                ifmt=ascii \
                cmd="keepcols \"id SFR_total SFR_IR/SFR_total\"" \
                ofmt=ascii \
                out="../RadioOwenMIPS24_priors_dzliu_20170905_SFR_total.txt"
                # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/tpipe.html
