#!/bin/bash -l
#SBATCH -J BCPXaseg
#SBATCH --mem=60gb
#SBATCH --tmp=100gb
#SBATCH --mail-type=ALL
#SBATCH --mail-user=fayzu001@umn.edu
#SBATCH -o output_logs/abcd-hcp-pipeline_infant_%A_%a.out
#SBATCH -e output_logs/abcd-hcp-pipeline_infant_%A_%a.err
#SBATCH -A feczk001
#SBATCH --time=72:00:00
#SBATCH --ntasks=24

#SBATCH -p msismall,ram256g

cd run_files.abcd-hcp-pipeline_infant

module load singularity
#module load fsl

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}
