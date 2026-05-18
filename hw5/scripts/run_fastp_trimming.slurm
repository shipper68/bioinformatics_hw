#!/bin/bash
#SBATCH --job-name=fastp_trim
#SBATCH --output=logs/fastp_trim_%j.out
#SBATCH --error=logs/fastp_trim_%j.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH -p AMD9554-common

CONDA_BASE=/home/STUDY/FBMF/bioinformatics/anaconda3
source $CONDA_BASE/etc/profile.d/conda.sh || { echo "Conda path not found"; exit 1; }
conda activate bioinfo_env

export PATH="$CONDA_BASE/envs/bioinfo_env/bin:$PATH"

cd ~/hw5/data/raw_fastq || exit 1
mkdir -p ~/results/fastp_reports

for fastq_file in *.fastq.gz; do
    
    base_name=$(basename "$fastq_file" .fastq.gz)
    
    fastp -i "$fastq_file" \
          -o ~/hw5/data/trimmed_fastq/"${base_name}_trimmed.fastq.gz" \
          --detect_adapter_for_pe \
          --cut_right \
	  --cut_window_size 5 \
          --cut_mean_quality 20 \
          --length_required 36 \
          --thread $SLURM_CPUS_PER_TASK \
          --html ~/results/fastp_reports/"${base_name}_fastp_report.html" \
          --json ~/results/fastp_reports/"${base_name}_fastp_report.json"
done
