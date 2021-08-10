#sudo apt-get install seqtk

curl https://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz -L -o velvet.tar.gz
tar -xvf velvet.tar.gz
cd velvet_1.2.10
make 'OPENMP=1'
cd ..

ls
git clone https://github.com/mourisl/rcorrector.git
cd rcorrector
make
cd ..

git clone https://github.com/harvardinformatics/TranscriptomeAssemblyTools

curl https://github.com/FelixKrueger/TrimGalore/archive/0.6.0.zip -L -o trimgalore.zip
unzip trimgalore.zip

#sudo apt-get install cutadapt

CURDIR=$(pwd)
VELVET=$CURDIR/velvet_1.2.10
RCORRECTOR=$CURDIR/rcorrector/run_rcorrector.pl
FILTERUNCORR=$CURDIR/TranscriptomeAssemblyTools/FilterUncorrectabledPEfastq.py
TRIMGALORE=$CURDIR/TrimGalore-0.6.0/trim_galore
export PATH=$PATH:$CURDIR/salmon-1.5.2_linux_x86_64/bin
export PATH=$PATH:$CURDIR/trinityrnaseq-v2.12.0

rm assembly.txt
echo "velvet" $($VELVET/velveth | head -n 2 | tail -n 1 | awk '{print $2}') >> assembly.txt
echo "rcorrector" $(perl $RCORRECTOR -version | sed "s/v//" | awk '{print $2}') >> assembly.txt
echo "trimgalore" $($TRIMGALORE -v | grep "version" | sed "s/version//g") >> assembly.txt
echo "cutadapt" $(cutadapt --version) >> assembly.txt
cat assembly.txt
