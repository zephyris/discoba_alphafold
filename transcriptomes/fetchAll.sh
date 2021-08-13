#DNA: Genomes, genome assembly and ORF finding
cd genomes
bash installGenomeBuilding.sh
bash fetchTranscriptomes.sh
cd ..

#Proteins: Genome-predicted, transcriptomes, transcriptomes assembly and translation
cd transcriptomes
bash installTranscriptomeBuilding.sh
bash fetchTranscriptomes.sh
cd ..

#Proteins: As above, but for single cell data
cd transcriptomes.sc
cp transcriptomes/identifySL.js transcriptomes.sc/
cp transcriptomes/installTranscriptomeBuilding.sh transcriptomes.sc/
bash installTranscriptomeBuilding.sh
bash fetchTranscriptomes.sh
cd ..

#DNA: Strain variants by polishing transcripts
cd genomes.pol
bash fetchTranscriptomes.sh
cd ..

#Collate fasta
mkdir fasta
mkdir fastaTidy
cp genomes/fasta/*.fasta fasta/
cp transcriptomes/fasta/*.fasta fasta/
cp transcriptomes.sc/fasta/*.fasta fasta/

#Collate sources
echo "type,database,predicted transcriptome name,database accession,bioproject accession,protein sequence gather strategy" > list.csv
cat genomes/list.csv >> list.csv
cat transcriptomes/list.csv >> list.csv
cat transcriptomes.sc/list.csv >> list.csv
cat genomes.pol/list.csv >> list.csv

#Clean sequences
cd fasta
for fasta in *.fasta; do
  cut -d " " -f1 $fasta | sed "s/*//g" | sed -e '/^[^>]/s/[^GALMFWKQESPVICYHRNDTgalmfwkqespvicyhrndt]/X/g' > ../fastaTidy/$fasta
done
cd ..

#Concatenate and compress
cat fastaTidy/*.fasta > discoba.fasta
gzip -f -k -9 discoba.fasta
