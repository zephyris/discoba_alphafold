CPUS=34
MEM=240G

CURDIR=$(pwd)
RCORRECTOR=$CURDIR/../rcorrector/run_rcorrector.pl
FILTERUNCORR=$CURDIR/../TranscriptomeAssemblyTools/FilterUncorrectabledPEfastq.py
TRIMGALORE=$CURDIR/../TrimGalore-0.6.0/trim_galore
CDHITEST=$CURDIR/../cdhit/cd-hit-est
TRANSDECODER=$CURDIR/../TransDecoder/TransDecoder
export PATH=$PATH:$CURDIR/../salmon-1.5.2_linux_x86_64/bin
export PATH=$PATH:$CURDIR/../trinityrnaseq-v2.12.0

#Extract reads
echo "== Extract & concatenate reads =="
gzip -d *.fastq.gz
#Concatenate to single F/R readsets, taking only first 50 million reads
cat *_1.fastq | head -n 200000000 > F.fq
cat *_2.fastq | head -n 200000000 > R.fq

#Use standard correction, filtering, trimming
echo "== Read correction and trimming =="
perl $RCORRECTOR -t $CPUS -1 F.fq -2 R.fq
python $FILTERUNCORR -1 F.cor.fq -2 R.cor.fq -s cor
$TRIMGALORE --paired --retain_unpaired --phred33 --output_dir tgl --length 36 -q 5 --stringency 1 -e 0.1 unfixrm_F.cor.fq unfixrm_R.cor.fq
mv tgl/unfixrm_F.cor_val_1.fq F.cor.fq
mv tgl/unfixrm_R.cor_val_2.fq R.cor.fq
mv tgl/unfixrm_F.cor_unpaired_1.fq U.cor.fq
cat tgl/unfixrm_R.cor_unpaired_2.fq >> U.cor.fq
rm tgl/unfixrm_R.cor_unpaired_2.fq

#Trial assembly of a subsample of 1 million reads
cat F.cor.fq | head -n 4000000 > F.cor.sub.fq
cat R.cor.fq | head -n 4000000 > R.cor.sub.fq

#Trial Trinity transcriptome assembly
echo "== Transcriptome assembly =="
Trinity --seqType fq --max_memory $MEM --left F.cor.sub.fq  --right R.cor.sub.fq --CPU $CPUS --output trinitySub

#Predict SL from trial assembly
nodejs ../identifySL.js trinitySub/Trinity.fasta > sl.txt

#Trim spliced leader, if found
if [ -s sl.txt ]
then
  SL=$(cat sl.txt | head -n 1)
  SLRC=$(cat sl.txt | head -n 2 | tail -n 1)
  #Cutadapt, minimum length 25 (kmer used by Trinity)
  cutadapt -m 25 -j $CPUS -A $SLRC -G $SL -o F.cor.sl.fq -p R.cor.sl.fq F.cor.fq R.cor.fq
  mv F.cor.sl.fq F.cor.fq
  mv R.cor.sl.fq R.cor.fq
fi

#Full Trinity transcriptome assembly
echo "== Transcriptome assembly =="
Trinity --seqType fq --max_memory $MEM --left F.cor.fq  --right R.cor.fq --CPU $CPUS --output trinity

#Remove similar sequences (default 0.9 identity)
echo "== Remove highly similar transcripts =="
$CDHITEST -i trinity/Trinity.fasta -o trans.nonred.fasta

#Re-predict SL from full assembly
nodejs ../identifySL.js trans.nonred.fasta > sl.full.txt

#Translate
echo "== Translate transcripts =="
$TRANSDECODER.LongOrfs -t trans.nonred.fasta
$TRANSDECODER.Predict -t trans.nonred.fasta
