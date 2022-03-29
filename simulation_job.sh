#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --mem=15G
#SBATCH --cpus-per-task=24
#SBATCH --output=simulation_output.out

module load matlab

srun matlab_multithread -nodisplay -r vectorized
