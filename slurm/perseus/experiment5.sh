#!/bin/bash
#SBATCH -J exp5           # job name
#SBATCH -o exp5.o%j             # output file name (%j expands to jobID)
#SBATCH -e exp5.e%j             # error file name (%j expands to jobID)
#SBATCH -n 512                   # total number of mpi tasks requested
#SBATCH -t 00:300:00             # run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=adrn@princeton.edu
#SBATCH --mail-type=begin       # email me when the job starts
#SBATCH --mail-type=end         # email me when the job finishes

cd /tigress/adrianp/projects/thejoker/scripts/

module load openmpi/gcc/1.10.2/64

source activate thejoker

# Run experiment 5!
python make-experiment5-data.py -s 42

export NSAMPLES="2**28"
export SEED=42

# Run experiment 5, moving data point index=1 through 1 period in 8 steps:
srun python run-sampler.py -v --mpi -o \
-n $NSAMPLES \
-f ../data/experiment5.h5 \
--name="experiment5-0.hdf5" \
--hdf5-key="0" \
--seed=$SEED

srun python run-sampler.py -v --mpi -o \
-n $NSAMPLES \
-f ../data/experiment5.h5 \
--name="experiment5-1.hdf5" \
--hdf5-key="1" \
--seed=$SEED
