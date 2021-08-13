rm accessdate.txt
rm list.csv
rm -r fastaTidy
mkdir fasta
mkdir fastaTidy

#Download Pilon
curl https://github.com/broadinstitute/pilon/releases/download/v1.24/pilon-1.24.jar -L -o pilon.jar

fetchSRARead() {
  FASTQ=$(curl "https://www.ebi.ac.uk/ena/portal/api/filereport?accession="$1"&result=read_run&fields=fastq_ftp&format=tsv&download=true" | tail -n 1 | cut -d$'\t' -f2- | sed "s/;/ /g")
  echo $FASTQ
  for i in $FASTQ
  do
    echo "$i"
    if [ ! -f $i ]
    then
      curl "$i" -O
    fi
  done
}

polishPred() {
  echo "polish,NCBI SRA,$1_$3,$2,$4,TriTrypDB genome pilon polish and translate" >> list.csv
  if [ ! -f fasta/$1_$3.fasta ]
  then
    mkdir $1_$3
    cp $1.fasta $1_$3/ref.fa
    cd $1_$3
    pwd
    fetchSRARead $2
    if [ -f *_2.fastq.gz ]
    then
      #If reverse reads are present
      cp ../polishPred.sh polishPred.sh
    else
      #Otherwise use unpaired polishing
      cp ../polishPredU.sh polishPred.sh
    fi
    bash polishPred.sh
    nodejs ../changedTrans.js ref.fa cds.pol.fa $3 > pep.fa
    if [ -s pep.fa ]
    then
      #Only continue if pep.fa is not empty
      cp pep.fa ../fasta/$1_$3.fasta
      rm f.fq r.fq ali.bam ali.bam.bai ref.fa*
    fi
    cd ..
  fi
}

fetchTriTrypDB() {
  if [ ! -f $3.fasta ]
  then
    URL="https://tritrypdb.org/common/downloads/release-"$2"/"$1"/fasta/data/TriTrypDB-"$2"_"$1"_AnnotatedCDSs.fasta"
    echo $URL
    curl $URL -o $3.fasta
  fi
}

