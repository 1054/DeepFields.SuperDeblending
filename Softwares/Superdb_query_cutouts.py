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
    import astropy
    print("import astropy")
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




# 
# RA DEC FORMAT FUNCTION
# query_string_convert_radec_sexagesemal_to_degree
# 
def format_radec(input_radec):
    count_colon = 0
    output_radec = ''
    if not input_radec.startswith('+'):
        output_radec += '+'
    if input_radec.find(':')>0:
        for i in range(len(input_radec)):
            if input_radec[i] == ':':
                if count_colon == 0:
                    count_colon += 1
                    output_radec += 'h+'
                elif count_colon == 1:
                    count_colon += 1
                    output_radec += 'm+'
                elif count_colon == 2:
                    count_colon += 1
                    output_radec += 'd+'
                elif count_colon == 3:
                    count_colon += 1
                    output_radec += 'm+'
            elif i>0 and input_radec[i] == '+':
                output_radec += 's+'
            elif i>0 and input_radec[i] == ', ':
                output_radec += 's+'
            elif i>0 and input_radec[i] == ',':
                output_radec += 's+'
            elif i>0 and input_radec[i] == ' ':
                output_radec += 's+'
            else:
                output_radec += input_radec[i]
    else:
        output_radec += input_radec
    if not output_radec.replace('J2000','').replace(' ','').endswith('s'):
        output_radec += 's'
    if not output_radec.endswith('+Equ+J2000'):
        output_radec += '+Equ+J2000'
    return output_radec




# 
# RA DEC FORMAT FUNCTION
# Need dzliu code "radec2degree"
# 
def convert_radec(input_radec):
    output_radec = ''
    if input_radec.find(':')>0 or input_radec.find('h')>0:
        output_radec = (subprocess.check_output("radec2degree %s"%(input_radec.replace(',',' ')), shell=True)).decode("utf-8").strip()
        #print(output_radec)
        #print(len(output_radec))
        #print(output_radec.split())
    else:
        output_radec = input_radec
    return output_radec



# 
# Use HERMES cutout service
# http://hedam.lam.fr/HerMES/result/multiple
# 
def query_cutouts_HERMES(input_radec):
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
    QueryKey = {'radeg':QueryPos_RA, 'decdeg':QueryPos_Dec, 'radius':float(QueryFoV.replace('arcsec',''))/60.0, 'SCATall_scat250_dr2':'all_scat250_dr2'}
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
        if QuerySoup_string.find("img/list-images")>0:
            #print(QuerySoup_script)
            # 
            # Read the fits data url
            #QuerySoup_fits_url = re.search(".*,\s*'(.*)',\s*images\s*\);dialogbox.build\(\);",QuerySoup_string)
            QuerySoup_fits_url = re.search(".*,\s*\'(.*)\',\s*images\s*\);",QuerySoup_string)
            if QuerySoup_fits_url:
                QuerySoup_fits_url = QuerySoup_fits_url.group(1)
                #print(QuerySoup_fits_url.group(1))
            else:
                print("Error! Could not read fits url from:")
                print(QuerySoup_string)
            # 
            # Prepare for GET to get image name
            # 
            QueryStr2 = 'http://hedam.lam.fr/HerMES/img/list-images' # Use Chrome to Inspect the HERMES LAM webpage, check Network list-images?dataset=all..... things
            QueryVar2 = {'dataset':"all_scat250_dr2", 'radius':float(QueryFoV.replace('arcsec',''))/3600.0, 'coordinates[]':"%0.10f|%0.10f"%(QueryPos_RA,QueryPos_Dec)}
            QueryStr2 = QueryStr2 + '?' + urlencode(QueryVar2)
            #print(QueryStr2)
            # 
            # GET to get image name
            # 
            QueryBody2 = query_HTTP(QueryStr2,UsePreviousCookie=True,Verbose=False) # Must use previous cookie
            QueryJson2 = json.loads(QueryBody2.decode())
            #QueryJson2_fits_urls = [x['url'] for x in QueryJson2]
            QueryJson2_fits_name = QueryJson2[0]['url']
            # 
            # Prepare for GET to get real fits image
            # 
            QueryStr3 = 'http://cesam.lam.fr/anis-tools/fitscut/'
            #QueryStr3 = 'http://tools-si.lam.fr/fitscut/'
            QueryVar3 = {'file':QuerySoup_fits_url+'/'+QueryJson2_fits_name, 'alpha':QueryPos_RA, 'delta':QueryPos_Dec, 'radius':float(QueryFoV.replace('arcsec',''))/3600.0}
            QueryStr3 = QueryStr3 + '?' + urlencode(QueryVar3)
            print(QueryStr3)
            # 
            # GET to get image name
            # 
            QueryBody3 = query_HTTP(QueryStr3) # Download the fits image
            with open(QueryJson2_fits_name,'wb') as fp:
                fp.write(QueryBody3)
                print "Successfully written to "+QueryJson2_fits_name



