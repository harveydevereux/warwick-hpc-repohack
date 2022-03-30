#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=7
#SBATCH --cpus-per-task=18
#SBATCH --mem-per-cpu=3850
#SBATCH --time=48:00:00
#SBATCH --account=su107-cpu

module purge
module load GCC/11.2.0 OpenMPI/4.1.1 Bison/3.7.6 flex/2.6.4 Mesa/21.1.7 glew/2.2.0-glx libGLU/9.0.2 FFmpeg/4.3.2
module load GCC/10.2.0 parallel/20210322

# Set number of MPI tasks to use per instance of my_mpi_prog
TASKS_PER_PROG=1

# Set OMP_NUM_THREADS
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# Calculate how many concurrent MPI instances to use
NJOBS=$((${SLURM_NTASKS}/${TASKS_PER_PROG}))
echo "Jobs: ${NJOBS}"
# Parallel should launch NJOBS instances of srun at any one time
MY_PARALLEL_OPTS="-N 1 --delay 10 -j ${NJOBS} --joblog parallel-${SLURM_JOBID}.log"

# Each invocation of srun should launch $TASKS_PER_PROG tasks
MY_SRUN_OPTS="-N 1 -n ${TASKS_PER_PROG} -c ${SLURM_CPUS_PER_TASK} --exclusive"
echo "srun OPTs: ${MY_SRUN_OPTS}"

# Use parallel to launch srun with these options
parallel $MY_PARALLEL_OPTS srun $MY_SRUN_OPTS job.sh ::: {1,2,5,10,20,50,100}

