var fs=require("fs");
var path=require("path");

var minLength=100; //Minimum coding sequence length (aas)
var output="pep"; //pep (protein) or tra (nucleotide)

//Load sequences
var seqs=[];
var data="\n"+fs.readFileSync(path.resolve(process.cwd(), process.argv[2])).toString();
data=data.replace(/\r/gi, "").split("\n>");
for (var i=1; i<data.length; i++) {
	var name=data[i].substring(0, data[i].indexOf("\n"));
	if (name.indexOf(" ")!=-1) name=name.substring(0, name.indexOf(" "));
	seqs[name]=data[i].substring(data[i].indexOf("\n")).replace(/\n/gi, "").toUpperCase();
}

var codon={
	"A": [
		{"prob": 0.27, "codon": "GCT"},
		{"prob": 0.25, "codon": "GCC"},
		{"prob": 0.25, "codon": "GCA"},
		{"prob": 0.25, "codon": "GCG"}
	],
	"R": [
		{"prob": 0.27, "codon": "CGT"},
		{"prob": 0.31, "codon": "CGC"},
		{"prob": 0.11, "codon": "CGA"},
		{"prob": 0.14, "codon": "CGG"},
		{"prob": 0.06, "codon": "AGA"},
		{"prob": 0.11, "codon": "AGG"}
	],
	"N": [
		{"prob": 0.39, "codon": "AAT"},
		{"prob": 0.61, "codon": "AAC"}
	],
	"D": [
		{"prob": 0.48, "codon": "GAT"},
		{"prob": 0.52, "codon": "GAC"}
	],
	"C": [
		{"prob": 0.36, "codon": "TGT"},
		{"prob": 0.64, "codon": "TGC"}
	],
	"Q": [
		{"prob": 0.37, "codon": "CAA"},
		{"prob": 0.63, "codon": "CAG"}
	],
	"E": [
		{"prob": 0.34, "codon": "GAA"},
		{"prob": 0.66, "codon": "GAG"}
	],
	"G": [
		{"prob": 0.42, "codon": "GGT"},
		{"prob": 0.28, "codon": "GGC"},
		{"prob": 0.17, "codon": "GGA"},
		{"prob": 0.14, "codon": "GGG"}
	],
	"H": [
		{"prob": 0.36, "codon": "CAT"},
		{"prob": 0.64, "codon": "CAC"}
	],
	"I": [
		{"prob": 0.44, "codon": "ATT"},
		{"prob": 0.41, "codon": "ATC"},
		{"prob": 0.15, "codon": "ATA"}
	],
	"L": [
		{"prob": 0.06, "codon": "TTA"},
		{"prob": 0.15, "codon": "TTG"},
		{"prob": 0.26, "codon": "CTT"},
		{"prob": 0.22, "codon": "CTC"},
		{"prob": 0.08, "codon": "CTA"},
		{"prob": 0.23, "codon": "CTG"}
	],
	"K": [
		{"prob": 0.30, "codon": "AAA"},
		{"prob": 0.70, "codon": "AAG"}
	],
	"F": [
		{"prob": 0.45, "codon": "TTT"},
		{"prob": 0.55, "codon": "TTC"}
	],
	"P": [
		{"prob": 0.22, "codon": "CCT"},
		{"prob": 0.29, "codon": "CCC"},
		{"prob": 0.28, "codon": "CCA"},
		{"prob": 0.22, "codon": "CCG"}
	],
	"S": [
		{"prob": 0.17, "codon": "TCT"},
		{"prob": 0.21, "codon": "TCC"},
		{"prob": 0.16, "codon": "TCA"},
		{"prob": 0.14, "codon": "TCG"},
		{"prob": 0.16, "codon": "AGT"},
		{"prob": 0.16, "codon": "AGC"}
	],
	"T": [
		{"prob": 0.21, "codon": "ACT"},
		{"prob": 0.25, "codon": "ACC"},
		{"prob": 0.25, "codon": "ACA"},
		{"prob": 0.29, "codon": "ACG"}
	],
	"Y": [
		{"prob": 0.35, "codon": "TAT"},
		{"prob": 0.65, "codon": "TAC"}
	],
	"V": [
		{"prob": 0.29, "codon": "GTT"},
		{"prob": 0.16, "codon": "GTC"},
		{"prob": 0.14, "codon": "GTA"},
		{"prob": 0.41, "codon": "GTG"}
	],
	"M": [
		{"prob": 1.00, "codon": "ATG"}
	],
	"W": [
		{"prob": 1.00, "codon": "TGG"}
	],
	"*": [
		{"prob": 0.48, "codon": "TAA"},
		{"prob": 0.26, "codon": "TAG"},
		{"prob": 0.26, "codon": "TGA"}
	]
}

var invCodon={};
var start=[];
var stop=[];
for (var aa in codon) {
	for (var i=0; i<codon[aa].length; i++) {
		invCodon[codon[aa][i].codon]=aa;
		if (aa=="M") start.push(codon[aa][i].codon);
		if (aa=="*") stop.push(codon[aa][i].codon);
	}
}

function revCompl(s) {
	var rc={A: "T", T: "A", C: "G", G: "C"};
	os="";
	for (var i=s.length-1; i>=0; i--) os+=rc[s[i].toUpperCase()];
	return os;
}

function printOrfs(seq, name, rc) {
	var seq=seq.toUpperCase();
	if (rc==true) seq=revCompl(seq);
	var count=0;
	var countAll=0;
	for (var i=seq.length-1; i>=3; i--) {
		//Search from end to start of sequence
		if (stop.indexOf(seq.substring(i-3, i))!=-1) {
			var len=0;
			var pep="";
			var tra="";
			var lastStart=0;
			var o=3;
			//Find end or ORFs
			while (stop.indexOf(seq.substring(i-o-3, i-o))==-1 && i-o-3>=0) {
				//If a start codon, record its offset
				if (start.indexOf(seq.substring(i-o-3, i-o))!=-1) {
					lastStart=o;
				}
				pep=invCodon[seq.substring(i-o-3, i-o)]+pep;
				tra=seq.substring(i-o-3, i-o)+tra;
				o+=3;
			}
			pep=invCodon[seq.substring(i-o-3, i-o)]+pep;
			tra=seq.substring(i-o-3, i-o)+tra;
			countAll++;
			//If a start codon was found and the ORF is long enough
			if (lastStart!=0 && lastStart/3>=minLength) {
				//Correct peptide and transcript sequences to last start
				pep=pep.substring(pep.length-lastStart/3);
				tra=tra.substring(tra.length-lastStart);
				//Print result
				if (rc==false) {
					console.log(">"+name+"_+_"+(i-o+1)+"-"+(i+1));
				} else {
					console.log(">"+name+"_-_"+(seq.length-(i-o)+1)+"-"+(seq.length-i+1));
				}
				if (output=="pep") {
					console.log(pep);
				} else if (output=="tra") {
					console.log(tra);
				}
				count++;
			}
			i-=Math.min(0, lastStart);
		}
	}
	console.error([countAll, "ORFs", count, ">"+minLength+" aas"].join(" "));
}

for (var seq in seqs) {
	console.error(seq, "forward");
	printOrfs(seqs[seq], seq, false);
	console.error(seq, "reverse complement");
	printOrfs(seqs[seq], seq, true);
}
