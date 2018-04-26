#!/usr/bin/env python3.6
# 

import numpy as np
import matplotlib.pyplot as plt
import mpl_toolkits
from mpl_toolkits.basemap import Basemap
import matplotlib.patheffects
from matplotlib import rcParams
import astropy.io.ascii as asciitable
#from scipy import stats
from astropy.wcs import WCS
from astropy.io import fits





















#############
# Functions #
#############

rcParams['font.family'] = 'serif'
rcParams['text.latex.preamble'] = [r'\usepackage{amsmath}']
rcParams['font.size'] = 14

def get_radec_basemap(projection='moll', resolution='c', lat_0=0., lon_0=0., angle_shift=0.0, **kwargs):
    """ Generate a Basemap for angular plot -- adapted from 'https://github.com/mfouesneau/radec_density'
    
    Parameters
    ----------
    projection: string
        projection name (see: :class:`basemap.Basemap`)
    
    resolution: string
        resolution of the projection (see: :class:`basemap.Basemap`)
    
    lon_0: float
        origin of the reference (see: :class:`basemap.Basemap`)
    
    kwars: dict
        forwarded to :func:`Basemap`
    
    returns
    -------
    m: Basemap instance
        result from :func:`Basemap`
    """
    # generate the basemap for the plot
    m = Basemap(projection=projection,
                lon_0=lon_0, lat_0=lat_0,
                resolution=resolution, **kwargs)
    
    m.drawmapboundary(fill_color='white')
    
    angle_start = 0.0
    angle_end = 360.0
    angle_nbin = 12
    
    m.drawmeridians(np.arange(angle_start+angle_shift, angle_end+angle_shift, 360./angle_nbin),
                    labels=[0, 0, 0, 0],
                    color='black',
                    dashes=[1,1],
                    labelstyle='+/-',
                    linewidth=0.1)
    
    m.drawparallels(np.arange(-90, 91, 20),
                    labels=[1,0,0,0],
                    color='black',
                    dashes=[1,1],
                    labelstyle='+/-',
                    linewidth=0.1)
    
    # add manually the meridian labels for this projection
    ef = matplotlib.patheffects.withStroke(foreground="w", linewidth=3)
    for k in np.arange(angle_start+angle_shift, angle_end+angle_shift, 360./angle_nbin):
        val = (k-angle_shift)/360.*24.
        #x, y = m(k, 0)
        x, y = m(k, -30)
        plt.text(x, y, '%0.0fh'%(val), path_effects=[ef], ha='center', va='center')
    
    return m










































########
# Main #
########

if __name__ == "__main__":
    
    
    
    hdu = fits.open('datatables/datatable_ID_RA_DEC_GOODSN_850.fits.gz')[1]
    data2 = hdu.data
    data2_ra = data2['RA']
    data2_dec = data2['Dec']
    
    
    hdu = fits.open('datatables/datatable_ID_RA_DEC_COSMOS_master_catalog_201704.fits.gz')[1]
    data = hdu.data
    data_ra = data['RA']
    data_dec = data['Dec']
    
    
    
    
    fig = plt.figure(figsize=(10,7))
    ax = fig.add_subplot(1,1,1)
    angle_shift = -90.0
    base_map = get_radec_basemap(angle_shift=angle_shift)
    #density = stats.kde.gaussian_kde((data_ra,data_dec))
    m_ra = data_ra # np.median(data_ra)
    m_dec = data_dec # np.median(data_dec)
    xs, ys = base_map(m_ra+angle_shift, m_dec)
    ax.hexbin(xs, ys, gridsize=(5,5)) # here we do not plot millions of data points but use hexbin -- https://python-graph-gallery.com/84-hexbin-plot-with-matplotlib/
    ax.annotate('COSMOS', xy=(0.001, 1.001), color='#000000', ha='left', va='bottom', xycoords=ax.transAxes, zorder=10, fontsize=18, fontweight='bold')
    plt.subplots_adjust(left=0.1, bottom=0.1, right=0.9, top=0.9)
    fig.savefig('Plot_All_Sky_Map_COSMOS.pdf')
    #plt.show(block=True)
    
    
    
    hdu = fits.open('photos/COSMOS_Photos/mips_24_GO3_sci_10.null.fits.gz')[0]
    wcs = WCS(hdu.header)
    
    fig2 = plt.figure(figsize=(7,6))
    ax2 = fig2.add_subplot(1,1,1, projection=wcs)
    ax2.set_axisbelow(True) # not working
    ax2.grid(color='#333333', ls='dashed', alpha=0.5)
    data_px, data_py = wcs.wcs_world2pix(data_ra, data_dec, 1) # 3rd arg: origin is the coordinate in the upper left corner of the image. In FITS and Fortran standards, this is 1. In Numpy and C standards this is 0.
    data2_px, data2_py = wcs.wcs_world2pix(data2_ra, data2_dec, 1) # 3rd arg: origin is the coordinate in the upper left corner of the image. In FITS and Fortran standards, this is 1. In Numpy and C standards this is 0.
    ax2.hexbin(data_px, data_py, gridsize=(50,50), cmap=plt.get_cmap('GnBu')) # gridsize means nhexbin
    ax2.plot(data2_px, data2_py, '.', ms=2.5, c='#ff8d1e')
    ax2.set_xlabel('Right Ascension (J2000)', fontsize=15, fontweight='bold')
    ax2.set_ylabel('Declination (J2000)', fontsize=15, fontweight='bold')
    ax2.invert_xaxis()
    ax2.annotate('COSMOS', xy=(0.01, 0.99), color='#000000', ha='left', va='top', xycoords=ax2.transAxes, zorder=10, fontsize=15, fontweight='bold')
    ax2.annotate('Spitzer/IRAC', xy=(0.99, 0.99), color='#1e90ff', ha='right', va='top', xycoords=ax2.transAxes, zorder=10, fontsize=15, fontweight='bold')
    ax2.annotate('JCMT/SCUBA2', xy=(0.99, 0.94), color='#ff8d1e', ha='right', va='top', xycoords=ax2.transAxes, zorder=10, fontsize=15, fontweight='bold')
    plt.subplots_adjust(left=0.25, bottom=0.15, right=0.95, top=0.95)
    aspect2 = 1 # / np.cos((ax2.get_ylim()[1]+ax2.get_ylim()[0])/2.0/180.0*np.pi)
    print('RA size = %s [arcmin]'%(abs(ax2.get_xlim()[1]-ax2.get_xlim()[0])*60.0))
    print('Dec size = %s [arcmin]'%(abs(ax2.get_ylim()[1]-ax2.get_ylim()[0])*60.0))
    print('aspect2 = %f'%(aspect2))
    ax2.set_aspect(aspect2, adjustable='box', anchor='C')
    fig2.savefig('Plot_Field_COSMOS.pdf')
    #plt.show(block=True)
    
    
    





































