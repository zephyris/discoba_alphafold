#Google Colaboratory notebooks for protein structure predictions for Discoba species
These Colaboratory notebooks are ideal for predicting structures of _Trypanosoma_ and _Leishmania_ species, along with other kinetoplastids, euglenids, diplonemids, etc.

##Protein structure predictions
These carry out a protein structure prediction, from input protein sequence through to a download of the predicted structure as a PDB file.

Protein structure predictions are based on [https://github.com/sokrypton/ColabFold](ColabFold), which uses a MMSeqs2 search of UniRef and environmental sequence databases to make an MSA, then an AlphaFold2 structural prediction.

[DiscobaAlphaFold2MMSeqs2](https://github.com/zephyris/discoba_alphafold/blob/main/DiscobaAlphaFold2MMSeqs2.ipynb) For prediction of protein structures using ColabFold modified to also include a HMMER search of the Discoba protein sequence database.

[DiscobaAlphaFold2HMMER](https://github.com/zephyris/discoba_alphafold/blob/main/DiscobaAlphaFold2HMMER.ipynb) For prediction of protein structures using ColabFold modified to also include an MMSeqs2 search of the Discoba protein sequence database.

##Multiple sequence alignment
These generate a multiple sequence alignment, generating an a3m alignment file suitable for use for use in other protein structure prediction pipelines.

[DiscobaMMSeqs2](https://github.com/zephyris/discoba_alphafold/blob/main/DiscobaMMSeqs2.ipynb) For generating an a3m alignment file using an MMSeqs2 search of the Discoba protein database.

[DiscobaHMMER](https://github.com/zephyris/discoba_alphafold/blob/main/DiscobaHMMER.ipynb) For generating an a3m alignment file using a HMMER search of the Discoba protein database.

##Discoba database generation
The [https://github.com/zephyris/discoba_alphafold/tree/main/transcriptomes](transcriptomes) folder contains the code necessary to fetch and build the predicted protein sequences of all Discoba species in the Discoba protein sequence database.
Running fetchAll.sh builds the entire database. Requires curl, gzip, perl, python, nodejs, cutadapt, jellyfish, bowtie2, bwa, samtools. Fetches and builds trinity, which requires autoconf, libbz2-dev and liblzma-dev. Fetches and builds cdhit which should require no further dependencies.
