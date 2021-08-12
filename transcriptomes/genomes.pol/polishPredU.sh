#For unpaired reads

CPUS=10
MEM=6G

gzip -d *.fastq.gz
mv *.fastq u.fq

PILON="java -Xmx$MEM -jar ../pilon.jar"

#Align reads to genome, sort and index
bwa index ref.fa
bwa mem ref.fa u.fq -t $CPUS | samtools sort -o ali.bam -@ $CPUS -m $MEM
samtools index ali.bam -@ $CPUS

#Use Pilon to generate SNP-corrected reference genome
$PILON --changes --fix snps,indels --genome ref.fa --outdir pi --output cds --frags ali.bam > /dev/null 2>&1
#$PILON --changes --fix snps,indels --genome ref.fa --outdir pi --output cds --frags ali.bam
cp pi/cds.fasta cds.pol.fa
sed -i 's/_pilon//g' cds.pol.fa
