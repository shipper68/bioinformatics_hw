#!/bin/bash
#SBATCH --job-name=velvet_assembly
#SBATCH --output=logs/velvet_%j.out
#SBATCH --error=logs/velvet_%j.err
#SBATCH --time=02:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH -p AMD9554-common

module load Velvet/1.2.10-GCC-11.2.0

VELVETH="/home/STUDY/FBMF/bioinformatics/soft/velvet/velveth"
VELVETG="/home/STUDY/FBMF/bioinformatics/soft/velvet/velvetg"
R1="/home/STUDY/FBMF/studfbmf02_01/hw4/genome_de_novo/7_S4_L001_R1_001.fastq"
R2="/home/STUDY/FBMF/studfbmf02_01/hw4/genome_de_novo/7_S4_L001_R2_001.fastq"
BASE_DIR="/home/STUDY/FBMF/studfbmf02_01/hw4/genome_assembly_results/velvet"
OUT_DIR="${BASE_DIR}/velvet_output"
INS_LEN=300

# Создание директории для логов
mkdir -p $BASE_DIR/logs

# Цикл по k-mer
for k in 11 21 31; do
    echo "========== Processing k-mer = $k =========="
    $VELVETH ${BASE_DIR}/results/k${k} $k -fastq -shortPaired $R1 $R2
    $VELVETG ${BASE_DIR}/results/k${k} -ins_length $INS_LEN -exp_cov auto -cov_cutoff auto
    echo "========== Finished k-mer = $k =========="
done

ls -la --time=ctime "${OUT_DIR}"
