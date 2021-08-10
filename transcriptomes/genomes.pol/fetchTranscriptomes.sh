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
    curl "$i" --keepalive-time 10 -O
  done
}

polishPred() {
  echo "SRA,$1_$3,$2,TriTrypDB transcriptome polish and translate,$3" >> list.csv
  if [ ! -f fasta/$1_$3.fasta ]
  then
    mkdir $1_$3
    cp $1.fasta $1_$3/ref.fa
    cd $1_$3
    pwd
    fetchSRARead $2
    cp ../polishPred.sh polishPred.sh
    bash polishPred.sh
    nodejs ../changedTrans.js ref.fa cds.pol.fa $3 > pep.fa
    if [ -s pep.fa ]
    then
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
fetchTriTrypDB TbruceiTREU927 $KINETOVERSION Trypanosoma_brucei_TREU927
fetchTriTrypDB TevansiSTIB805 $KINETOVERSION Trypanosoma_evansi_STIB805

#Congolense
#PRJEB15251
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898726 ALICK339C6_2
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898728 BANANCL2
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898727 ALME
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898729 BEKA
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898730 CHIPOPELA
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898731 DIND
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898732 DJUMAK1
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898733 EATRO1157C2
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898734 GUTR28X1
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898735 GUTR37K1
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898736 IL1180_ALL
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898737 J4J4K1
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898738 KAPEVE27PC2K1
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898739 KAPEYAK1
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898740 KARAN_ALL
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898741 KASANDAK1
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898742 KONT1-129
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898743 KONT2-133
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898744 KONT2-155
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898745 LOMBO3020
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898746 MALI-1312-95
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898747 MALI25239K1
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898748 MATADI
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898749 MPHITA4028
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898750 MSOROM19K1
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898751 MSOROM7_ALL
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898752 PAUWE73
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898753 PAUWE77X2
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898754 POUSS
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898755 SA267
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898756 SA268
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898757 SA95-3308K1
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898758 TOGO222
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898759 TOGO2264
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898760 TRT1
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898761 TRT12K1
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898762 TRT15
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898763 TRT17C1
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898764 TRT21
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898765 TRT25K1
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898766 TRT37
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898767 TRT38
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898768 TRT42K1
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898769 TRT44K1
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898770 TRT46
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898771 TRT54K1
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898772 TRT573R
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898773 TRT59K1
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898774 TRT5X1
polishPred Trypanosoma_congolense_IL3000-2019 ERR1898775 TRT61

#PRJNA377710
#Gambiense
polishPred Trypanosoma_gambiense_DAL972 SRR5307969 T2_ABBA
#Evansi
polishPred Trypanosoma_evansi_STIB805 SRR5307968 TA_MU09
polishPred Trypanosoma_evansi_STIB805 SRR5307967 TB_MU10

#PRJNA272153
#Gambiense
polishPred Trypanosoma_gambiense_DAL972 SRR1757506 7
polishPred Trypanosoma_gambiense_DAL972 SRR1755080 5

#PRJNA119333 [additional data available]
#Gambiense
polishPred Trypanosoma_gambiense_DAL972 SRR034851 STIB386_BSFC
polishPred Trypanosoma_gambiense_DAL972 SRR034846 STIB386_PCFA

#PRJNA407592
#Rhodesiense
polishPred Trypanosoma_brucei_TREU927 SRR6052131 D3
polishPred Trypanosoma_brucei_TREU927 SRR6052132 D4
polishPred Trypanosoma_brucei_TREU927 SRR6052133 Apendum
polishPred Trypanosoma_brucei_TREU927 SRR6052136 Angwen
polishPred Trypanosoma_brucei_TREU927 SRR6052137 D16
polishPred Trypanosoma_brucei_TREU927 SRR6052138 D2
polishPred Trypanosoma_brucei_TREU927 SRR6052139 D1
polishPred Trypanosoma_brucei_TREU927 SRR6052140 D11
polishPred Trypanosoma_brucei_TREU927 SRR6052142 STIB900
polishPred Trypanosoma_brucei_TREU927 SRR6052143 STIB704C
polishPred Trypanosoma_brucei_TREU927 SRR6052145 ytat
polishPred Trypanosoma_brucei_TREU927 SRR6052146 LWO30A
polishPred Trypanosoma_brucei_TREU927 SRR6052147 Okware
polishPred Trypanosoma_brucei_TREU927 SRR6052148 Dog157
polishPred Trypanosoma_brucei_TREU927 SRR6052149 KeKo
polishPred Trypanosoma_brucei_TREU927 SRR6052150 D5
polishPred Trypanosoma_brucei_TREU927 SRR6052151 D7
polishPred Trypanosoma_brucei_TREU927 SRR6052152 LWO150A
polishPred Trypanosoma_brucei_TREU927 SRR6052153 LWO24A
polishPred Trypanosoma_brucei_TREU927 SRR6052154 LWO07A
polishPred Trypanosoma_brucei_TREU927 SRR6052155 LWO11A


#PRJEB41308 [additional data available]
#Brucei
polishPred Trypanosoma_brucei_TREU927 ERR4833471 MAK98
polishPred Trypanosoma_brucei_TREU927 ERR4833470 MAK65

#PRJEB39256 [additional data available]
#Brucei
polishPred Trypanosoma_brucei_TREU927 ERR4319900 Tb065BAPC
polishPred Trypanosoma_brucei_TREU927 ERR4319904 Tb098AAPC

#PRJNA516558
#Evansi
polishPred Trypanosoma_evansi_STIB805 SRR8476220 4V1M

#PRJNA377640
#Evansi
polishPred Trypanosoma_evansi_STIB805 SRR5307574 RoTat_1-2

#PRJEB2008
#Evansi
polishPred Trypanosoma_evansi_STIB805 ERR005205 STiB805-1

#PRJNA609638
#Vivax
polishPred Trypanosoma_vivax_Y486 SRR11213602 Lins

#PRJNA486085
#Vivax
polishPred Trypanosoma_vivax_Y486 SRR7694637 Tv684
polishPred Trypanosoma_vivax_Y486 SRR7694638 Tv596
polishPred Trypanosoma_vivax_Y486 SRR7694639 Tv493
polishPred Trypanosoma_vivax_Y486 SRR7694640 Tv465
polishPred Trypanosoma_vivax_Y486 SRR7694641 Tv462
polishPred Trypanosoma_vivax_Y486 SRR7694642 Tv3658
polishPred Trypanosoma_vivax_Y486 SRR7694643 Tv3651
polishPred Trypanosoma_vivax_Y486 SRR7694644 Tv3638
polishPred Trypanosoma_vivax_Y486 SRR7694645 TvBobo14
polishPred Trypanosoma_vivax_Y486 SRR7694646 TvBobo09
polishPred Trypanosoma_vivax_Y486 SRR7694647 Tv306
polishPred Trypanosoma_vivax_Y486 SRR7694648 Tv2714
polishPred Trypanosoma_vivax_Y486 SRR7694649 Tv319
polishPred Trypanosoma_vivax_Y486 SRR7694650 Tv3171
polishPred Trypanosoma_vivax_Y486 SRR7694651 Tv1392
polishPred Trypanosoma_vivax_Y486 SRR7694652 Tv11
polishPred Trypanosoma_vivax_Y486 SRR7694653 Tv2323
polishPred Trypanosoma_vivax_Y486 SRR7694654 Tv2005
polishPred Trypanosoma_vivax_Y486 SRR7694655 Tv340
polishPred Trypanosoma_vivax_Y486 SRR7694656 Tv338
polishPred Trypanosoma_vivax_Y486 SRR7694657 TvMi
polishPred Trypanosoma_vivax_Y486 SRR7694658 TvKad
polishPred Trypanosoma_vivax_Y486 SRR7694659 TvMagna
polishPred Trypanosoma_vivax_Y486 SRR7694660 TvGondo
polishPred Trypanosoma_vivax_Y486 SRR7694661 TvILV21
polishPred Trypanosoma_vivax_Y486 SRR7694662 TvBrRP
polishPred Trypanosoma_vivax_Y486 SRR7694663 TvD39
polishPred Trypanosoma_vivax_Y486 SRR7781144 A3P3
polishPred Trypanosoma_vivax_Y486 SRR7781145 A3P2
polishPred Trypanosoma_vivax_Y486 SRR7781146 A3P5
polishPred Trypanosoma_vivax_Y486 SRR7781147 A3P4
polishPred Trypanosoma_vivax_Y486 SRR7781148 A2P6
polishPred Trypanosoma_vivax_Y486 SRR7781149 A2P5
polishPred Trypanosoma_vivax_Y486 SRR7781150 A3P1
polishPred Trypanosoma_vivax_Y486 SRR7781151 A2P7
polishPred Trypanosoma_vivax_Y486 SRR7781152 A4P2
polishPred Trypanosoma_vivax_Y486 SRR7781153 A4P1
polishPred Trypanosoma_vivax_Y486 SRR7781154 A5P8
polishPred Trypanosoma_vivax_Y486 SRR7781155 A5P7
polishPred Trypanosoma_vivax_Y486 SRR7781156 A5P5
polishPred Trypanosoma_vivax_Y486 SRR7781157 A5P6
polishPred Trypanosoma_vivax_Y486 SRR7781158 A4P3
polishPred Trypanosoma_vivax_Y486 SRR7781159 A4P4
polishPred Trypanosoma_vivax_Y486 SRR7781160 A4P5
polishPred Trypanosoma_vivax_Y486 SRR7781161 A4P6
polishPred Trypanosoma_vivax_Y486 SRR7781162 A5P1
polishPred Trypanosoma_vivax_Y486 SRR7781163 A5P2
polishPred Trypanosoma_vivax_Y486 SRR7781164 A5P3
polishPred Trypanosoma_vivax_Y486 SRR7781165 A5P4
polishPred Trypanosoma_vivax_Y486 SRR7781166 A5P9

#PRJNA477427
#Equiperdum
polishPred Trypanosoma_brucei_TREU927 SRR7910035 IVMt1

#PRJNA477427
#PRJNA377640
polishPred Trypanosoma_brucei_TREU927 SRR5307572 TeAp-N-D1
polishPred Trypanosoma_brucei_TREU927 SRR5307573 Dodola_943

#PRJNA477427
#PRJNA377640
polishPred Trypanosoma_brucei_TREU927 SRR5307576 BoTat
