# test.py
import numpy as np
import matplotlib.pyplot as plt
from PIL import Image
import DM3lib as dm3
from utilities import calcHistogram, calcDisplayRange
debug = 1
dm3f = dm3.DM3("test.dm3", debug=debug)
print("file:", dm3f.filename)
print("file info.:")
print(dm3f.info)
print("scale: %.3g %s/px"%dm3f.pxsize)
cuts = dm3f.cuts
print("cuts:",cuts)
# get image data
aa = dm3f.imagedata
plt.matshow(aa, cmap=plt.cm.gray)
plt.title("%s (w/o cuts)" % dm3f.filename)
plt.colorbar(shrink=.8)
plt.show()