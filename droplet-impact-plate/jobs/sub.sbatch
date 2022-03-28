#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=3850
#SBATCH --time=00:30:00
#SBATCH --account=su107-cpu

module purge
module load GCC/11.2.0 OpenMPI/4.1.1 Bison/3.7.6 flex/2.6.4 Mesa/21.1.7 glew/2.2.0-glx libGLU/9.0.2 FFmpeg/4.3.2

alpha=2
if [ -d "alpha-$alpha" ]; then
	rm -rf "alpha-$alpha"
fi
mkdir alpha-$alpha
tmpdir=`mktemp -d -p ./alpha-${alpha}`
cd $tmpdir
cp ../../jobfiles/* . # copy all scripts into the tmp directory

srun $MY_SRUN_OPTS ./run_simulation.sh droplet_impact_plate 8
cp droplet_impact_plate ../
# free tmp
rm -rf $tmpdir

