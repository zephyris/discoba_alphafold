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
#Concatenate to single F/R readsets
cat *_1.fastq > F.fq
cat *_2.fastq > R.fq

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

#Translate
echo "== Translate transcripts =="
cp asm/contigs.fa gen.fa
nodejs ../identifyOrfs.js gen.fa > pep.fa
