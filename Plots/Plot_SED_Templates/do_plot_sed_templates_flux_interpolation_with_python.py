#!/usr/bin/env python
# 

import os, sys, re
import numpy as np
from astropy.table import Table
import scipy.interpolate
from scipy.interpolate import LinearNDInterpolator, interp1d
from scipy import ndimage

input_dir = 'Output_v20200207_SFR_grid'

SFR_grid_table = Table.read(input_dir+os.sep+'list_of_SFR_grid.txt', format='ascii')
Wavelength_grid_table = Table.read(input_dir+os.sep+'list_of_wavelength_grid.txt', format='ascii')
Wavelength_grid_table.sort('Wavelength')
redshift_grid = None
flux_array = None

n2 = len(SFR_grid_table)
n1 = len(Wavelength_grid_table)
#n0 = len(redshift_grid)
for i2 in range(n2):
    for i1 in range(n1):
        flux_table_file = input_dir+os.sep+'%s/expected_flux_%s_v1.txt'%(SFR_grid_table['Data_dir'][i2], Wavelength_grid_table['Wavelength_str'][i1])
        flux_table = Table.read(flux_table_file, format='ascii.no_header')
        redshift = flux_table.columns[0].data
        flux_mJy = flux_table.columns[1].data
        if redshift_grid is None:
            redshift_grid = redshift
            n0 = len(redshift_grid)
            flux_array = np.zeros((n2, n1, n0))
        elif len(redshift_grid) != len(redshift):
            raise Exception('Error! The redshift grid in "%s" is different from the others (%s)!'%(flux_table_file, str(redshift_grid)))
        # 
        flux_array[i2, i1, :] = flux_mJy
        # 
        #break
    #break

grid_coordinates_ax2 = np.log10(SFR_grid_table['SFR'].data) # uniform, log10
grid_coordinates_ax1 = np.log10(Wavelength_grid_table['Wavelength'].data) # non-uniform, log10
grid_coordinates_ax0 = np.log10(1.0+redshift_grid) # non-uniform, log10(1+z)
print('grid_coordinates_ax2', grid_coordinates_ax2)
print('grid_coordinates_ax1', 10**grid_coordinates_ax1)
print('grid_coordinates_ax0', 10**grid_coordinates_ax0-1)

print('flux_array.shape', flux_array.shape)


# prepare output grid
output_lgSFR = 10**np.array([-2.0, 0.466]) # input log10 SFR here
output_wavelength = [24., 1160.]
output_redshift = [0.1, 1.8]
output_ax2 = np.log10(output_lgSFR)
output_ax1 = np.log10(output_wavelength)
output_ax0 = np.log10(1.0+np.array(output_redshift))


# interpolation method 1
p_ax1, p_ax2, p_ax0 = np.meshgrid(grid_coordinates_ax1, grid_coordinates_ax2, grid_coordinates_ax0) # from higher dimension (slower moving index) to lower dimension (faster moving index) 
                      # Note: In the case of a 3d mesh-grid, using a sample like the one provided in numpy doc for meshgrib, this would return Z,Y,X instead of X,Y,Z. Replacing the return statement by return tuple(ans[::-1]) -- https://stackoverflow.com/questions/1827489/numpy-meshgrid-in-3d
                      # You can achieve that by changing the order:
                      # y, z, x = np.meshgrid(yy, zz, xx)
if (not np.all(p_ax1[0, :, 0] == grid_coordinates_ax1)) or \
   (not np.all(p_ax2[:, 0, 0] == grid_coordinates_ax2)) or \
   (not np.all(p_ax0[0, 0, :] == grid_coordinates_ax0)) :
    raise Exception('Error! np.meshgrid bug!')
