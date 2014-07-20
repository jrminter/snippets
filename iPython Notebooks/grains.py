"""
  grains.py
  
  2014-07-20 J. R. Minter
  
  Simple particle analysis of AgX TEM image.
  
  Adapted from http://pythonvision.org/basic-tutorial to python3 and
  using mainly skimage. Updated to use tifffile to read the 16 bit per
  pixel TIF image.

  image from KGL-31

  
  Note that since the skimage regionprops supplies the bounding
  box, we can just eliminate the features touching the borders.
  

"""

import math
import matplotlib.pyplot as plt
import numpy as np
import scipy.ndimage as nd
import tifffile

import skimage.exposure as expo
import skimage.feature as fea       # peak_local_max
import skimage.filter as fil        # rank
import skimage.io as io
import skimage.measure as mea       # regionprops
import skimage.morphology as mor    # watershed, disk

import pymorph as pm

bShowIntermed = False
bShowCur = True
filtSize = 7
fOut = 'features.csv'
# fImg = './grain.png'
fImg = './grains.tif'

tif = tifffile.TiffFile(fImg)

im = tif[0].asarray()
print(im.dtype)
print(im.shape)
imgRows = im.shape[0]
imgCols = im.shape[1]

if bShowIntermed:
  io.imshow(im, cmap=plt.cm.gray)
  plt.show()
  
his = expo.histogram(im, nbins=256)
if bShowIntermed:
  plt.plot(his[1], his[0])
  plt.show()

T = fil.threshold_otsu(im)
print(T)
thr = im < T

if bShowIntermed:
  io.imshow(thr, cmap=plt.cm.gray)
  plt.show()

dis = nd.distance_transform_edt(thr).astype(np.float32)
# denoise the EDM
blur = nd.gaussian_filter(dis, sigma=[filtSize, filtSize])
if bShowIntermed:
  print(blur.shape)
  print(blur.dtype)
  plt.imshow(-blur, cmap=plt.cm.jet, interpolation='nearest')
  plt.show()
  
rmax = fea.peak_local_max(blur, indices=False, footprint=np.ones((3, 3)))

if bShowIntermed:
  plt.imshow(pm.overlay(im, rmax))
  plt.show()


mrk = nd.label(rmax)[0]
lab = mor.watershed(-blur, mrk, mask=thr)
if bShowIntermed:
  io.imshow(lab, cmap=plt.cm.spectral)
  plt.show()

props = mea.regionprops(lab, intensity_image=im, cache=True)

print("")
l = len(props)

f = open(fOut,'w')
line = "label, ecd, minor.ax.len, major.ax.len, ar, solidity"
print(line)
f.write(line+'\n')
for i in range(l):
  # check the labeled regions for border touching
  theBox = props[i].bbox
  if(theBox[0] > 0):
    if(theBox[1] > 0):
      if(theBox[2] < imgRows):
        if(theBox[3] < imgCols):
          ecd = 2.0 * math.sqrt(props[i].area/math.pi)
          ar = props[i].major_axis_length / props[i].minor_axis_length
          line = "%g, %g, %g, %g, %g, %g" % (i+1, ecd, props[i].minor_axis_length, props[i].major_axis_length, ar, props[i].solidity)
          print(line)
          f.write(line+'\n')
          
f.close()

fig, axes = plt.subplots(ncols=3, figsize=(9, 3))
ax0, ax1, ax2 = axes
ax0.imshow(im, cmap=plt.cm.gray, interpolation='nearest')
ax0.set_title('original AgX')
ax1.imshow(-blur, cmap=plt.cm.jet, interpolation='nearest')
ax1.set_title('blurred EDM')
ax2.imshow(lab, cmap=plt.cm.spectral, interpolation='nearest')
ax2.set_title('labeled AgX')
for ax in axes:
  ax.axis('off')
plt.subplots_adjust(hspace=0.01, wspace=0.01, top=1, bottom=0, left=0, right=1)
plt.show()