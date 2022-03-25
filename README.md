## [HPC ReproHack @ Warwick (March 2022)](https://www.reprohack.org/event/14/Part) reviewing [Droplet impact onto a spring-supported plate: analysis and simulations, Michael J. Negus, 2021](https://www.reprohack.org/paper/67/)

Reviewers: Harvey Devereux (he/him), University of Warwick and Peter Lewin-Jones (he/him), University of Warwick, with mentor Radu Cimpeanu, (he/him), University of Warwick, @rcimpeanu

### ReproHacking

A run of the repo's example "example_ran" as is can be found in this archive, complete with all output and code after running ``` ./run_simulation.sh droplet_impact_plate 8```

https://github.com/harveydevereux/warwick-hpc-repohack/blob/master/example-clean-repo.tar.gz


### Setup

Following the instructions here (http://basilisk.fr/src/INSTALL) and here (http://basilisk.fr/src/gl/INSTALL)

Load modules:

```bash
module purge
module load GCC/11.2.0 OpenMPI/4.1.1 Bison/3.7.6 flex/2.6.4 Mesa/21.1.7 glew/2.2.0-glx libGLU/9.0.2 FFmpeg/4.3.2
```

Get the tarball

```bash
wget http://basilisk.fr/basilisk/basilisk.tar.gz
tar xzf basilisk.tar.gz
```

Install and add paths to .bashrc

```bash
cd basilisk/src
echo "export BASILISK=$PWD" >> ~/.bashrc
echo "export PATH=\$PATH:$BASILISK" >> ~/.bashrc
ln -s config.gcc config
make -k
make
```

Now build software graphics (http://basilisk.fr/src/gl/INSTALL)

```bash
cd $BASILISK/gl
make libglutils.a libfb_osmesa.a
```

Even more important edit the config file, it's important to comment out the lines
```bash
#OPENGLIBS = -lfb_dumb
#CFLAGS += -DDUMBGL
```

and uncomment the line
```bash
OPENGLIBS = -lfb_osmesa -lGLU -lOSMesa
```

Then navigate back to basilisk/src and re-make
```bash
cd $BASILISK/src
make -k && make
```

My ```$BASILISK/src/config``` for reference
```bash
cat ~/basilisk/src/config
# -*-Makefile-*-

# how to launch the C99 compiler
CC99 = $(CC) -std=c99 -pedantic -D_GNU_SOURCE=1 -Wno-unused-result

# how to strip unused code
STRIPFLAGS = -s

# other useful (non-standard) flags
CFLAGS += -g -Wall -pipe -D_FORTIFY_SOURCE=2

# if you have valgrind, otherwise comment this out
VALGRIND = valgrind -q --tool=memcheck --suppressions=$(BASILISK)/openmpi.supp \
	--leak-check=full

# if gnuplot supports pngcairo, otherwise comment this out
PNG = pngcairo

# configuration for python modules (requires swig)
MDFLAGS = -fpic
PYTHONINCLUDE = /usr/include/python2.7

# OpenGL libraries

# This is the "dumb" OpenGL implementation and needs to be replaced by
# one of the implementations below (fb_osmesa or fb_glx) if you want
# to use online visualisation with view.h. In this case, the following
# two lines must be commented out. See [INSTALL#visualisation]() for details.

#OPENGLIBS = -lfb_dumb
#CFLAGS += -DDUMBGL

OPENGLIBS = -lfb_osmesa -lGLU -lOSMesa
# OPENGLIBS = -lfb_glx -lGLU -lGLEW -lGL -lX11

# Compiler and libraries to use with CADNA.
# See [README.cadna]() for more documentation.
CADNACC = clang -D_CADNA=1 -x c++ -m64 \
	-Wno-unused-function \
	-Wno-unused-result \
	-Wno-c++11-compat-deprecated-writable-strings \
	-Wno-address-of-array-temporary
CADNALIBS = -lcadnaC -lstdc++
``` 
