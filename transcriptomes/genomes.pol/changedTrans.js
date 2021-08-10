//changedTrans.js
//Usage: nodejs changedTrans.js <reference.fa> <polished.fa> <name suffix>
//Outputs the simple translation of CDSs which differ from the reference
//Assumes both fasta files contain the same number of sequences with the same names
//Output sequence name (when different) is given the name suffix for unique naming
//Only outputs sequences with a start codon, up to any internal stop codon

var fs=require("fs");
var path=require("path");

//Load sequences
var fa1=fs.readFileSync(path.resolve(process.cwd(), process.argv[2])).toString();
fa1=loadSeqs(fa1);
var fa2=fs.readFileSync(path.resolve(process.cwd(), process.argv[3])).toString();
fa2=loadSeqs(fa2);

function loadSeqs(data) {
	var data="\n"+data
	var seqs=[];
	data=data.replace(/\r/gi, "").split("\n>");
	for (var i=1; i<data.length; i++) {
		name=data[i].substring(0, data[i].indexOf("\n"));
		if (name.indexOf(" ")!=-1) name=name.substring(0, name.indexOf(" "));
		seqs[name]=data[i].substring(data[i].indexOf("\n")).replace(/\n/gi, "");
	}
	return seqs;
}

var codon={
	"A": ["GCT", "GCC", "GCA", "GCG"],
	"R": ["CGT", "CGC", "CGA", "CGG", "AGA", "AGG"],
	"N": ["AAT", "AAC"],
	"D": ["GAT", "GAC"],
	"C": ["TGT", "TGC"],
	"Q": ["CAA", "CAG"],
	"E": ["GAA", "GAG"],
	"G": ["GGT" ,"GGC" ,"GGA" ,"GGG"],
	"H": ["CAT", "CAC"],
	"I": ["ATT", "ATC", "ATA"],
	"L": ["TTA" ,"TTG" , "CTT" ,"CTC" ,"CTA","CTG"],
	"K": ["AAA", "AAG"],
	"F": ["TTT", "TTC"],
	"P": ["CCT", "CCC", "CCA", "CCG"],
	"S": ["TCT", "TCC", "TCA", "TCG", "AGT", "AGC"],
	"T": ["ACT", "ACC", "ACA", "ACG"],
	"Y": ["TAT", "TAC"],
	"V": ["GTT", "GTC", "GTA", "GTG"],
	"M": ["ATG"],
	"W": ["TGG"],
	"*": ["TAA", "TAG", "TGA"]
}

var invCodon={};
for (var aa in codon) for (var i=0; i<codon[aa].length; i++) invCodon[codon[aa][i]]=aa;

var countTotal=0;
var countDifferent=0;
var countChanged=0;
var countNoStart=0;
var countEarlyStop=0;
for (var seq in fa1) {
	var pep1="";
	var pep2="";
	countTotal++;
	if (fa1[seq]!=fa2[seq]) countDifferent++;
	for (var i=0; i<fa1[seq].length-3; i+=3) pep1+=invCodon[fa1[seq].substring(i, i+3)];
	for (var i=0; i<fa2[seq].length-3; i+=3) pep2+=invCodon[fa2[seq].substring(i, i+3)];
	if (pep1!=pep2) {
		countChanged++;
		if (pep2[0]=="M") {
			console.log(">"+seq+"_"+process.argv[4]);
			if (pep2.indexOf("*")==-1) {
				console.log(pep2);
			} else {
				countEarlyStop++;
				console.log(pep2.substring(0, pep2.indexOf("*")));
			}
		} else {
			countNoStart++
		}
	}
}
console.error("Changed transcript results for "+process.argv[4]);
console.error([countTotal, "total sequences"].join("\t"));
console.error([countDifferent, "differ in nucleotide sequence"].join("\t"));
console.error([countChanged, "differ in protein sequence"].join("\t"));
console.error([countNoStart, "lost the start codon"].join("\t"));
console.error([countEarlyStop, "gained an early stop"].join("\t"));