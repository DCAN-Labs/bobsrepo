#!/bin/bash -l
#SBATCH -J ALBmancorr
#SBATCH --mem=60gb
#SBATCH --tmp=100gb
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lmoore@umn.edu
#SBATCH -o output_logs/abcd-hcp-pipeline_infant_%A_%a.out
#SBATCH -e output_logs/abcd-hcp-pipeline_infant_%A_%a.err
#SBATCH -A faird
#SBATCH --time=24:00:00
#SBATCH --ntasks=12
#SBATCH -p ag2tb,aglarge

cd run_files.abcd-hcp-pipeline_infant

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}