#!/bin/bash
#SBATCH -J exp2           # job name
#SBATCH -o exp2.o%j             # output file name (%j expands to jobID)
#SBATCH -e exp2.e%j             # error file name (%j expands to jobID)
#SBATCH -n 256                   # total number of mpi tasks requested
#SBATCH -t 01:45:00             # run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=adrn@princeton.edu
#SBATCH --mail-type=begin       # email me when the job starts
#SBATCH --mail-type=end         # email me when the job finishes

cd /tigress/adrianp/projects/thejoker/scripts/

module load openmpi/gcc/1.10.2/64

source activate thejoker

python make-experiment2-data.py -s 42

# Run experiment 2, dropping data points in batches of 4
srun python run-sampler.py -v --mpi -o \
-n 2**27 \
-f ../data/experiment2.h5 \
--hdf5-key="0"

srun python run-sampler.py -v --mpi -o \
-n 2**27 \
-f ../data/experiment2.h5 \
--hdf5-key="4"

srun python run-sampler.py -v --mpi -o \
-n 2**27 \
-f ../data/experiment2.h5 \
--hdf5-key="8"

srun python run-sampler.py -v --mpi -o \
-n 2**27 \
-f ../data/experiment2.h5 \
--hdf5-key="12"

srun python run-sampler.py -v --mpi -o \
-n 2**27 \
-f ../data/experiment2.h5 \
--hdf5-key="16"

srun python run-sampler.py -v --mpi -o \
-n 2**27 \
-f ../data/experiment2.h5 \
--hdf5-key="20"

srun python run-sampler.py -v --mpi -o \
-n 2**27 \
-f ../data/experiment2.h5 \
--hdf5-key="24"

srun python run-sampler.py -v --mpi -o \
-n 2**27 \
-f ../data/experiment2.h5 \
--hdf5-key="28"