rm accessdate.txt
rm list.csv
echo "type,ID,species" > list.csv
rm -r fastaTidy
mkdir fasta
mkdir fastaTidy

fetchSRARead() {
  echo "SRA,$2,$1,transcriptome assembly and transdecoder" >> list.csv
  mkdir $2
  cd $2
  FASTQ=$(curl "https://www.ebi.ac.uk/ena/portal/api/filereport?accession="$1"&result=read_run&fields=fastq_ftp&format=tsv&download=true" | tail -n 1 | cut -d$'\t' -f2- | sed "s/;/ /g")
  echo $FASTQ
  for i in $FASTQ
  do
    echo "$i"
    curl "$i" -O
  done
  cd ..
}

buildTrans() {
  cd $1
  cp ../buildTranscriptome.sh buildTranscriptome.sh
  bash buildTranscriptome.sh
  cp trans.nonred.fasta.transdecoder.pep ../fasta/$1.fasta
  rm *.fastq *.fq
  cd ..
}

#10.1186/s12915-020-0754-1
#PRJNA549754 Prokinetoplastina
fetchSRARead SRR9613186 Prokinetoplastina_PhM-4
fetchSRARead SRR9613187 Prokinetoplastina_PhF-6
#PRJNA550027 Rhynchopus humris
fetchSRARead SRR9588121 Rhynchopus_humris
fetchSRARead SRR9588122 Rhynchopus_humris
fetchSRARead SRR9588122 Rhynchopus_humris
#PRJNA550027 Sulcionema specki
fetchSRARead SRR9334250 Sulcionema_specki
fetchSRARead SRR9334251 Sulcionema_specki

#10.1266/ggs.16-00056
#PRJNA344936 Azumiobodo hoyamushi
fetchSRARead SRR10586159 Azumiobodo_hoyamushi

#PRJNA525750
fetchSRARead SRR8676451 Namystynia_karyoxenos
fetchSRARead SRR8676452 Lacrimia_lanifica
fetchSRARead SRR8676453 Diplonema_japonicum
fetchSRARead SRR8676455 Artemidia_motanka

#PRJNA392339
fetchSRARead SRR5998375 Diplonema_sp.2
fetchSRARead SRR5998378 Diplonema_ambulator
fetchSRARead SRR5998379 Diplonema_ambulator
fetchSRARead SRR5998383 Rhynchopus_euleeides

#PRJEB30797
fetchSRARead ERR3764909 Willaertia_magna

#PRJNA681813
fetchSRARead SRR13174014 Novymonas_esmeraldas

#PRJEB15491
fetchSRARead ERR1655129 Phytomonas_francai
fetchSRARead ERR1655128 Phytomonas_francai

#PRJNA675748
fetchSRARead SRR13015660 Vickermania_ingenoplastis_CP021

#SAMN06163843
fetchSRARead SRR5120186 Trypanosoma_carassii

#PRJNA680239
#fetchSRARead SRR13125478 Porcisia_hertigi

#PRJNA680237
fetchSRARead SRR13125062 Porcisia_deanei

#PRJNA611063
fetchSRARead SRR11278472 Crithidia_thermophila
fetchSRARead SRR11278473 Crithidia_thermophila
fetchSRARead SRR11278474 Crithidia_thermophila

buildTrans Prokinetoplastina_PhF-6
buildTrans Prokinetoplastina_PhM-4
buildTrans Rhynchopus_humris
buildTrans Sulcionema_specki
buildTrans Azumiobodo_hoyamushi
buildTrans Namystynia_karyoxenos
buildTrans Lacrimia_lanifica
buildTrans Diplonema_japonicum
buildTrans Artemidia_motanka
buildTrans Diplonema_sp.2
buildTrans Diplonema_ambulator
buildTrans Rhynchopus_euleeides
buildTrans Willaertia_magna
buildTrans Novymonas_esmeraldas
buildTrans Phytomonas_francai
buildTrans Vickermania_ingenoplastis_CP021
buildTrans Trypanosoma_carassii
#buildTrans Porcisia_hertigi
buildTrans Porcisia_deanei
buildTrans Crithidia_thermophila

#Mixed cultures/metagenomes
#PRJNA297797
fetchSRARead SRR2566811 Andalucia_incarcerata

#PRJNA549687
fetchSRARead SRR9328295 Neovahlkampfia_damariscottae
fetchSRARead SRR9328296 Neovahlkampfia_damariscottae

