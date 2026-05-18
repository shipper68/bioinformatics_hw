#!/bin/bash
#SBATCH --job-name=velvet_improved
#SBATCH --output=logs/velvet_%j.out
#SBATCH --error=logs/velvet_%j.err
#SBATCH --time=04:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=4
#SBATCH -p AMD9554-common

# module load Velvet/1.2.10-GCC-11.2.0

VELVETH="/home/STUDY/FBMF/bioinformatics/soft/velvet/velveth"
VELVETG="/home/STUDY/FBMF/bioinformatics/soft/velvet/velvetg"
R1="/home/STUDY/FBMF/studfbmf02_01/hw4/genome_de_novo/clean_R1.fastq"
R2="/home/STUDY/FBMF/studfbmf02_01/hw4/genome_de_novo/clean_R2.fastq"
BASE_DIR="/home/STUDY/FBMF/studfbmf02_01/hw4/genome_assembly_results/velvet_improved"

mkdir -p "${BASE_DIR}/logs"

INS_LEN=300
MIN_CONTIG=200

# Выбор k-mer в зависимости от поддержки Velvet

if velveth 2>&1 | grep -q "MAXKMERLENGTH"; then
    MAXK=$(velveth 2>&1 | grep "MAXKMERLENGTH" | awk '{print $2}' | cut -d= -f2)
    if [ "$MAXK" -lt 41 ]; then
        echo "Внимание: Velvet скомпилирован с MAXKMERLENGTH=$MAXK. Используем k=11,21,31."
        K_LIST="11 21 31"
    else
        echo "Velvet поддерживает k до $MAXK. Используем k=31,41,51."
        K_LIST="31 41 51"
    fi
else
    # Если не удалось определить, берём безопасные 11,21,31
    K_LIST="11 21 31"
fi

for K in $K_LIST; do
    WORKDIR="${BASE_DIR}/k${K}"
    mkdir -p "$WORKDIR"
    echo "========== Processing k-mer = $K =========="

    $VELVETH "$WORKDIR" $K -fastq -shortPaired $R1 $R2

    $VELVETG "$WORKDIR" \
        -ins_length $INS_LEN \
        -exp_cov auto \
        -cov_cutoff auto \
        -min_contig_lgth $MIN_CONTIG \
        -amos_file yes \
        -read_trkg yes

    echo "========== Finished k=$K, contigs in $WORKDIR/contigs.fa =========="
done

ls -la --time=ctime "${BASE_DIR}"
