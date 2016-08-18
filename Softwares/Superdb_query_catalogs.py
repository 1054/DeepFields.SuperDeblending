#!/usr/bin/python
# 
# 

try:
    import sys
    print("import sys")
except ImportError:
    sys.exit()

try:
    import os
    print("import os")
except ImportError:
    sys.exit()

try:
    import re
    print("import re")
except ImportError:
    sys.exit()

try:
    import subprocess
    print("import subprocess")
except ImportError:
    sys.exit()

try:
    import PyQt5
    print("import PtQt5")
except ImportError:
    sys.exit()

try:
    import astroquery
    print("import astroquery")
except ImportError:
    sys.exit()

try:
    import json
    print("import json")
except ImportError:
    sys.exit()

try:
    import pycurl
    print("import pycurl")
    try:
        from io import BytesIO
    except ImportError:
        from StringIO import StringIO as BytesIO
    try:
        # python 3
        from urllib.parse import urlencode
    except ImportError:
        # python 2
        from urllib import urlencode
except ImportError:
    sys.exit()

try:
    from bs4 import BeautifulSoup
    print("import BeautifulSoup")
except ImportError:
    sys.exit()

try:
    from Superdb_query_cutouts import *
    print("import Superdb_query_cutouts")
except ImportError:
    sys.exit()



def query_catalog_HERMES(input_radec):
    # 
    # Read HERMES catalog and cutouts
    # http://hedam.lam.fr/HerMES/search/multiple
    # 
    # HERMES catalog paper
    # Oliver et al. 2012
    # http://cdsbib.u-strasbg.fr/cgi-bin/cdsbib?2012MNRAS.424.1614O
    # http://cdsarc.u-strasbg.fr/viz-bin/Cat?VIII/95
    # 
    QueryFoV = '15' # arcsec
    QueryPos = convert_radec(input_radec)
    QueryPos_RA = float(QueryPos.split(' ')[0])
    QueryPos_Dec = float(QueryPos.split(' ')[1])
    #print(QueryPos)
    #print(QueryPos_RA, QueryPos_Dec)
    # 
    #QueryStr = 'http://hedam.lam.fr/HerMES/search/multiple'
    QueryStr = 'http://hedam.lam.fr/HerMES/result/multiple'
    # 
    print('\n')
    print(QueryStr)
    print('\n')
    # 
    #QueryKey = (('radeg',QueryPos_RA), ('decdeg',QueryPos_Dec), ('radius',0.1), ('dataset','all_scat500_dr2'), ('dataset','all_xid250_dr2'))
    #QueryKey = {'radeg':QueryPos_RA, 'decdeg':QueryPos_Dec, 'radius':0.1, 'SCATall_scat500_dr2':'all_scat500_dr2', 'xID250all_xid250_dr2':'all_xid250_dr2'}
    QueryKey = {'radeg':QueryPos_RA, 'decdeg':QueryPos_Dec, 'radius':0.1, 'xID250all_xid24_dr3':'all_xid24_dr3'}
    # 
    QueryBody = query_HTTP(QueryStr,QueryKey,Verbose=False)
    # 
    QuerySoup = BeautifulSoup(QueryBody.decode(),'html.parser')
    #print(QuerySoup.prettify())
    #print(QuerySoup.title)
    #print(QuerySoup.title.name)
    # 
    # OK we got a HERMES query result page, but this is not the final one, this page contains a javascript code indicating a request which needs to be further POSTed. 
    # 
    for QuerySoup_script in QuerySoup.find_all('script'):
        #print(type(QuerySoup_script))  # <class 'bs4.element.Tag'>
        #print(QuerySoup_script)
        QuerySoup_string = str(QuerySoup_script.string)
        if QuerySoup_string.find("datatables/")>0:
            #print(QuerySoup_script)
            # 
            # Prepare for POST to get table config
            # 
            QueryStr2 = 'http://hedam.lam.fr/HerMES/datatables/tableConfig' # QueryStr2 = 'http://hedam.lam.fr/HerMES/datatables/tableData'
            QueryKey2 = {'dataset':"all_xid24_dr3", 'nbobj':"1", 'request':""}
            QueryKey2_request = re.search('request:[ ]*"(.*)"',QuerySoup_string)
            if QueryKey2_request:
                QueryKey2['request'] = QueryKey2_request.group(1)
            # 
            # POST to get table config
            # 
            QueryBody2 = query_HTTP(QueryStr2,QueryKey2,UsePreviousCookie=True,Verbose=False) # Must use previous cookie
            QueryJson2 = json.loads(QueryBody2.decode())
            QueryJson2_columns = QueryJson2['aoColumns']
            QueryJson2_columns_sname = [x['sName'] for x in QueryJson2_columns]
            print(QueryJson2_columns_sname)
            # 
            #QuerySoup2 = BeautifulSoup(QueryBody2.decode(),'html.parser')
            #print(QuerySoup2.prettify())
            # 
            # Prepare for POST to get export data
            # 
            QueryStr3 = 'http://hedam.lam.fr/HerMES/datatables/export-data'
            QueryKey3 = QueryKey2
            QueryKey3['format'] = 'ascii'
            # 
            # POST to get export data
            # 
            QueryBody3 = query_HTTP(QueryStr3,QueryKey3,UsePreviousCookie=True,Verbose=False) # Must use previous cookie
            QueryBody3_columns_data = QueryBody3.decode().replace('#\n','').strip().split()
            print(QueryBody3_columns_data)
    
    











# 
# MAIN CODE
# TEST
# 

# query_catalog_HERMES('17h13m31.69s +58d58m04.60s') # L6-FLS HerMES-xID24-536772 258.381334 58.96787 6273.7505 22.251 170.01053 2.349751 6.4388514 7.774519 86.24825 2.6078856 5.9115176 1.550334 27.600721 7.093909 8.142955 1.316574 19822.0

query_catalog_HERMES('10h35m58.02s +58d58m46.17s') #






