#PRJNA549754
fetchSRARead SRR13394430 Ankaliazontas_spiralis_PhF-5__Parabodo_caudatus

buildTrans Andalucia_incarcerata
buildTrans Neovahlkampfia_damariscottae
buildTrans Ankaliazontas_spiralis_PhF-5__Parabodo_caudatus

#DDBJ Transcriptome Shotgun Assembly Sequence Database
CURRENTDATE=$(date)
echo "DDBJ accessed $CURRENTDATE" >> accessdate.txt
curl http://www.goeker.org/mg/scripts/gbk2fas.sed -o gbk2fas.sed

#sudo apt-get install -y libany-uri-escape-perl
#git clone https://github.com/TransDecoder/TransDecoder

fetchDDBJ() {
  echo "DDBJ transcriptome,$1,$2,transdecoder" >> list.csv
  curl ftp://ftp.ddbj.nig.ac.jp/ddbj_database/tsa/${1:0:2}/$1.gz -o $2.gz
  gzip -d $2.gz
  ./gbk2fas.sed $2 > $2.fasta
  TransDecoder/TransDecoder.LongOrfs -t $2.fasta
  TransDecoder/TransDecoder.Predict -t $2.fasta
  mv $2.fasta.transdecoder.pep fasta/$2.fasta
  rm -r $2.fasta.*
  rm $2 $2.fasta
  rm pipeliner.*
}

fetchDDBJ GHOA Hemistasia_phaeocysticola #PRJNA549599
fetchDDBJ GHOB Trypanoplasma_borreli #Tt-JH PRJNA549827
fetchDDBJ GJGC Rhabdomonas_costata #PRJNA550357
fetchDDBJ GFCF Trypanoplasma_borreli #PRJNA354696
fetchDDBJ GDJR Euglena_gracilis #PRJNA289402
fetchDDBJ GGOE Euglena_longa #PRJNA471257
fetchDDBJ GECH Pharyngomonas_kirbyi #PRJNA301448
fetchDDBJ HBGD Percolomonas_cosmopolitus #AE-1 ATCC 50343 PRJEB37117
fetchDDBJ GEFR Euglena_gracilis_2 #PRJNA298469
fetchDDBJ LQMU Euglena_gracilis_var_Bacillaris #PRJNA294935
fetchDDBJ GFCF Trypanoplasma_borreli_DieterSteinhagen #PRJNA354696
fetchDDBJ HBGD Percolomonas_cosmopolitus_WS #PRJEB37117

#MMETSP
#https://zenodo.org/record/257410
CURRENTDATE=$(date)
echo "MMETSP accessed $CURRENTDATE" >> accessdate.txt
curl https://zenodo.org/record/257410/files/mmetsp_dib_trinity2.2.0_pep_zenodo.tar.gz -o mmetsp.tar.gz
tar -xvf mmetsp.tar.gz

fetchMMETSP() {
  echo "MMETSP transcriptome,$1,$2,provided by MMETSP" >> list.csv
  tar -xvf mmetsp.tar.gz mmetsp_transdecoder/$1.trinity_out_2.2.0.Trinity.pep.fasta.tar.gz
  tar -xvf mmetsp_transdecoder/$1.trinity_out_2.2.0.Trinity.pep.fasta.tar.gz
  sed "s/$1-doi:10.5281\/zenodo.249982-//g" -i $1.trinity_out_2.2.0.Trinity.pep.fasta
  mv $1.trinity_out_2.2.0.Trinity.pep.fasta fasta/$2.fasta
}

fetchMMETSP MMETSP1114 Neobodo_designis
fetchMMETSP MMETSP0039 Eutreptiella_gymnastica

#NCBI
CURRENTDATE=$(date)
echo "NCBI accessed $CURRENTDATE" >> accessdate.txt

fetchNCBI() {
  echo "NCBI genome,$1,$2,provided by NCBI" >> list.csv
  URL="https://ftp.ncbi.nlm.nih.gov/genomes/all/"${1:0:3}/${1:4:3}/${1:7:3}/${1:10:3}/$1/$1"_protein.faa.gz"
  echo $URL
  curl $URL -o $2.fasta.gz
  gzip -f -d $2.fasta.gz
  mv $2.fasta fasta/
}

