# setup.py
# Usage: ``python setup.py build_ext --inplace``
# this is a simple setup for Gristoph Gholke's tifffile module
from distutils.core import setup, Extension
import numpy
setup(name='_tifffile', ext_modules=[Extension('_tifffile', ['tifffile.c'], include_dirs=[numpy.get_include()])])
