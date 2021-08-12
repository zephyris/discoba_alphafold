rm accessdate.txt
rm list.csv
rm -r fasta
rm -r fastaTidy
mkdir genomeFasta
mkdir fasta
mkdir fastaTidy

#NCBI SAR
CURRENTDATE=$(date)
echo "NCBI SAR accessed $CURRENTDATE" >> accessdate.txt

fetchSRARead() {
  echo "SRA,$2,$1,genome assembly and transdecoder" >> list.csv
  mkdir $2
  cd $2
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
  cd ..
}

buildGenomeTrans() {
  if [ ! -f fasta/$1.fasta ]
  then
    cd $1
    cp ../buildGenome.sh buildGenome.sh
    bash buildGenome.sh
    if [ -s pep.fa ]
    then
      sed "s/>NODE/>$1/g" pep.fa > ../fasta/$1.fasta
      rm *.fq f.fa r.fa
    fi
    cd ..
  fi
}

##Genomes
#PRJNA267749
fetchSRARead SRR1662197 Leishmania_deanei
fetchSRARead SRR1662199 Leishmania_hertigi
fetchSRARead SRR1662200 Leishmania_pifanoi
fetchSRARead SRR1662202 Endotrypanum_schaudinni
fetchSRARead SRR1657911 Leishmania_naiffi

#PRJNA157075
fetchSRARead SRR1185708 Leishmania_sp_LTCP19748

#PRJNA398352
fetchSRARead SRR5973234 Kinetoplastid_LTCP393
fetchSRARead SRR5973232 Kinetoplastid_LH21
fetchSRARead SRR5973231 Kinetoplastid_LTCP15171
fetchSRARead SRR5973230 Kinetoplastid_LVH60
fetchSRARead SRR5973229 Kinetoplastid_LH23
fetchSRARead SRR5973228 Kinetoplastid_LVH60a

#PRJNA543408
fetchSRARead SRR9090237 Trypanosomatidae_sp_Fi-14
fetchSRARead SRR8923841 Trypanosoma_caninum

#PRJNA284532
fetchSRARead SRR2057744 Trypanosoma_cruzi_ATCC_30160
fetchSRARead SRR2057750 Trypanosoma_cruzi_ATCC_30160
fetchSRARead SRR2057802 Trypanosoma_cruzi_ATCC_30160

#PRJNA59941
fetchSRARead SRR547646 Trypanosoma_cruzi_JR_cl4
fetchSRARead SRR547643 Trypanosoma_cruzi_JR_cl4

#PRJNA284534
fetchSRARead SRR2057752 Trypanosoma_cruzi_TRYCC_1522
fetchSRARead SRR2057745 Trypanosoma_cruzi_TRYCC_1522
fetchSRARead SRR2057791 Trypanosoma_cruzi_TRYCC_1522
fetchSRARead SRR2057791 Trypanosoma_cruzi_TRYCC_1522
fetchSRARead SRR2057774 Trypanosoma_cruzi_TRYCC_1522

#PRJNA169675
fetchSRARead SRR831221 Trypanosoma_cruzi_Tula_cl2
fetchSRARead SRR831189 Trypanosoma_cruzi_Tula_cl2

#Do builds
buildGenomeTrans Leishmania_deanei
buildGenomeTrans Leishmania_hertigi
buildGenomeTrans Leishmania_pifanoi
buildGenomeTrans Endotrypanum_schaudinni
buildGenomeTrans Leishmania_naiffi
buildGenomeTrans Leishmania_sp_LTCP19748
buildGenomeTrans Kinetoplastid_LTCP393
buildGenomeTrans Kinetoplastid_LH21
buildGenomeTrans Kinetoplastid_LTCP15171
buildGenomeTrans Kinetoplastid_LVH60
buildGenomeTrans Kinetoplastid_LH23
buildGenomeTrans Kinetoplastid_LVH60a
buildGenomeTrans Trypanosomatidae_sp_Fi-14
buildGenomeTrans Trypanosoma_caninum
buildGenomeTrans Trypanosoma_cruzi_JR_cl4
buildGenomeTrans Trypanosoma_cruzi_TRYCC_1522
buildGenomeTrans Trypanosoma_cruzi_Tula_cl2

##Genomes also with transcriptomic data (ie. duplicate)
fetchSRARead SRR5998381 Diplonema_ambulator
fetchSRARead SRR8636211 Diplonema_japonicum
fetchSRARead SRR5998377 Diplonema_sp_2
fetchSRARead SRR8636212 Lacrimia_lanifica
fetchSRARead SRR5998374 Rhynchopus_euleeides
fetchSRARead SRR8636214 Rhynchopus_humris
fetchSRARead SRR8636216 Sulcionema_specki
fetchSRARead SRR8636213 Artemidia_motanka
fetchSRARead SRR8636215 Namystynia_karyoxenos

#buildGenomeTrans Diplonema_ambulator
#buildGenomeTrans Diplonema_japonicum
#buildGenomeTrans Diplonema_sp_2
#buildGenomeTrans Lacrimia_lanifica
#buildGenomeTrans Rhynchopus_euleeides
#buildGenomeTrans Rhynchopus_humris
#buildGenomeTrans Sulcionema_specki
#buildGenomeTrans Artemidia_motanka
#buildGenomeTrans Namystynia_karyoxenos