fetchNCBI GCA_001460835.1_BSAL Bodo_saltans #PRJEB10421
fetchNCBI GCA_001235845.1_ASM123584v1 Perkinsela_sp #PRJNA194468
fetchNCBI GCA_008403515.1_ASM840351v1 Naegleria_fowleri #PRJNA541227
fetchNCBI GCF_000004985.1_V1.0 Naegleria_gruberi #PRJNA14010
fetchNCBI GCA_009859145.1_Andalucia_godoyi_V16 Andalucia_godoyi #PRJNA559352
fetchNCBI GCA_003324165.2_Nlova_2.1 Naegleria_lovaniensis #PRJNA445795
fetchNCBI GCA_001235845.1_ASM123584v1 Perkinsela_sp_CCAP-1560-4 #PRJNA194468
fetchNCBI GCF_003719485.1_ASM371948v1 Trypanosoma_conorhini #PRJNA315397
fetchNCBI GCA_000582765.1_AKH_PRJEB1535_v1 Phytomonas_sp_isolate_EM1 #PRJEB1535
fetchNCBI GCA_001457755.2_Trypanosoma_equiperdum_OVI_V2 Trypanosoma_equiperdum #PRJEB11407
fetchNCBI GCA_017916335.1_LU_Lori_1.0 Leishmania_orientalis #PRJNA691532
fetchNCBI GCA_017916325.1_LU_Lmar_1.0 Leishmania_martiniquensis #PRJNA691531
fetchNCBI GCA_017916305.1_LU_Lenr_1.0 Leishmania_enriettii #PRJNA691534
fetchNCBI GCA_017918235.1_LU_Pher_1.0 Porcisia_hertigi #PRJNA691541