#print(p_ax0.shape)
#print(p_ax1.shape)
#print(p_ax2.shape)
print('p_ax0[13, 6, 10:16]', 10**(p_ax0[13, 6, 10:16])-1) # z
print('p_ax1[13, 6, 10:16]', 10**(p_ax1[13, 6, 10:16])) # wavelength
print('p_ax2[13, 6, 10:16]', p_ax2[13, 6, 10:16]) # lgSFR
print('p_ax2[14, 6, 10:16]', p_ax2[14, 6, 10:16]) # lgSFR
print('flux_array[13, 6, 10:16]', flux_array[13, 6, 10:16])
print('flux_array[14, 6, 10:16]', flux_array[14, 6, 10:16])
p_ax2, p_ax1, p_ax0 = p_ax2.flatten(), p_ax1.flatten(), p_ax0.flatten()
#print(p_ax0[0:10]) # z
#print(p_ax1[0:10]) # wavelength
#print(p_ax2[0:10]) # lgSFR
#print(flux_array[0, 0, 0:10])
#print(flux_array.flatten()[0:10])
points = np.column_stack((p_ax0, p_ax1, p_ax2))
values = np.log10(flux_array).flatten()
spliner = LinearNDInterpolator(points, values)
output_flux = 10**(spliner(np.column_stack((output_ax0, output_ax1, output_ax2))))
print('output_flux', output_flux)

tbout = Table({'points': points, 'values': values})
tbout.write('Output_v20200207_SFR_grid/datatable_Plot_SED_Templates_fluxes_for_interpolation.fits', format='fits', overwrite=True)
with open('Output_v20200207_SFR_grid/datatable_Plot_SED_Templates_fluxes_for_interpolation.readme.txt', 'w') as fp:
    fp.write('ax0 is log10(1+redshift).\n')
    fp.write('ax1 is log10(wavelength) in units of log10(um).\n')
    fp.write('ax2 is log10(SFR) in units of log10(solMass/yr).\n')
    fp.write('values are log10(flux) in units of log10(mJy).\n')
    fp.write('\n')
    fp.write('To interpolated the flux given a redshift, wavelength and SFR:\n')
    fp.write('    import numpy as np\n')
    fp.write('    from astropy.table import Table\n')
    fp.write('    import scipy.interpolate\n')
    fp.write('    from scipy.interpolate import LinearNDInterpolator\n')
    fp.write('    tb = Table.read(\'datatable_Plot_SED_Templates_fluxes_for_interpolation.fits\')\n')
    fp.write('    SFR = ...\n')
    fp.write('    wavelength = ...\n')
    fp.write('    redshift = ...\n')
    fp.write('    output_ax2 = np.log10(SFR)\n')
    fp.write('    output_ax1 = np.log10(wavelength)\n')
    fp.write('    output_ax0 = np.log10(1.0+np.array(redshift))\n')
    fp.write('    spliner = LinearNDInterpolator(tb[\'points\'], tb[\'values\'])\n')
    fp.write('    output_flux = 10**(spliner(np.column_stack((output_ax0, output_ax1, output_ax2))))\n')
    fp.write('\n')
    fp.write('Produced by \"%s\".\n'%(os.path.abspath(__file__)))
    fp.write('\n')
#with open('Output_v20200207_SFR_grid/datatable_Plot_SED_Templates_fluxes_for_interpolation.apply.py', 'w') as fp:
#    
print('Output to "%s"!'%('Output_v20200207_SFR_grid/datatable_Plot_SED_Templates_fluxes_for_interpolation.txt'))
print('Output to "%s"!'%('Output_v20200207_SFR_grid/datatable_Plot_SED_Templates_fluxes_for_interpolation.readme.txt'))


# interpolation method 2
grid_spliner_ax2 = interp1d(grid_coordinates_ax2, 
                            np.arange(len(grid_coordinates_ax2)), 
                            kind='cubic')
grid_spliner_ax1 = interp1d(grid_coordinates_ax1, 
                            np.arange(len(grid_coordinates_ax1)), 
                            kind='cubic')
grid_spliner_ax0 = interp1d(grid_coordinates_ax0, 
                            np.arange(len(grid_coordinates_ax0)), 
                            kind='cubic')
i_ax2 = grid_spliner_ax2(output_ax2)
i_ax1 = grid_spliner_ax1(output_ax1)
i_ax0 = grid_spliner_ax0(output_ax0)
print(grid_coordinates_ax2[np.round(i_ax2).astype(int)], 
      grid_coordinates_ax1[np.round(i_ax1).astype(int)], 
      grid_coordinates_ax0[np.round(i_ax0).astype(int)] )
output_flux = 10**(ndimage.map_coordinates(np.log10(flux_array), (i_ax2, i_ax1, i_ax0), order=3)) # z y x coordinate order, see https://docs.scipy.org/doc/scipy/reference/generated/scipy.ndimage.map_coordinates.html
print('output_flux', output_flux)


