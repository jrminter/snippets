# -*- coding: utf-8 -*-
"""
Created on Sat Jul 26 14:44:14 2014

@author: jrminter
"""
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
