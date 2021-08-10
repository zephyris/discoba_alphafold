#sudo apt-get install autoconf
#sudo apt-get install libbz2-dev
#sudo apt-get install liblzma-dev
curl https://github.com/trinityrnaseq/trinityrnaseq/releases/download/v2.12.0/trinityrnaseq-v2.12.0.FULL.tar.gz -L -o trinityrnaseq.tar.gz
tar -xvf trinityrnaseq.tar.gz
cd trinityrnaseq-v2.12.0
make
cd ..
rm trinityrnaseq.tar.gz

curl https://github.com/COMBINE-lab/salmon/releases/download/v1.5.2/salmon-1.5.2_linux_x86_64.tar.gz -L -o salmon.tar.gz
tar -xvf salmon.tar.gz

ls
git clone https://github.com/mourisl/rcorrector.git
cd rcorrector
make
cd ..

git clone https://github.com/harvardinformatics/TranscriptomeAssemblyTools

curl https://github.com/FelixKrueger/TrimGalore/archive/0.6.0.zip -L -o trimgalore.zip
unzip trimgalore.zip

#sudo apt-get install cutadapt
#sudo apt-get install jellyfish
#sudo apt-get install bowtie2

git clone https://github.com/weizhongli/cdhit
cd cdhit
make
cd ..

#sudo apt-get install -y libany-uri-escape-perl
git clone https://github.com/TransDecoder/TransDecoder

CURDIR=$(pwd)
RCORRECTOR=$CURDIR/rcorrector/run_rcorrector.pl
FILTERUNCORR=$CURDIR/TranscriptomeAssemblyTools/FilterUncorrectabledPEfastq.py
TRIMGALORE=$CURDIR/TrimGalore-0.6.0/trim_galore
CDHITEST=$CURDIR/cdhit/cd-hit-est
TRANSDECODER=$CURDIR/TransDecoder/TransDecoder
export PATH=$PATH:$CURDIR/salmon-1.5.2_linux_x86_64/bin
export PATH=$PATH:$CURDIR/trinityrnaseq-v2.12.0

rm assembly.txt
echo "rcorrector" $(perl $RCORRECTOR -version | sed "s/v//" | awk '{print $2}') >> assembly.txt
echo "trimgalore" $($TRIMGALORE -v | grep "version" | sed "s/version//g") >> assembly.txt
echo "cd-hit-est" $($CDHITEST | head -n 1 | awk '{print $4}') >> assembly.txt
echo "transdecoder" $($TRANSDECODER.LongOrfs --version | awk '{print $2}') >> assembly.txt
echo "trinity" $(Trinity --version | grep "Trinity version:" | sed "s/Trinity version: Trinity-v//g") >> assembly.txt
salmon --version >> assembly.txt
jellyfish --version >> assembly.txt
echo "cutadapt" $(cutadapt --version) >> assembly.txt
echo "bowtie2" $(bowtie2 --version | head -n 1 | awk '{print $3}') >> assembly.txt
cat assembly.txt