#TriTrypDB
KINETOVERSION=$(curl https://tritrypdb.org/common/downloads/Current_Release/Build_number)
echo "TriTrypDB version $KINETOVERSION" >> accessdate.txt

fetchTriTrypDB() {
  echo "TriTrypDB genome,$1,$3,provided by TriTrypDB" >> list.csv
  URL="https://tritrypdb.org/common/downloads/release-"$2"/"$1"/fasta/data/TriTrypDB-"$2"_"$1"_AnnotatedProteins.fasta"
  echo $URL
  curl $URL -o fasta/$3.fasta
}

fetchTriTrypDB TvivaxY486 $KINETOVERSION Trypanosoma_vivax_Y486
fetchTriTrypDB TtheileriEdinburgh $KINETOVERSION Trypanosoma_theileri_Edinburgh
fetchTriTrypDB TrangeliSC58 $KINETOVERSION Trypanosoma_rangeli_SC58
fetchTriTrypDB TgrayiANR4 $KINETOVERSION Trypanosoma_grayi_ANR4
fetchTriTrypDB TevansiSTIB805 $KINETOVERSION Trypanosoma_evansi_STIB805
fetchTriTrypDB TcruziYC6 $KINETOVERSION Trypanosoma_cruzi_YC6
fetchTriTrypDB TcruziTCC $KINETOVERSION Trypanosoma_cruzi_TCC
fetchTriTrypDB TcruziSylvioX10-1 $KINETOVERSION Trypanosoma_cruzi_SylvioX10-1
fetchTriTrypDB TcruziSylvioX10-1-2012 $KINETOVERSION Trypanosoma_cruzi_SylvioX10-1-2012
fetchTriTrypDB TcruzimarinkelleiB7 $KINETOVERSION Trypanosoma_cruzi_MarinkelleiB7
fetchTriTrypDB TcruziDm28c2018 $KINETOVERSION Trypanosoma_cruzi_Dm28c-2018
fetchTriTrypDB TcruziDm28c2017 $KINETOVERSION Trypanosoma_cruzi_Dm28c-2017
fetchTriTrypDB TcruziDm28c2014 $KINETOVERSION Trypanosoma_cruzi_Dm28c-2014
fetchTriTrypDB TcruziCLBrenerNon-Esmeraldo-like $KINETOVERSION Trypanosoma_cruzi_Brener_nonEL
fetchTriTrypDB TcruziCLBrenerEsmeraldo-like $KINETOVERSION Trypanosoma_cruzi_Brener_EL
fetchTriTrypDB TcruziCLBrener $KINETOVERSION Trypanosoma_cruzi_Brener
fetchTriTrypDB TcruziBrazilA4 $KINETOVERSION Trypanosoma_cruzi_BrazilA4
fetchTriTrypDB TcongolenseIL3000_2019 $KINETOVERSION Trypanosoma_congolense_IL3000-2019
fetchTriTrypDB TcongolenseIL3000 $KINETOVERSION Trypanosoma_congolense_IL3000
fetchTriTrypDB TbruceiTREU927 $KINETOVERSION Trypanosoma_brucei_TREU927
fetchTriTrypDB TbruceiLister427_2018 $KINETOVERSION Trypanosoma_brucei_Lister427-2018
fetchTriTrypDB TbruceigambienseDAL972 $KINETOVERSION Trypanosoma_gambiense_DAL972
fetchTriTrypDB PconfusumCUL13 $KINETOVERSION Paratrypanosoma_confusum_CUL13
fetchTriTrypDB LturanicaLEM423 $KINETOVERSION Leishmania_turanica_LEM423
fetchTriTrypDB LtropicaL590 $KINETOVERSION Leishmania_tropica_L590
fetchTriTrypDB LtarentolaeParrotTarII $KINETOVERSION Leishmania_tarentolae_ParrotTarlII
fetchTriTrypDB LspMARLEM2494 $KINETOVERSION Leishmania_sp_MARLEM2494
fetchTriTrypDB LseymouriATCC30220 $KINETOVERSION Leptomonas_seymouri_ATCC30220
fetchTriTrypDB LpyrrhocorisH10 $KINETOVERSION Leptomonas_pyrrhocoris_H10
fetchTriTrypDB LpanamensisMHOMPA94PSC1 $KINETOVERSION Leishmania_panamensis_MHOMPA94PSC1
fetchTriTrypDB LpanamensisMHOMCOL81L13 $KINETOVERSION Leishmania_panamensis_MHOMCOL81L13
fetchTriTrypDB LmexicanaMHOMGT2001U1103 $KINETOVERSION Leishmania_mexicana_MHOMGT2001U1103
fetchTriTrypDB LmajorSD75.1 $KINETOVERSION Leishmania_majorSD75-1
fetchTriTrypDB LmajorLV39c5 $KINETOVERSION Leishmania_major_LV39c5
fetchTriTrypDB LmajorFriedlin $KINETOVERSION Leishmania_major_Friedlin
fetchTriTrypDB LinfantumJPCM5 $KINETOVERSION Leishmania_infantum_JPCM5
fetchTriTrypDB LgerbilliLEM452 $KINETOVERSION Leishmania_gerbilli_LEM452
fetchTriTrypDB LenriettiiLEM3045 $KINETOVERSION Leishmania_enriettii_LEM3045
fetchTriTrypDB LdonovaniCL-SL $KINETOVERSION Leishmania_donovani_CL-SL
fetchTriTrypDB LdonovaniBPK282A1 $KINETOVERSION Leishmania_donovani_BPK282A1
fetchTriTrypDB LbraziliensisMHOMBR75M2904_2019 $KINETOVERSION Leishmania_braziliensis_MHOMBR75M2904-2019
fetchTriTrypDB LbraziliensisMHOMBR75M2904 $KINETOVERSION Leishmania_braziliensis_MHOMBR75M2904
fetchTriTrypDB LbraziliensisMHOMBR75M2903 $KINETOVERSION Leishmania_braziliensis_MHOMBR75M2903
fetchTriTrypDB LarabicaLEM1108 $KINETOVERSION Leishmania_arabica_LEM1108
fetchTriTrypDB LamazonensisMHOMBR71973M2269 $KINETOVERSION Leishmania_amazonensis_MHOMBR71973M2269
fetchTriTrypDB LaethiopicaL147 $KINETOVERSION Leishmania_aethiopica_L147
fetchTriTrypDB EmonterogeiiLV88 $KINETOVERSION Endotrypanum_monterogeii_LV88
fetchTriTrypDB CfasciculataCfCl $KINETOVERSION Crithidia_fasciculata_CfCl
fetchTriTrypDB BsaltansLakeKonstanz $KINETOVERSION Bodo_saltans_LakeKonstanz
fetchTriTrypDB BayalaiB08-376 $KINETOVERSION Blechomonas_ayalai_B08-376
fetchTriTrypDB AdeanaiCavalhoATCCPRA-265 $KINETOVERSION Angomonas_deanai_CavalhoATCCPRA-265
