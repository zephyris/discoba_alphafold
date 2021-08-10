rm accessdate.txt
rm list.csv
rm -r fastaTidy
mkdir fasta
mkdir fastaTidy

fetchSRARead() {
  echo "SRA,$2,$1,genome assembly and transdecoder" >> list.csv
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
  if [ ! -f fasta/$1 ]
  then
    cd $1
    cp ../buildTranscriptome.sh buildTranscriptome.sh
    bash buildTranscriptome.sh
    cp trans.nonred.fasta.transdecoder.pep ../fasta/$1.fasta
    rm *.fastq *.fq
    cd ..
  fi
}

#PRJNA624171
fetchSRARead SRR11528868 Symbiontida_sp_KSa7
fetchSRARead SRR11528869 Symbiontida_sp_HLA12
fetchSRARead SRR11528870 Heteronema_vittatum_CB2
fetchSRARead SRR11528871 Chasmostoma_nieuportense_CB1
fetchSRARead SRR11528872 Ploeotia_sp_CARIB1
fetchSRARead SRR11528873 Urceolus_sp_BLP5
fetchSRARead SRR11528874 Sphenomonas_quadrangularis_AM6
fetchSRARead SRR11528875 Neometanema_parovale_KM051
fetchSRARead SRR11528876 Ploeotia_vitrea_MX-CHA
fetchSRARead SRR11528877 Keelungia_sp_KM082
fetchSRARead SRR11528878 Notosolenus_urceolatus_KM049
fetchSRARead SRR11528879 Olkasia_polycarbonata_UB49
fetchSRARead SRR11528880 Heteronema_vittatum_ABIC3
fetchSRARead SRR11528881 Olkasia_polycarbonata_UB45
fetchSRARead SRR11528882 Liburna_glaciale_UB43
fetchSRARead SRR11528883 Liburna_glaciale_UB37
fetchSRARead SRR11528884 Dinema_litorale_UB26
fetchSRARead SRR11528885 Anisonema_acinus_SMS2
fetchSRARead SRR11528886 Anisonema_acinus_SAL5
fetchSRARead SRR11528887 Peranema_trichophorum_PtR
fetchSRARead SRR11528888 Jenningsia_sp_PLL12
fetchSRARead SRR11528889 Urceolus_cf_cornutus_PLL10
fetchSRARead SRR11528890 Lentomonas_cf_corrugata_LEN2
fetchSRARead SRR11528891 Jenningsia_fusiforme_ABIC1
fetchSRARead SRR11528892 Dinema_validum_AB2-2

buildTrans Symbiontida_sp_KSa7
buildTrans Symbiontida_sp_HLA12
buildTrans Heteronema_vittatum_CB2
buildTrans Chasmostoma_nieuportense_CB1
buildTrans Ploeotia_sp_CARIB1
buildTrans Urceolus_sp_BLP5
buildTrans Sphenomonas_quadrangularis_AM6
buildTrans Neometanema_parovale_KM051
buildTrans Ploeotia_vitrea_MX-CHA
buildTrans Keelungia_sp_KM082
buildTrans Notosolenus_urceolatus_KM049
buildTrans Olkasia_polycarbonata_UB49
buildTrans Heteronema_vittatum_ABIC3
buildTrans Olkasia_polycarbonata_UB45
buildTrans Liburna_glaciale_UB43
buildTrans Liburna_glaciale_UB37
buildTrans Dinema_litorale_UB26
buildTrans Anisonema_acinus_SMS2
buildTrans Anisonema_acinus_SAL5
buildTrans Peranema_trichophorum_PtR
buildTrans Jenningsia_sp_PLL12
buildTrans Urceolus_cf_cornutus_PLL10
buildTrans Lentomonas_cf_corrugata_LEN2
buildTrans Jenningsia_fusiforme_ABIC1
buildTrans Dinema_validum_AB2-2

