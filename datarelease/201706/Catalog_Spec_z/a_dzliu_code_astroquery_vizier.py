#!/usr/bin/env python
# 


import os, sys, re
import astroquery
import astropy
from pprint import pprint



# Turtorial
# http://astroquery.readthedocs.io/en/latest/vizier/vizier.html

# 
# Query catalog
# 
#from astroquery.vizier import Vizier
#catalog_list = Vizier.find_catalogs('Lowenthal 1997')
##pprint({k:v.description for k,v in catalog_list.items()})
#Vizier.ROW_LIMIT = -1
#catalogs = Vizier.get_catalogs(catalog_list.keys())
#pprint(catalogs)


# 
# Query RA Dec
# 
from astroquery.vizier import Vizier
from astropy.coordinates import Angle
import astropy.units as units
import astropy.coordinates as coord
result = Vizier.query_region(coord.SkyCoord(ra=299.590, dec=35.201,
                                            unit=(units.deg, units.deg),
                                            frame='icrs'),
                                            width="30m",
                                            catalog=["NOMAD", "UCAC"])


