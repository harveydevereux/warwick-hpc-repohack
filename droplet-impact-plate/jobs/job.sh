#!/bin/bash

module load GCC/11.2.0 OpenMPI/4.1.1 Bison/3.7.6 flex/2.6.4 Mesa/21.1.7 glew/2.2.0-glx libGLU/9.0.2 FFmpeg/4.3.2

        alpha=$1 # get the alpha value
        if [ -d "alpha-$alpha" ]; then
                rm -rf "alpha-$alpha"
        fi
        mkdir alpha-$alpha
        mkdir alpha-$alpha/src
        cd alpha-$alpha/src
        #tmpdir=`mktemp -d -p ./alpha-${alpha}`
        cp ../../jobfiles/* . # copy all scripts into the tmp directory
        echo "Job ${alpha} launching in alpha-$alpha/src"
        sed -i "26s/.*/const double ALPHA = $alpha;/" parameters.h 
	./run_simulation.sh droplet_impact_plate 8
        #cp droplet_impact_plate ../

