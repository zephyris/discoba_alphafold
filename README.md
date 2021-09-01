# Google Colaboratory notebooks for protein structure predictions for Discoba species
These Colaboratory notebooks are ideal for predicting structures of _Trypanosoma_ and _Leishmania_ species, along with other kinetoplastids, euglenids, diplonemids, etc.

To use a notebook, follow the link to the notebook code then  click on the "Open in Colab" badge to run the notebook in Google Colab.

## Protein structure predictions
These carry out a protein structure prediction, from input protein sequence through to a download of the predicted structure as a PDB file.

[DiscobaAlphaFold2HMMER](https://github.com/zephyris/discoba_alphafold/blob/main/DiscobaAlphaFold2HMMER.ipynb) For prediction of protein structures using ColabFold modified to also include a HMMER search of the Discoba protein sequence database (recommended!).

[DiscobaAlphaFold2MMSeqs2](https://github.com/zephyris/discoba_alphafold/blob/main/DiscobaAlphaFold2MMSeqs2.ipynb) For prediction using ColabFold modified to also include an MMSeqs2 search of the Discoba protein sequence database.

This protein structure prediction pipeline is based on [ColabFold](https://github.com/sokrypton/ColabFold), which uses a MMSeqs2 search of UniRef and environmental sequence databases to make an MSA, then an AlphaFold2 structural prediction.

## Multiple sequence alignment
These generate a multiple sequence alignment, generating an a3m alignment file suitable for use for use in other protein structure prediction pipelines.

[DiscobaHMMER](https://github.com/zephyris/discoba_alphafold/blob/main/DiscobaHMMER.ipynb) For generating an a3m alignment file using a HMMER search of the Discoba protein database.

[DiscobaMMSeqs2](https://github.com/zephyris/discoba_alphafold/blob/main/DiscobaMMSeqs2.ipynb) For generating an a3m using an MMSeqs2 search of the Discoba protein database.

## Discoba database generation
The [transcriptomes](https://github.com/zephyris/discoba_alphafold/tree/main/transcriptomes) folder contains the code necessary to fetch and build the predicted protein sequences of all Discoba species in the Discoba protein sequence database.
Running fetchAll.sh builds the entire database. Requires curl, gzip, perl, python, nodejs, cutadapt, jellyfish, bowtie2, bwa, samtools. Fetches and builds trinity, which requires autoconf, libbz2-dev and liblzma-dev. Fetches and builds cdhit which should require no further dependencies.

## Discoba database
The complete Discoba protein sequence database is currently available for download form [WheelerLab.net](http://wheelerlab.net): [discoba.fasta.gz](http://wheelerlab.net/discoba.fasta.gz) and version information in [discobaStats.txt](http://wheelerlab.net/discobaStats.txt). Once stable, it will likely be moved to Zenodo.
