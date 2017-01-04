#!/usr/bin/env python2.7
# 

import pprint
import numpy
import astropy
from astropy.io import fits

FitsPtr = fits.open('GOODS_N_IRAC_priors_all_20161229_dzliu_FitsTable.fits')
TableColumns = FitsPtr[1].columns
TableData = FitsPtr[1].data

print(TableColumns)
pprint.pprint(numpy.column_stack((TableData['_id'],TableData['_ra'],TableData['_de'])))


Array_z = TableData['zp_X']
Array_f24_2016 = TableData['f24']
Array_df24_2016 = TableData['df24']
Array_radio_2016 = TableData['radio_2016']
Array_eradio_2016 = TableData['eradio_2016']
Array_source_radio_2016 = TableData['source_radio_2016']
Array_SNR_radio_2016 = Array_radio_2016/Array_eradio_2016

Count_Owen_SNR_GE_3 = 0
Count_Radio_SNR_GE_3 = 0
Count_24um_SNR_GE_3 = 0
Count_Radio_SNR_GE_3_24um_SNR_LT_3 = 0
Count_Radio_SNR_GE_2p5 = 0
Count_Radio_SNR_GE_2p5_24um_SNR_LT_3 = 0

for i in range(len(Array_SNR_radio_2016)):
	if(Array_radio_2016[i] > 0.0 and Array_eradio_2016[i] > 0.0):
		if(Array_radio_2016[i]/Array_eradio_2016[i] >= 3.0):
			Count_Radio_SNR_GE_3 += 1
			if(Array_source_radio_2016[i] == 'Owen'):
				Count_Owen_SNR_GE_3 += 1
			if(Array_f24_2016[i] > 0.0 and Array_df24_2016[i] > 0.0):
				if(Array_f24_2016[i]/Array_df24_2016[i] < 3.0):
					Count_Radio_SNR_GE_3_24um_SNR_LT_3 += 1
		# S/N>=2.5
		if(Array_radio_2016[i]/Array_eradio_2016[i] >= 2.5):
			Count_Radio_SNR_GE_2p5 += 1
			if(Array_f24_2016[i] > 0.0 and Array_df24_2016[i] > 0.0):
				if(Array_f24_2016[i]/Array_df24_2016[i] < 3.0):
					Count_Radio_SNR_GE_2p5_24um_SNR_LT_3 += 1
	if(Array_f24_2016[i] > 0.0 and Array_df24_2016[i] > 0.0):
		if(Array_f24_2016[i]/Array_df24_2016[i] >= 3.0):
			Count_24um_SNR_GE_3 += 1


print("Count_Radio_SNR_GE_3 = %d"%Count_Radio_SNR_GE_3)
print("Count_Owen_SNR_GE_3 = %d"%Count_Owen_SNR_GE_3)
print("Count_24um_SNR_GE_3 = %d"%Count_24um_SNR_GE_3)
print("Count_Radio_SNR_GE_3_24um_SNR_LT_3 = %d"%Count_Radio_SNR_GE_3_24um_SNR_LT_3)
print("Count_Radio_SNR_GE_2p5 = %d"%Count_Radio_SNR_GE_2p5)
print("Count_Radio_SNR_GE_2p5_24um_SNR_LT_3 = %d"%Count_Radio_SNR_GE_2p5_24um_SNR_LT_3)