##Single cell genomes
singleCellGenome() {
  if [ ! -f fasta/$1 ]
  then
    fetchSRARead $1 $2
    touch $2/useRCorr
    buildGenomeTrans $2
  fi
}

#PRJNA338474
singleCellGenome SRR4022277 Diplonemid_21sb
singleCellGenome SRR4022276 Diplonemid_9sb
singleCellGenome SRR4022275 Diplonemid_4sb
singleCellGenome SRR4022274 Diplonemid_1sb
singleCellGenome SRR4022273 Diplonemid_47
singleCellGenome SRR4022272 Diplonemid_37
singleCellGenome SRR4022272 Diplonemid_27
singleCellGenome SRR4022272 Diplonemid_21
singleCellGenome SRR4022272 Diplonemid_13
singleCellGenome SRR4022268 Diplonemid_3

#PRJNA379597
singleCellGenome SRR10442434 Eutreptiella_87
singleCellGenome SRR10442435 Kinetoplastida_80
singleCellGenome SRR10442437 Diplonemid_94a
singleCellGenome SRR10442438 Euglenozoa_98
singleCellGenome SRR10442439 Diplonema_82
singleCellGenome SRR10442440 Euglenida_90
singleCellGenome SRR10442441 Kinetoplastida_57
singleCellGenome SRR10442446 Euglenozoa_Mix_87
singleCellGenome SRR10442448 Hemistasia_100
singleCellGenome SRR10442451 Euglenozoa_Bodo_97
singleCellGenome SRR10442453 Kinetoplastida_89
singleCellGenome SRR10442455 Diplonema_83
singleCellGenome SRR10442456 Diplonemid_81
singleCellGenome SRR10442459 Neobodo_93
singleCellGenome SRR10442462 Diplonemid_96
singleCellGenome SRR10442466 Diplonemid_94c
singleCellGenome SRR10442467 Diplonemid_94b
singleCellGenome SRR10442468 Kinetoplastida_95
singleCellGenome SRR10442469 Apusozoa1
singleCellGenome SRR10442470 Diplonemida_93
singleCellGenome SRR10442472 Diplonemid_93
singleCellGenome SRR10499212 4B_35A_extra

#NCBI
CURRENTDATE=$(date)
echo "NCBI accessed $CURRENTDATE" >> accessdate.txt

fetchNCBI() {
  echo "NCBI genome,$1,$2,orfs >100bp" >> list.csv
  URL="https://ftp.ncbi.nlm.nih.gov/genomes/all/"${1:0:3}/${1:4:3}/${1:7:3}/${1:10:3}/$1/$1"_genomic.fna.gz"
  echo $URL
  curl $URL -o $2.genome.fasta.gz
  gzip -f -d $2.genome.fasta.gz
  nodejs identifyOrfs.js $2.genome.fasta > $2.fasta
  mv $2.genome.fasta genomeFasta/$2.fasta
  mv $2.fasta fasta/$2.fasta
}

fetchNCBI GCA_019188245.1_ASM1918824v1 Novymonas_esmeraldas
fetchNCBI GCA_000331125.1_PhytSerpensv01 Phytomonas_serpens_9T
fetchNCBI GCA_000482185.1_Ades_1.0 Angomonas_desouzai
fetchNCBI GCA_000482145.1_Scul_1.0 Strigomonas_culicis
fetchNCBI GCA_000482125.1_Sgal_1.0 Strigomonas_galati
fetchNCBI GCA_000482165.1_Sonc_1.0 Strigomonas_oncopelti
fetchNCBI GCA_016642125.1_ASM1664212v1 Trypanosomatidae_sp_JR-2017a
fetchNCBI GCA_000482105.1_Caca_1.0 Crithidia_acanthocephali
fetchNCBI GCA_900240985.1_crithidia-bombi.GDC.2013.v1 Crithidia_bombi
fetchNCBI GCA_900240875.1_crithidia-expoeki.GDC.2015.v1 Crithidia_expoeki
fetchNCBI GCA_002216565.1_ASM221656v1 Crithidia_mellificae
fetchNCBI GCA_000981925.2_Ld_v2 Leishmania_sp_AIIMS-LM-SS-PKDL-LD-974
fetchNCBI GCA_000635995.1_ASM63599v1 Lotmaria_passim
fetchNCBI GCA_000482205.1_Hmus_1.0 Herpetomonas_muscarum
fetchNCBI GCA_014466975.1_ASM1446697v1 Leishmania_chagasi
fetchNCBI GCA_003664525.1_ASM366452v1 Leishmania_guyanensis
fetchNCBI GCA_000981925.2_Ld_v2 Leishmania_sp_AIIMS-LM-SS-PKDL-LD-974
fetchNCBI GCA_003664395.1_CDC_Llain_216-34_v1 Leishmania_lainsoni
fetchNCBI GCA_018683835.1_OSU_Pdea_TCC258_v1 Porcisia_deanei
fetchNCBI GCA_000333855.2_Endotrypanum_monterogeii-LV88-1.0.3 Endotrypanum_monterogeii