# 
# Use MAST cutout service
# https://archive.stsci.edu/eidol_v2.php
# 
def query_cutouts_MAST(input_radec):
    QueryFoV = '5' # arcsec
    QueryPos = input_radec # '12:36:49.644,62:12:57.51'
    QueryBands = ['a','b','c']
    # 
    QueryVar = {'POS':input_radec, 
                'resolver':'Resolve', 
                'SIZE':5.0, 
                'max_images':5, 
                'CREATE_WHT':0, 
                'CREATE_FITS':1, 
                'IMAGE_FORMAT':'png', 
                'CREATE_TAR':0, 
                'action':'Search', 
                'outputformat':'HTML_Table'}
    # 
    QueryStr = 'https://archive.stsci.edu/eidol_v2.php?'+\
               urlencode(QueryVar)
    # 
    print('\n')
    print(QueryStr)
    print('\n')
    # 
    QueryBody = query_HTTP(QueryStr)
    # 
    #<TODO>



# 
# Use IRSA cutout service
# http://irsa.ipac.caltech.edu/applications/Cutouts/docs/CutoutsProgramInterface.html
# 
def query_cutouts_IRSA(input_radec, Mission="COSMOS"):
    QueryFoV = '15' # arcsec
    QueryPos = format_radec(input_radec)
    #QueryPos = '+16h+38m+06.53s+-45d+52m+55.3s+Equ+J2000'
    #QueryPos = format_radec('12:36:49.644 62:12:57.51')
    #QueryPos = 'COMBO-17+30561'
    QueryBands = ['Spitzer_MIPS_DR3'] # 'Spitzer_IRAC_DR3'
    # 
    QueryStr = 'http://irsa.ipac.caltech.edu/cgi-bin/Cutouts/nph-cutouts?'+\
               'mission=%s&'%(Mission)+\
               'min_size=%s&'%('1')+\
               'max_size=%s&'%('600')+\
               'units=arcsec&'+\
               'locstr=%s&'%(QueryPos)+\
               'sizeX=%s&'%(QueryFoV)+\
               'ntable_cutouts=%d&'%(len(QueryBands))
    # 
    for i in range(len(QueryBands)):
        QueryStr += 'cutouttbl%d=%s&'%(i+1,QueryBands[i])+\
                    'mode=PI' # set mode to Program Interface (PI)
    # 
    print('\n')
    print(QueryStr)
    print('\n')
    # 
    QueryBody = query_HTTP(QueryStr)
    # 
    QuerySoup = BeautifulSoup(QueryBody.decode(),'html.parser')
    #print(QuerySoup.prettify())
    #print(QuerySoup.title)
    #print(QuerySoup.title.name)
    for QuerySoup_link in QuerySoup.find_all('a'):
        QuerySoup_link_href = QuerySoup_link.get('href')
        if QuerySoup_link_href.endswith('.fits'):
           	print('http://www.stsci.edu/resources'+QuerySoup_link_href)



