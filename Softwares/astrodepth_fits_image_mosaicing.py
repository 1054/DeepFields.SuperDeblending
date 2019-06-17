#!/usr/bin/env python
# 
# Perform fits image mosaicing
# 

import sys, os, re, copy, time, datetime, shutil
import numpy as np
import astropy
import astropy.io.fits as fits
import logging
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')



# 
# check user input
# 
if len(sys.argv) <= 5:
    logging.info("""
    Usage: 
        astrodepth_fits_image_mosaicing.py <Input_template_fits_image> <cut.file.txt> <cut.rect.txt> <cut.buffer.txt> <Output_fits_image_name>
    Notes:
        cut.file.txt should contain one cutout file per line.
        cut.rect.txt should contain the x1 y1 x2 y2 rectangle for each cutout file in cut.file.txt.
        cut.buffer.txt should cotain the buffer size for each cutout file in cut.file.txt.
    """
    )
    sys.exit()


# 
# read user input
# 
InputTemplateImage=sys.argv[1]
CutFileListFile=sys.argv[2]
CutRectListFile=sys.argv[3]
CutBufferListFile=sys.argv[4]
OutputImage=sys.argv[5]
Overwrite=0
StartTime=datetime.datetime.now()


# 
# read cutout rectangles
# 
with open(CutRectListFile) as fp:
    CutRectList = fp.readlines()


# 
# read "CutFileListFile" and check consistency between rect list and file list.
# 
with open(CutFileListFile) as fp:
    CutFileList = fp.readlines()

if len(CutFileList) != len(CutRectList):
    logging.error("Error! The cutout file list from \"%s\" has a different dimension than the cutout rectangle list from \"%s\"! Could not do mosaicing properly! Abort!"%(CutFileListFile, CutRectListFile))
    sys.exit()
CutFileDirPath = os.path.abspath(os.path.dirname(CutFileListFile))


# 
# read buffer list
# 
if os.path.isfile(CutBufferListFile):
    with open(CutBufferListFile) as fp:
        CutBufferList = fp.readlines()
    # 
    # the buffer list file can contain one value for the whole image, or one value for each cutout. here we check the array dimension.
    if len(CutBufferList) == 1:
        CutBufferValue = CutBufferList[0]
        CutBufferList = [CutBufferValue for i in range(len(CutRectList))]
    else:
        if len(CutBufferList) != len(CutRectList):
            logging.error("Error! The cutout buffer list from \"%s\" has a different dimension than the cutout rectangle list from \"%s\"! Could not do mosaicing properly! Abort!"%(CutBufferListFile, CutRectListFile))
            logging.error("len(CutBufferList) = %d"%(len(CutBufferList)))
            logging.error("len(CutRectList) = %d"%(len(CutRectList)))
            sys.exit()
else:
    # if the user has not input any valid buffer file, than report error
    logging.error("Error! The cutout buffer list is not given!")
    sys.exit()
    

# 
# check existing output image
# 
if not OutputImage.endswith(".fits"):
    logging.error("Error! The output fits image file name should end with *.fits!")
    sys.exit()
if os.path.isfile(OutputImage):
    logging.warning("Warning! Found existing output file \"%s\"! Backing it up as \"%s.backup\""%(OutputImage, OutputImage))
    shutil.move(OutputImage, OutputImage+'.backup')
# 
# prepare output directory
OutputDir = os.path.dirname(OutputImage)
if OutputDir != '':
    if not os.path.isdir(OutputDir):
        os.makedirs(OutputDir)



# 
# create blank output image
# 
InputTemplateImageData, InputTemplateImageHeader = fits.getdata(InputTemplateImage, 0, header=True)
OutputImageData = InputTemplateImageData * 0.0
OutputImageHeader = copy.copy(InputTemplateImageHeader)



# 
# make mosaic
# 
for i in range(len(CutRectList)):
    # 
    # read cut file
    CutFile = CutFileList[i].replace('\n','')
    logging.info("Processing \"%s\" (%d/%d)"%(CutFile, i+1, len(CutRectList)))
    # 
    # append prefix file path if it is a relative path rather than an absolute path
    # the file path in the cut.file.txt can be a relative path relative to the directory which stores cut.file.txt.
    if not CutFile.startswith('/'):
        CutFile = CutFileDirPath + os.sep + CutFile
    # 
    # read cutout image data
    CutImageData = fits.getdata(CutFile)
    # 
    # split cut rect into 4 values: x1, y1, x2, y2
    CutRect = [int(t) for t in CutRectList[i].split(' ')]
    #logging.info("CutRect = %s (%d)"%(CutRect, len(CutRect)))
    # 
    # read cut buffer
    CutBuffer = int(CutBufferList[i])
    #logging.info("CutBuffer = %d"%(CutBuffer))
    # 
    # get the coordinates of the non-buffer area of each cutout in the template image
    tx1 = CutRect[0] + CutBuffer # 0-based coordinate
    ty1 = CutRect[1] + CutBuffer # 0-based coordinate
    tx2 = CutRect[2] - CutBuffer # 0-based coordinate
    ty2 = CutRect[3] - CutBuffer # 0-based coordinate
    if ty2 > (OutputImageData.shape[0]-1):
        dy2 = ty2 - (OutputImageData.shape[0]-1)
    else:
        dy2 = 0
    if tx2 > (OutputImageData.shape[1]-1):
        dx2 = tx2 - (OutputImageData.shape[1]-1)
    else:
        dx2 = 0
    ty2 -= dy2
    tx2 -= dx2
    logging.info("Rectangle coordinates in the template image (0-based x1,y1 x2,y2): %d,%d %d,%d"%(tx1, ty1, tx2, ty2))
    # 
    # get the coordinates of the non-buffer area of each cutout in the cutout image
    cx1 = CutBuffer
    cy1 = CutBuffer
    cx2 = tx2 - tx1 + CutBuffer
    cy2 = ty2 - ty1 + CutBuffer
    logging.info("Rectangle coordinates in the cutout image (0-based x1,y1 x2,y2): %d,%d %d,%d"%(cx1, cy1, cx2, cy2))
    # 
    # fill the mosaic image with current cutout fits image
    #logging.debug('OutputImageData.shape = %s, CutImageData.shape = %s'%(OutputImageData.shape, CutImageData.shape))
    OutputImageData[ty1:ty2+1,tx1:tx2+1] += CutImageData[cy1:cy2+1,cx1:cx2+1]
    # 
    # 
    #exit

#OutputImageHeader['']

fits.writeto(OutputImage, OutputImageData, OutputImageHeader)

logging.info("Output to \"%s\"!"%(OutputImage))

FinishingTime = datetime.datetime.now()
ElapsedTime = FinishingTime - StartTime
logging.info("astrodepth_fits_image_mosaicing.py finished at %s %s, elapsed %d.%d seconds."%(FinishingTime.strftime('%Y%m%d %Hh%Mm%Ss'), time.localtime().tm_zone, ElapsedTime.seconds, ElapsedTime.microseconds/1000.))






