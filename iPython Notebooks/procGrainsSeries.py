"""
  procGrainsSeries.py
  
  2013-12-16 J. R. Minter
  
  Process an analySIS image file series of AgX TEM image.
  
  Adapted from http://pythonvision.org/basic-tutorial to python3 and
  using mainly skimage.

  use case from from KGL-31

  
  Note that since the skimage regionprops supplies the bounding
  box, we can just eliminate the features touching the borders.

"""

import os
import glob
import math
import matplotlib.pyplot as plt
import numpy as np
import scipy.ndimage as nd

import skimage.exposure as expo
import skimage.feature as fea       # peak_local_max
import skimage.filter as fil        # rank
import skimage.io as io
import skimage.measure as mea       # regionprops
import skimage.morphology as mor    # watershed, disk

import pymorph as pm

bShowIntermed = True
filtSize = 7
imgRoot = os.environ['IMG_ROOT']
relDir = "/qm-03966-KJL-031-ifs"
fOut = './qm-03966-KJL-031-features.csv'

imgDir = imgRoot + relDir
query = imgDir + "/*.tif"
list = glob.glob(query)
f = open(fOut,'w')
line = "img, label, ecd, minor.ax.len, major.ax.len, ar, solidity"
print(line)
f.write(line+'\n')
f.close()
j = 0

for f in list:
  j += 1
  pts = f.split("\\")
  imgFile = pts[1]
  imgPath = imgDir + "/" + imgFile
  print(imgPath)
  im = io.imread(imgPath)
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
            line = "%g, %g, %g, %g, %g, %g, %g" % (j, i+1, ecd, props[i].minor_axis_length, props[i].major_axis_length, ar, props[i].solidity)
            print(line)
            f.write(line+'\n')
  f.close()
