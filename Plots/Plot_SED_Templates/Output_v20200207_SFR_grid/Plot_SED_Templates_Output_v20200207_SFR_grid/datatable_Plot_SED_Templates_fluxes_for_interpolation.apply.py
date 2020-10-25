#!/usr/bin/env python
# 
import os, sys, re
import numpy as np
from astropy.table import Table
import scipy.interpolate
from scipy.interpolate import LinearNDInterpolator
import argparse

def calc_SED_template_flux(z, SFR, wavelength):
    tb = Table.read(os.path.abspath(os.path.dirname(__file__))+os.sep+'datatable_Plot_SED_Templates_fluxes_for_interpolation.fits')
    output_ax2 = np.log10(SFR)
    output_ax1 = np.log10(wavelength)
    output_ax0 = np.log10(1.0+np.array(z))
    spliner = LinearNDInterpolator(tb['points'], tb['values'])
    output_flux = 10**(spliner(np.column_stack((output_ax0, output_ax1, output_ax2))))
    return output_flux



parser = argparse.ArgumentParser(description='Calculates SED template flux for a given redshift, star formation rate and wavelength.')

#parser.add_argument('-z', dest='redshift', required=True, type=float, 
#                    help='Input a redshift.')
#
#parser.add_argument('-SFR', dest='SFR', required=True, type=float, 
#                    help='Input a star formation rate in units of solar mass per year.')
#
#parser.add_argument('-w', '-wavelength', dest='wavelength', required=True, type=float, 
#                    help='Input a wavelength in units of micron meter.')

parser.add_argument('redshift', type=float, 
                    help='Input a redshift.')

parser.add_argument('SFR', type=float, 
                    help='Input a star formation rate in units of solar mass per year.')

parser.add_argument('wavelength', type=float, 
                    help='Input a wavelength in units of micron meter.')

args = parser.parse_args()

output_flux = calc_SED_template_flux(args.redshift, args.SFR, args.wavelength)
print('input_redshift = %s'%(args.redshift))
print('input_SFR = %s'%(args.SFR))
print('input_wavelength = %s'%(args.wavelength))
print('output_flux = %s'%(output_flux))

