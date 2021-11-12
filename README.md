# Google Colaboratory notebooks for protein structure predictions for Discoba species
These Colaboratory notebooks are ideal for predicting structures of _Trypanosoma_ and _Leishmania_ species, along with other kinetoplastids, euglenids, diplonemids, etc.

To use a notebook, follow the link to the notebook code then click on the "Open in Colab" badge to run the notebook in Google Colab.

## Get started quickly!
**[Go here](https://colab.research.google.com/github/zephyris/discoba_alphafold/blob/main/DiscobaAlphaFold2HMMER.ipynb)** to carry out a protein structure prediction.
Enter your protein sequence (**query_sequence**) and name (**jobname**) then press <kbd>Ctrl</kbd> + <kbd>F9</kbd> or select `Runtime` > `Run All`. It will probably take a couple of hours, depending on protein length.

You need to make sure that Google Colab is using GPU hardware acceleration. Go to `Runtime` > `Change runtime type` and make sure GPU is selected for Hardware accelerator. If you get an error you have probably run out of GPU memory: try predicting just part of your protein.

## Protein structure predictions
These carry out a protein structure prediction, from input protein sequence through to a download of the predicted structure as a PDB file.

[DiscobaAlphaFold2HMMER](https://github.com/zephyris/discoba_alphafold/blob/main/DiscobaAlphaFold2HMMER.ipynb): For prediction of protein structures using ColabFold modified to also include a HMMER search of the Discoba protein sequence database **(recommended!)**.

[DiscobaAlphaFold2MMSeqs2](https://github.com/zephyris/discoba_alphafold/blob/main/DiscobaAlphaFold2MMSeqs2.ipynb): For prediction using ColabFold modified to also include an MMSeqs2 search of the Discoba protein sequence database.

These protein structure predictions are based on [ColabFold](https://github.com/sokrypton/ColabFold), which uses a MMSeqs2 search of UniRef and environmental sequence databases to make an MSA, then an AlphaFold2 structural prediction.

## Multiple sequence alignment
These generate a multiple sequence alignment, generating an a3m alignment file suitable for use for use in other protein structure prediction pipelines.

[DiscobaHMMER](https://github.com/zephyris/discoba_alphafold/blob/main/DiscobaHMMER.ipynb): For generating an a3m alignment file using a HMMER search of the Discoba protein database.

[DiscobaMMSeqs2](https://github.com/zephyris/discoba_alphafold/blob/main/DiscobaMMSeqs2.ipynb): For generating an a3m using an MMSeqs2 search of the Discoba protein database.

## Discoba database generation
The [transcriptomes](https://github.com/zephyris/discoba_alphafold/tree/main/transcriptomes) folder contains the code necessary to fetch and build the predicted protein sequences of all Discoba species in the Discoba protein sequence database.
Clone the repository, then run fetchAll.sh to build the entire database. This will take some time... Requires curl, gzip, perl, python, nodejs, cutadapt, jellyfish, bowtie2, bwa and samtools. Fetches and builds trinity, which requires autoconf, libbz2-dev and liblzma-dev. Fetches and builds cdhit which _should_ require no further dependencies. Other tools are either scripts or fetched as precompiled packages.

## Discoba database
The complete Discoba protein sequence database is currently available for download from [WheelerLab.net](http://wheelerlab.net): [discoba.fasta.gz](http://wheelerlab.net/discoba.fasta.gz) and version information in [discobaStats.txt](http://wheelerlab.net/discobaStats.txt). Once stable, it will likely be moved to Zenodo.

### Acknowledgments
This work builds on the excellent [ColabFold](https://github.com/sokrypton/ColabFold) and would not be possible without the work by Sergey Ovchinnikov (@sokrypton), Milot Mirdita (@milot_mirdita) and Martin Steinegger (@thesteinegger).

### Referencing
If you use structure predictions made using this resource, please cite:

Wheeler RJ. "A resource for improved predictions of Trypanosoma and Leishmania protein three-dimensional structure"
_PLoS One_, doi:&nbsp;[10.1371/journal.pone.0259871](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0259871) (2021)

Mirdita M, Ovchinnikov S and Steinegger M. "ColabFold - Making protein folding accessible to all."
_bioRxiv_, doi:&nbsp;[10.1101/2021.08.15.456425](https://www.biorxiv.org/content/10.1101/2021.08.15.456425v1) (2021)

Please also cite the relevant AlphaFold and database references, see ColabFold documentation for full information.

If you only use the multiple sequence alignments then please just cite Wheeler 2021.
