"""
  procGrainsSeriesDM3.py
  
  2014-07-26 J. R. Minter
  
  Process a directory of DigitalMicrograph .dm3 image files of 
  clumped AgX grains and measure the separated grains.
  
  Adapted from http://pythonvision.org/basic-tutorial to python3 and
  using mainly skimage, scipy, numpy, and pyDM3reader. One advantage of
  this approach is that the code reads the scale factor from the image
  file.

  use case from from KGL-31. Images originally recorded 2013-11-05
  on the FEI CM20UT S/N D692 at 16,500X with the CCD camera binned by 2.

  
  Note that since the skimage regionprops supplies the bounding
  box, we can just eliminate the features touching the borders.

"""

import os
import glob
import math
import matplotlib.pyplot as plt
import numpy as np
import scipy.ndimage as nd
import pyDM3reader as dm3
from PIL import Image

import skimage.exposure as expo
import skimage.feature as fea       # peak_local_max
import skimage.filter as fil        # rank
import skimage.io as io
import skimage.measure as mea       # regionprops
import skimage.morphology as mor    # watershed, disk

import pymorph as pm

bShowIntermed = True
filtSize = 7

homDir = os.environ['HOME']
relDir = "/work/snippets/py3"
wd = homDir + relDir
os.chdir(wd)

imgRoot = os.environ['IMG_ROOT']
relDir = "/test/clumpAgX/qm-03966-KJL-031"
fOut = './qm-03966-KJL-031-features.csv'
debug = 0

imgDir = imgRoot + relDir
query = imgDir + "/*.dm3"
list = glob.glob(query)
f = open(fOut,'w')
line = "img, label, ecd.nm, minor.ax.len.nm, major.ax.len.nm, ar, solidity"
print(line)
f.write(line+'\n')
f.close()
j = 0

for f in list:
  j += 1
  print(f)
  dm3f = dm3.DM3lib.DM3(f, debug=debug)
  lPath = dm3f.filename.split('/')
  l = len(lPath)
  imgName = lPath[l-1].split('.')[0]
  print(" name: %s" % imgName )
  nmPerPx = dm3f.pxsize[0]
  print("scale: %.3f nm/px" % nmPerPx)
  # get image data
  im = dm3f.imagedata
  print(im.shape)
  imgRows = im.shape[0]
  imgCols = im.shape[1]
  T = fil.threshold_otsu(im)
  thr = im < T
  dis = nd.distance_transform_edt(thr).astype(np.float32)
  blur = nd.gaussian_filter(dis, sigma=[filtSize, filtSize])
  rmax = fea.peak_local_max(blur, indices=False, footprint=np.ones((3, 3)))
  mrk = nd.label(rmax)[0]
  lab = mor.watershed(-blur, mrk, mask=thr)
  if bShowIntermed:
    io.imshow(lab, cmap=plt.cm.spectral)
    plt.show()
  props = mea.regionprops(lab, intensity_image=im, cache=True)
  l = len(props)
  f = open(fOut,'a')
  for i in range(l):
    # check the labeled regions for border touching
    theBox = props[i].bbox
    if(theBox[0] > 0):
      if(theBox[1] > 0):
        if(theBox[2] < imgRows):
          if(theBox[3] < imgCols):
            ecd = 2.0 * math.sqrt(props[i].area/math.pi)
            ar = props[i].major_axis_length / props[i].minor_axis_length
            line = "%g, %g, %g, %g, %g, %g, %g" % (j, i+1, ecd*nmPerPx, props[i].minor_axis_length*nmPerPx, props[i].major_axis_length*nmPerPx, ar, props[i].solidity)
            print(line)
            f.write(line+'\n')
  f.close()