#TriTrypDB
#Reference transcriptomes for polishing
KINETOVERSION=$(curl https://tritrypdb.org/common/downloads/Current_Release/Build_number)
echo "TriTrypDB version $KINETOVERSION" >> accessdate.txt

fetchTriTrypDB TcongolenseIL3000_2019 $KINETOVERSION Trypanosoma_congolense_IL3000-2019
fetchTriTrypDB TvivaxY486 $KINETOVERSION Trypanosoma_vivax_Y486
fetchTriTrypDB TbruceigambienseDAL972 $KINETOVERSION Trypanosoma_gambiense_DAL972
fetchTriTrypDB TbruceiTREU927 $KINETOVERSION Trypanosoma_brucei_TREU927 #Also used for Trypanosoma equiperdum
fetchTriTrypDB TevansiSTIB805 $KINETOVERSION Trypanosoma_evansi_STIB805

#Congolense
#PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898726 ALICK339C6_2 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898728 BANANCL2 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898727 ALME PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898729 BEKA PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898730 CHIPOPELA PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898731 DIND PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898732 DJUMAK1 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898733 EATRO1157C2 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898734 GUTR28X1 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898735 GUTR37K1 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898736 IL1180_ALL PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898737 J4J4K1 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898738 KAPEVE27PC2K1 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898739 KAPEYAK1 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898740 KARAN_ALL PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898741 KASANDAK1 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898742 KONT1-129 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898743 KONT2-133 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898744 KONT2-155 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898745 LOMBO3020 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898746 MALI-1312-95 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898747 MALI25239K1 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898748 MATADI PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898749 MPHITA4028 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898750 MSOROM19K1 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898751 MSOROM7_ALL PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898752 PAUWE73 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898753 PAUWE77X2 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898754 POUSS PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898755 SA267 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898756 SA268 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898757 SA95-3308K1 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898758 TOGO222 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898759 TOGO2264 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898760 TRT1 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898761 TRT12K1 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898762 TRT15 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898763 TRT17C1 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898764 TRT21 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898765 TRT25K1 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898766 TRT37 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898767 TRT38 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898768 TRT42K1 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898769 TRT44K1 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898770 TRT46 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898771 TRT54K1 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898772 TRT573R PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898773 TRT59K1 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898774 TRT5X1 PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898775 TRT61 PRJEB15251

#PRJNA377710
#Gambiense
polishPred Trypanosoma_gambiense_DAL972 SRR5307969 T2_ABBA PRJNA377710
#Evansi
polishPred Trypanosoma_evansi_STIB805 SRR5307968 TA_MU09 PRJNA377710
polishPred Trypanosoma_evansi_STIB805 SRR5307967 TB_MU10 PRJNA377710

#PRJNA272153
#Gambiense
polishPred Trypanosoma_gambiense_DAL972 SRR1757506 7 PRJNA272153
polishPred Trypanosoma_gambiense_DAL972 SRR1755080 5 PRJNA272153

#PRJNA119333 [additional data available]
#Gambiense
polishPred Trypanosoma_gambiense_DAL972 SRR034851 STIB386_BSFC PRJNA119333
polishPred Trypanosoma_gambiense_DAL972 SRR034846 STIB386_PCFA PRJNA119333

#PRJNA407592
#Rhodesiense
polishPred Trypanosoma_brucei_TREU927 SRR6052131 D3 PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052132 D4 PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052133 Apendum PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052136 Angwen PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052137 D16 PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052138 D2 PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052139 D1 PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052140 D11 PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052142 STIB900 PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052143 STIB704C PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052145 ytat PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052146 LWO30A PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052147 Okware PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052148 Dog157 PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052149 KeKo PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052150 D5 PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052151 D7 PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052152 LWO150A PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052153 LWO24A PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052154 LWO07A PRJNA407592
polishPred Trypanosoma_brucei_TREU927 SRR6052155 LWO11A PRJNA407592


#PRJEB41308 [additional data available]
#Brucei
polishPred Trypanosoma_brucei_TREU927 ERR4833471 MAK98 PRJEB41308
polishPred Trypanosoma_brucei_TREU927 ERR4833470 MAK65 PRJEB41308

#PRJEB39256 [additional data available]
#Brucei
polishPred Trypanosoma_brucei_TREU927 ERR4319900 Tb065BAPC PRJEB39256
polishPred Trypanosoma_brucei_TREU927 ERR4319904 Tb098AAPC PRJEB39256

#PRJNA516558
#Evansi
polishPred Trypanosoma_evansi_STIB805 SRR8476220 4V1M PRJNA516558

#PRJNA377640
#Evansi
polishPred Trypanosoma_evansi_STIB805 SRR5307574 RoTat_1-2 PRJNA377640

#PRJEB2008
#Evansi
polishPred Trypanosoma_evansi_STIB805 ERR005205 STiB805-1 PRJEB2008

#PRJNA609638
#Vivax
polishPred Trypanosoma_vivax_Y486 SRR11213602 Lins PRJNA609638

#PRJNA486085
#Vivax
polishPred Trypanosoma_vivax_Y486 SRR7694637 Tv684 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694638 Tv596 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694639 Tv493 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694640 Tv465 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694641 Tv462 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694642 Tv3658 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694643 Tv3651 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694644 Tv3638 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694645 TvBobo14 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694646 TvBobo09 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694647 Tv306 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694648 Tv2714 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694649 Tv319 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694650 Tv3171 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694651 Tv1392 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694652 Tv11 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694653 Tv2323 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694654 Tv2005 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694655 Tv340 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694656 Tv338 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694657 TvMi PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694658 TvKad PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694659 TvMagna PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694660 TvGondo PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694661 TvILV21 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694662 TvBrRP PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7694663 TvD39 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781144 A3P3 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781145 A3P2 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781146 A3P5 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781147 A3P4 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781148 A2P6 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781149 A2P5 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781150 A3P1 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781151 A2P7 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781152 A4P2 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781153 A4P1 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781154 A5P8 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781155 A5P7 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781156 A5P5 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781157 A5P6 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781158 A4P3 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781159 A4P4 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781160 A4P5 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781161 A4P6 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781162 A5P1 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781163 A5P2 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781164 A5P3 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781165 A5P4 PRJNA486085
polishPred Trypanosoma_vivax_Y486 SRR7781166 A5P9 PRJNA486085

#PRJNA477427
#Equiperdum
polishPred Trypanosoma_brucei_TREU927 SRR7910035 IVMt1 PRJNA477427

#PRJNA377640
polishPred Trypanosoma_brucei_TREU927 SRR5307572 TeAp-N-D1 PRJNA377640
polishPred Trypanosoma_brucei_TREU927 SRR5307573 Dodola_943 PRJNA377640

#PRJNA377640
polishPred Trypanosoma_brucei_TREU927 SRR5307576 BoTat PRJNA377640

#Clean sequences
cd fasta
for fasta in *.fasta; do
  cut -d " " -f1 $fasta | sed "s/*//g" | sed -e '/^[^>]/s/[^GALMFWKQESPVICYHRNDTgalmfwkqespvicyhrndt]/X/g' > ../fastaTidy/$fasta
done
cd ..

cat fastaTidy/*.fasta > variants.fasta
nodejs uniqueTrans.js variants.fasta > variantsUnique.fasta
