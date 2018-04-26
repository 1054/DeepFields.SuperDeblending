#!/bin/bash
# 


# 
# use 'https://github.com/mfouesneau/radec_density'
# 

/Users/dzliu/Cloud/Github/3rd/radec_density/radec_density -i 'datatables/datatable_GOODSN_ID_RA_DEC.txt' -o 'datatables/datatable_GOODSN_ID_RA_DEC.hist' --dra 2 --ddec 3
/Users/dzliu/Cloud/Github/3rd/radec_density/plot.py 'datatables/datatable_GOODSN_ID_RA_DEC.hist' --title RADEC -o sample_icrs.png

