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
mkdir fastaRenamed
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
echo "fasta,count,totalLength,averageLength,proportionStarts,proportionEarlyStops,length25th,length50th,length75th" > stats.csv
cd fasta
for fasta in *.fasta; do
  echo $fasta
  nodejs ../discobaStats.js $fasta >> ../stats.csv
  cut -d " " -f1 $fasta | sed "s/*//g" | sed -e '/^[^>]/s/[^GALMFWKQESPVICYHRNDTgalmfwkqespvicyhrndt]/X/g' > ../discobaTidy/$fasta
done
cd ..


#Report statistics
echo "Database statistics" > stats.txt
echo "===================" >> stats.txt
echo "Last modified:" > stats.txt
stat $(ls -t discoba/*.fasta | head -n 1) | grep "Modify" | awk '{print($2,$3)}' >> stats.txt
echo "Number of species/samples:" >> stats.txt
ls -l discoba/*.fasta | wc -l >> stats.txt
echo "Total number of sequences:" >> stats.txt
awk -F',' '{sum+=$2;}END{print sum;}' stats.csv >> stats.txt
echo "Total length of sequences:" >> stats.txt
awk -F',' '{sum+=$3;}END{print sum;}' stats.csv >> stats.txt

#Rename all fasta entries to sequentially numbered prefixed by isolate name
cd discobaTidy
for fasta in *.fasta; do
  filename=$(basename -- "${fasta}")
  filename="${filename%.*}"
  echo $filename
  awk -v a=$filename '/^>/{print ">"a"_P" ++i; next}{print}' < $fasta > ../discobaRenamed/$fasta
done
cd ..

#Concatenate and compress
cat discobaRenamed/*.fasta > discoba.fasta
gzip -9 -f -k discoba.fasta
