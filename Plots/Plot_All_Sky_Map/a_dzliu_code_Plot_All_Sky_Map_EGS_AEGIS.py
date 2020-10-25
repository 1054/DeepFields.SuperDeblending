#!/usr/bin/env python3
# 
# sudo port install geos
# pip install --user geos
# pip install --user https://github.com/matplotlib/basemap/archive/master.zip
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
        x, y = m(k, 0)
        plt.text(x, y, '%0.0fh'%(val), path_effects=[ef], ha='center', va='center')
    
    return m










































########
# Main #
########

if __name__ == "__main__":
    
    
    
    #data2 = asciitable.read('datatables/datatable_ID_RA_DEC_GOODSN_FIRmmG.txt')
    #data2_ra = data2['RA']
    #data2_dec = data2['DEC']
    
    
    data = asciitable.read('datatables/datatable_ID_RA_DEC_EGS_IRAC1_21feb08.txt')
    print(data)
    data_ra = data['RA']
    data_dec = data['DEC']
    
    
    
    
    fig = plt.figure(figsize=(10,7))
    ax = fig.add_subplot(1,1,1)
    angle_shift = -90.0
    base_map = get_radec_basemap(angle_shift=angle_shift)
    #density = stats.kde.gaussian_kde((data_ra,data_dec))
    m_ra = np.median(data_ra)
    m_dec = np.median(data_dec)
    xs, ys = base_map(m_ra+angle_shift, m_dec)
    ax.plot(xs, ys, 'o', ms=15)
    ax.annotate('EGS (enlarged)', xy=(0.001, 1.001), color='#000000', ha='left', va='bottom', xycoords=ax.transAxes, zorder=10, fontsize=18, fontweight='bold')
    plt.subplots_adjust(left=0.1, bottom=0.1, right=0.9, top=0.9)
    fig.savefig('Plot_All_Sky_Map_EGS_AEGIS.pdf')
    #plt.show(block=True)
    
    
    
    hdu = fits.open('photos/EGS_Photos/egs_irac_mos_3.6.null.fits.gz')[0]
    wcs = WCS(hdu.header)
    
    fig2 = plt.figure(figsize=(7,6))
    #ax2 = fig2.add_subplot(1,1,1, projection=wcs)
    ax2 = fig2.add_subplot(1,1,1)
    ax2.set_axisbelow(True) # not working
    ax2.grid(color='#333333', ls='dashed', alpha=0.5)
    data_px, data_py = wcs.all_world2pix(data_ra, data_dec, 1) # 3rd arg: origin is the coordinate in the upper left corner of the image. In FITS and Fortran standards, this is 1. In Numpy and C standards this is 0.
    #data2_px, data2_py = wcs.wcs_world2pix(data2_ra, data2_dec, 1) # 3rd arg: origin is the coordinate in the upper left corner of the image. In FITS and Fortran standards, this is 1. In Numpy and C standards this is 0.
    #ax2.plot(data_px, data_py, '.', ms=0.1, c='#1e90ff')
    ax2.plot(data_ra, data_dec, '.', ms=0.1, c='#1e90ff') # if directly plot RA Dec then do not need projection
    #ax2.plot(data2_ra, data2_dec, '.', ms=1.5, c='#ff8d1e')
    ax2.set_xlabel('Right Ascension (J2000)', fontsize=15, fontweight='bold')
    ax2.set_ylabel('Declination (J2000)', fontsize=15, fontweight='bold')
    ax2.xaxis.set_label_coords(0.5, -0.25)
    ax2.yaxis.set_label_coords(-0.25, 0.5)
    ax2.invert_xaxis()
    ax2.annotate('EGS', xy=(0.01, 0.99), color='#000000', ha='left', va='top', xycoords=ax2.transAxes, zorder=10, fontsize=15, fontweight='bold')
    ax2.annotate('Spitzer/IRAC', xy=(0.99, 0.99), color='#1e90ff', ha='right', va='top', xycoords=ax2.transAxes, zorder=10, fontsize=15, fontweight='bold')
    #ax2.annotate('Herschel/PACS+SPIRE', xy=(0.99, 0.94), color='#ff8d1e', ha='right', va='top', xycoords=ax2.transAxes, zorder=10, fontsize=15, fontweight='bold')
    plt.subplots_adjust(left=0.25, bottom=0.15, right=0.95, top=0.95)
    aspect2 = 1 # / np.cos((ax2.get_ylim()[1]+ax2.get_ylim()[0])/2.0/180.0*np.pi)
    print('RA size = %s [arcmin]'%(abs(ax2.get_xlim()[1]-ax2.get_xlim()[0])*60.0))
    print('Dec size = %s [arcmin]'%(abs(ax2.get_ylim()[1]-ax2.get_ylim()[0])*60.0))
    print('aspect2 = %f'%(aspect2))
    ax2.set_aspect(aspect2, adjustable='box', anchor='C')
    fig2.savefig('Plot_Field_EGS_AEGIS.pdf', dpi=300, transparent=False)
    fig2.savefig('Plot_Field_EGS_AEGIS.png', dpi=300, transparent=False)
    #plt.show(block=True)
    
    
    





































