#!/bin/bash
#SBATCH --job-name=fastqc_trim
#SBATCH --output=logs/fastqc_trim_%j.out
#SBATCH --error=logs/fastqc_trim_%j.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --export=NONE
#SBATCH -p AMD9554-common

CONDA_BASE=$(conda info --base)
source $CONDA_BASE/etc/profile.d/conda.sh
conda activate bioinfo_env

cd ~/hw5/data/trimmed_fastq || exit 1
fastqc *.fastq.gz -t $SLURM_CPUS_PER_TASK -o ~/hw5/results/fastqc_trimmed
multiqc ~/hw5/results/fastqc_trimmed -o ~/hw5/results/fastqc_trimmed
