from distutils.core import setup
from Cython.Build import cythonize
import glob

#
print 'Named with wildcard:'


for name in glob.glob('application/*/*.pyx'):
    setup(
    ext_modules = cythonize(name)
)

for name in glob.glob('*.pyx'):
	if name != "setup.py":
		setup(
		ext_modules = cythonize(name)
	)


