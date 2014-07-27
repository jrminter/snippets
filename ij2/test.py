# import ij.IJ as IJ
import ij.IJ as IJ
import ij.io as io
import ij.process as process
import ij.plugin.filter as filt

blobs = IJ.openImage("/Users/jrminter/dat/images/test/ij/blobs.png")
imp = blobs.createImagePlus()


ip = blobs.getProcessor().duplicate()
imp.setProcessor("blobs copy", ip)
# 2 - Apply a threshold: only zeros and ones
# Set the desired threshold range: keep from 0 to 74
ip.setThreshold(147, 147, process.ImageProcessor.NO_LUT_UPDATE)
# Call the Thresholder to convert the image to a mask
IJ.run(imp, "Convert to Mask", "")
imp.show()


# 3 - Apply watershed
# Create and run new EDM object, which is an Euclidean Distance Map (EDM)
# and run the watershed on the ImageProcessor:
a = filt.EDM()
ip=imp.getProcessor()
a.toWatershed(ip)