#PRJNA564423
fetchSRARead SRR10099989 Distigma_sp_N6
fetchSRARead SRR10099983 Distigma_sp_P2
fetchSRARead SRR10099980 Distigma_sp_P5

buildTrans Distigma_sp_N6
buildTrans Distigma_sp_P2
buildTrans Distigma_sp_P5

#PRJNA564423
fetchSRARead SRR10099986 Euglenida_sp_18W
fetchSRARead SRR10100068 Euglenida_sp_3W
fetchSRARead SRR10100025 Euglenida_sp_D1
fetchSRARead SRR10100023 Euglenida_sp_E4
fetchSRARead SRR10100020 Euglenida_sp_F2
fetchSRARead SRR10100012 Euglenida_sp_H2
fetchSRARead SRR10100003 Euglenida_sp_L1
fetchSRARead SRR10100000 Euglenida_sp_L5
fetchSRARead SRR10099991 Euglenida_sp_N4
fetchSRARead SRR10099982 Euglenida_sp_P3
fetchSRARead SRR10099979 Euglenida_sp_P6
fetchSRARead SRR10099974 Euglenida_sp_R5
fetchSRARead SRR10099972 Euglenida_sp_R7
fetchSRARead SRR10099970 Euglenida_sp_S1
fetchSRARead SRR10100039 Euglenida_sp_X3

buildTrans Euglenida_sp_18W
buildTrans Euglenida_sp_3W
buildTrans Euglenida_sp_D1
buildTrans Euglenida_sp_E4
buildTrans Euglenida_sp_F2
buildTrans Euglenida_sp_H2
buildTrans Euglenida_sp_L1
buildTrans Euglenida_sp_L5
buildTrans Euglenida_sp_N4
buildTrans Euglenida_sp_P3
buildTrans Euglenida_sp_P6
buildTrans Euglenida_sp_R5
buildTrans Euglenida_sp_R7
buildTrans Euglenida_sp_S1
buildTrans Euglenida_sp_X3

#PRJNA564423
fetchSRARead SRR10100019 Kinetoplastida_sp_10W
fetchSRARead SRR10099975 Kinetoplastida_sp_19W
fetchSRARead SRR10099964 Kinetoplastida_sp_23W
fetchSRARead SRR10100069 Kinetoplastida_sp_2W
fetchSRARead SRR10100051 Kinetoplastida_sp_7W
fetchSRARead SRR10100030 Kinetoplastida_sp_9W
fetchSRARead SRR10100032 Kinetoplastida_sp_A9
fetchSRARead SRR10100029 Kinetoplastida_sp_C1
fetchSRARead SRR10100027 Kinetoplastida_sp_C5
fetchSRARead SRR10100026 Kinetoplastida_sp_C6
fetchSRARead SRR10100024 Kinetoplastida_sp_E1
fetchSRARead SRR10100002 Kinetoplastida_sp_L2
fetchSRARead SRR10099999 Kinetoplastida_sp_L7
fetchSRARead SRR10099990 Kinetoplastida_sp_N5
fetchSRARead SRR10100038 Kinetoplastida_sp_X6
fetchSRARead SRR10100062 Kinetoplastida_sp_Z3

buildTrans Kinetoplastida_sp_10W
buildTrans Kinetoplastida_sp_19W
buildTrans Kinetoplastida_sp_23W
buildTrans Kinetoplastida_sp_2W
buildTrans Kinetoplastida_sp_7W
buildTrans Kinetoplastida_sp_9W
buildTrans Kinetoplastida_sp_A9
buildTrans Kinetoplastida_sp_C1
buildTrans Kinetoplastida_sp_C5
buildTrans Kinetoplastida_sp_C6
buildTrans Kinetoplastida_sp_E1
buildTrans Kinetoplastida_sp_L2
buildTrans Kinetoplastida_sp_L7
buildTrans Kinetoplastida_sp_N5
buildTrans Kinetoplastida_sp_X6
buildTrans Kinetoplastida_sp_Z3
