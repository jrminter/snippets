# test.py
import os
import matplotlib.pyplot as plt
import pyDM3reader as dm3
from PIL import Image

homDir = os.environ['HOME']
relDir = "/work/snippets/pyDM3reader"
wd = homDir + relDir
os.chdir(wd)


debug = 1
dm3f = dm3.DM3lib.DM3("test.dm3", debug=debug)
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

if cuts[0] != cuts[1]:
    plt.matshow(aa, cmap=plt.cm.pink, vmin=cuts[0], vmax=cuts[1])
    plt.title("%s" % dm3f.filename)
    plt.colorbar(shrink=.8)
    plt.show()


hh,bb = dm3.utilities.calcHistogram(aa)
plt.figure('Image histogram')
plt.plot(bb[:-1],hh,drawstyle='steps')
plt.xlim(bb[0],bb[-1])
plt.xlabel('Intensity')
plt.ylabel('Number')
plt.show()

tifFil = wd + '/test.tif'
im = Image.fromarray(aa)
im.save(tifFil)


