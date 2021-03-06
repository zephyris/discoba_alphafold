CPUS=8
MEM=48G
export OMP_NUM_THREADS=$CPUS

CURDIR=$(pwd)
VELVET=$CURDIR/../velvet_1.2.10
RCORRECTOR=$CURDIR/../rcorrector/run_rcorrector.pl
FILTERUNCORR=$CURDIR/../TranscriptomeAssemblyTools/FilterUncorrectabledPEfastq.py
TRIMGALORE=$CURDIR/../TrimGalore-0.6.0/trim_galore

#Extract reads
echo "== Extract & concatenate reads =="
gzip -d *.fastq.gz
#Concatenate to single F/R readsets, taking only first 50 million reads
cat *_1.fastq | head -n 200000000 > F.fq
cat *_2.fastq | head -n 200000000 > R.fq

#Use rcorrector for single cell genomes
echo "== Read correction and trimming =="
if [ -f useRCorr ]
then
  echo "= Using rcorrector ="
  perl $RCORRECTOR -t $CPUS -1 F.fq -2 R.fq
  python $FILTERUNCORR -1 F.cor.fq -2 R.cor.fq -s cor
else
  echo "= Not using rcorrector ="
  mv F.fq unfixrm_F.cor.fq
  mv R.fq unfixrm_R.cor.fq
fi
$TRIMGALORE --paired --retain_unpaired --phred33 --output_dir tgl --length 36 -q 5 --stringency 1 -e 0.1 unfixrm_F.cor.fq unfixrm_R.cor.fq
mv tgl/unfixrm_F.cor_val_1.fq F.cor.fq
mv tgl/unfixrm_R.cor_val_2.fq R.cor.fq
mv tgl/unfixrm_F.cor_unpaired_1.fq U.cor.fq
cat tgl/unfixrm_R.cor_unpaired_2.fq >> U.cor.fq
rm tgl/unfixrm_R.cor_unpaired_2.fq

seqtk seq -A f.cor.fq > f.fa
seqtk seq -A r.cor.fq > r.fa

#Velvet genome assembly
echo "== Assembling genome =="
$VELVET/velveth asm 31 -shortPaired -fasta -separate f.fa r.fa
$VELVET/velvetg asm
$VELVET/velvetg asm -cov_cutoff auto -min_contig_lgth 500

#Velvet genome assembly
echo "== Assembling genome =="
MINCONTIGLENGTH=500
$VELVET/velveth asm 31 -shortPaired -fasta -separate f.fa r.fa
$VELVET/velvetg asm -cov_cutoff auto -min_contig_lgth $MINCONTIGLENGTH
#Align reads to the genome to get key coverage and insert size stats
echo "== Evaluating assembly =="
cp asm/contigs.fa gen.fa
bwa index gen.fa
bwa mem gen.fa f.fa r.fa -t $CPUS | samtools sort -o ali.bam -@ $CPUS -m $MEM
samtools index ali.bam -@ $CPUS
INSERTSIZE=$(samtools stats ali.bam | grep "insert size average" | awk -F'\t' '{print $3}')
MEANCOV=$(samtools depth -a ali.bam | awk '{sum+=$3} END {print sum/NR}')
rm ali*
rm gen.fa*
echo $INSERTSIZE $MEANCOV
THR=$(echo $MEANCOV/4 | bc)
echo $INSERTSIZE $MEANCOV $THR > asmcov.txt
echo "== Improve assembly =="
$VELVET/velvetg asm -cov_cutoff $THR -min_contig_lgth $MINCONTIGLENGTH -exp_cov $MEANCOV -ins_length $INSERTSIZE

#Translate
echo "== Translate transcripts =="
cp asm/contigs.fa gen.fa
nodejs --max_old_space_size=4096 ../identifyOrfs.js gen.fa > pep.fa
