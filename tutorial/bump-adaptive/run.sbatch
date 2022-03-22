#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=3850
#SBATCH --time=00:05:00
#SBATCH --account=su107-cpu

module purge
module load foss/2021b flex Bison Mesa glew libGLU/9.0.2 FFmpeg GCCcore/10.3.0 gnuplot/5.4.2
rm bump

qcc -O3 -Wall bump.c -o bump -lm
./bump > out.ppm 2>log
./gnuplot-bump
