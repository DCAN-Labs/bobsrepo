#!/bin/bash -l
#SBATCH -J BCPJLF
#SBATCH --mem=150gb
#SBATCH --tmp=300gb
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lmoore@umn.edu
#SBATCH -o output_logs/abcd-hcp-pipeline_infant_%A_%a.out
#SBATCH -e output_logs/abcd-hcp-pipeline_infant_%A_%a.err
#SBATCH -A faird
#SBATCH --time=72:00:00
#SBATCH --ntasks=24

#SBATCH -p msismall,ag2tb,agsmall

cd run_files.abcd-hcp-pipeline_infant

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}


# for sbatch params, can also use -c instead of ntasks, either use 16 or 2 CPUS per functional run, whichever is higher