# 
# Query HTTP 
# header_function
# http://pycurl.io/docs/latest/quickstart.html
# 
QueryHeads = []
QueryHeaders = {}
def query_HTTP_header_function(header_line):
    # HTTP standard specifies that headers are encoded in iso-8859-1.
    # On Python 2, decoding step can be skipped.
    # On Python 3, decoding step is required.
    header_line = header_line.decode('iso-8859-1')
    # Header lines include the first status line (HTTP/1.x ...).
    # We are going to ignore all lines that don't have a colon in them.
    # This will botch headers that are split on multiple lines...
    QueryHeads.append(header_line)
    if ':' not in header_line: return
    # Break the header line into header name and value.
    name, value = header_line.split(':', 1)
    # Remove whitespace that may be present.
    # Header lines include the trailing newline, and there may be whitespace
    # around the colon.
    name = name.strip()
    value = value.strip()
    # Header names are case insensitive.
    # Lowercase name here.
    name = name.lower()
    # Now we can actually record the header name and value.
    QueryHeaders[name] = value



# 
# Query HTTP
# core function to send and read http 
# 
def query_HTTP(QueryStr,QueryKey={},QueryGet={},FollowRedirect=True,UsePreviousCookie=False,Verbose=False):
    # 
    #QueryData = urllib.request.urlopen(QueryStr)
    # 
    #QueryRequest = urllib.request.Request(QueryStr)
    #QueryRequest.add_header('Referer', 'http://www.python.org/')
    #QueryData = urllib.request.urlopen(QueryRequest)
    
    ## Create an OpenerDirector with support for Basic HTTP Authentication...
    #auth_handler = urllib2.HTTPBasicAuthHandler()
    #auth_handler.add_password('realm', 'host', 'username', 'password')
    #opener = urllib2.build_opener(auth_handler)
    
    #QueryOpener = urllib.request.build_opener()
    #QueryOpener.addheaders = [('User-agent', 'Mozilla/5.0')] # Content-Length:, Content-Type:, Host:, Range:)
    #QueryOpener.open(QueryStr)
    
    ##QueryRequest = requests.get('https://api.github.com/user', auth=('user', 'pass'))
    #QueryRequest = requests.get(QueryStr)
    #QueryRequest.status_code
    #QueryRequest.headers['content-type']
    #QueryRequest.text
    #QueryRequest.json()
    
    QueryBuffer = BytesIO()
    QueryCURL = pycurl.Curl()
    QueryCURL.setopt(QueryCURL.URL, QueryStr)
    if UsePreviousCookie:
        QueryCURL.setopt(QueryCURL.COOKIEFILE, '.Superdb.query.cookie.txt')
    else:
        QueryCURL.setopt(QueryCURL.COOKIEJAR, '.Superdb.query.cookie.txt')
    if Verbose:
        QueryCURL.setopt(QueryCURL.VERBOSE, True)
    if FollowRedirect:
        QueryCURL.setopt(QueryCURL.FOLLOWLOCATION, True)
    if len(QueryGet)>0:
        QueryCURL.setopt(QueryCURL.HTTPGET, 1)
    if len(QueryKey)>0:
        if Verbose:
            print(QueryKey)
            print("\n")
        QueryCURL.setopt(QueryCURL.POST, 1)
        QueryCURL.setopt(QueryCURL.POSTFIELDS, urlencode(QueryKey))
    QueryCURL.setopt(QueryCURL.WRITEFUNCTION, QueryBuffer.write)
    QueryCURL.setopt(QueryCURL.HEADERFUNCTION, query_HTTP_header_function) # Set the header function.
    QueryCURL.perform()
    QueryCURL.close()
    
    QueryBody = QueryBuffer.getvalue()
    #print(QueryHeads)
    #print(QueryHeaders)
    #print(QueryBody.decode())
    
    return QueryBody











# 
# MAIN CODE
# TEST
# 

# query_cutouts_MAST('12:36:49.644,62:12:57.51')

# query_cutouts_HERMES('12:36:49.644,62:12:57.51')

query_cutouts_IRSA('12:36:49.644,62:12:57.51', Mission="COSMOS")
























































