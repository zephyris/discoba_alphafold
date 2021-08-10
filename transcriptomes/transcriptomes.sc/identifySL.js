//identifySL.js
//Identifies spliced leader sequences from an assembled transcriptome
//usage: nodejs identifySL.js <transcriptome.fasta>
//
//Identifies the most common kmer at the sequence start/end (length searchLen)
//  Excludes polyA/polyT kmers
//Extends the kmer while there is high consensus among sequences (>searchProp agree)
//Trims this sequence from all reads and iterates
//  Iterates while the most common kmer is >minProp
//  Iterates while under maxIter
//Returns the longest sequence for which:
//  the most common kmer from iteration 1 is a subsequence
//  the incidence is >minProp

var fs=require("fs");
var path=require("path");

//Seed length for search
var searchLen=10; //Seed sequence length for searching (bp)
var searchProp=0.9; //Maximum acceptable drop in incidence for each iteration expanding seed
var maxIter=10; //Maximum number of search iterations
var minProp=0.005; //Only accept results found in at least this proportion of reads
console.error("Seed kmer length:", searchLen+"bp");
console.error("Search consensus proportion:", searchProp);
console.error("Maximum iterations:", maxIter);
console.error("Minimum proportion:", minProp);

//Load sequences
var seqs=[];
var data="\n"+fs.readFileSync(path.resolve(process.cwd(), process.argv[2])).toString();
data=data.replace(/\r/gi, "").split("\n>");
for (var i=1; i<data.length; i++) {
	seqs.push(data[i].substring(data[i].indexOf("\n")).replace(/\n/gi, ""));
}
console.error("Number of sequences:", seqs.length);

function revCompl(s) {
	var rc={A: "T", T: "A", C: "G", G: "C"};
	os="";
	for (var i=0; i<s.length; i++) os=rc[s[i]]+os;
	return os;
}

//Get the end of each sequence of length len
//type is "start" or "end"
function getEndSeqs(seqs, len, type) {
	var ends={};
	for (var i=0; i<seqs.length; i++) {
		if (type=="start") {
			var end=seqs[i].substring(0, len);
		} else if (type=="end") {
			var end=revCompl(seqs[i].substring(seqs[i].length-len));
		}
		if (!ends[end]) ends[end]=0;
		ends[end]++;
	}
	return ends;
}

//Get most commonly occuring end of sequences, excluding polyA/polyT
function getCommonEnd(seqs, len) {
	var ends=getEndSeqs(seqs, len, "end");
	var starts=getEndSeqs(seqs, len, "start");
	for (start in starts) {
		ends[start]=starts[start];
	}
	var maxEnd=-1;
	var endSeq="";
	//Generate polyA/polyT
	var polyA="";
	var polyT="";
	for (var i=0; i<len; i++) {
		polyA+="A";
		polyT+="T";
	}
	for (var end in ends) {
		if (ends[end]>maxEnd && end!=polyA && end!=polyT) {
			maxEnd=ends[end];
			endSeq=end;
		}
	}
	var res={};
	res.seq=endSeq;
	res.count=maxEnd;
	res.prop=maxEnd/seqs.length;
	return res;
}

//Expand length of sequence end while incidence remains sufficiently high
function expandEnd(seqs, commonEnds, searchLen) {
	var curCommonEnds=commonEnds;
	var curEndLen=searchLen;
	while (curCommonEnds.count/commonEnds.count>searchProp && curCommonEnds.seq.indexOf(commonEnds.seq)!=-1) {
		curEndLen++;
		commonEnds=curCommonEnds;
		curCommonEnds=getCommonEnd(seqs, curEndLen);
	}
	return(commonEnds);
}

//Trim end sequence from all sequences
function trimEnd(seqs, commonEnds, type) {
	for (var i=0; i<seqs.length; i++) {
		if (seqs[i].substring(0, commonEnds.seq.length)==commonEnds.seq) {
			seqs[i]=seqs[i].substring(commonEnds.seq.length);
		}
		if (seqs[i].substring(seqs[i].length-commonEnds.seq.length)==revCompl(commonEnds.seq)) {
			seqs[i]=seqs[i].substring(0, seqs[i].length-commonEnds.seq.length);
		}
	}
	return seqs;
}

var sls=[];
//Iterate to find progressively less frequent end sequences
console.error(["iter.", "type    ", "length", "count", "perc.", "sequence"].join("\t"));
for (var iteration=0; iteration<maxIter; iteration++) {
	//Find the most common sequence starts/ends (excluding polyA/polyT)
	var commonEnds=getCommonEnd(seqs, searchLen);
	console.error([iteration, "seed seq.", commonEnds.seq.length+"bp", commonEnds.count, Math.round(100*100*commonEnds.prop)/100+"%", commonEnds.seq].join("\t"));

	//Expand the most common starts/ends until frequency drops too far
	commonEnds=expandEnd(seqs, commonEnds, searchLen);
	console.error([iteration, "expanded", commonEnds.seq.length+"bp", commonEnds.count, Math.round(100*100*commonEnds.prop)/100+"%", commonEnds.seq].join("\t"));

	sls.push(
		commonEnds
	);
	//Break the loop if under the minimum proportion
	if (commonEnds.prop<minProp) {
		break;
	}

	//Trim the detected starts/ends from the sequences
	seqs=trimEnd(seqs, commonEnds);
}

//Find longest end sequence which:
//  Includes the sequence from iteration 1
//  Has an occurence of at least minProp
if (sls[0].prop<minProp) {
	var sl="";
	console.error("No common start/end with necessary occurence found");
} else {
	var sl=sls[0].seq;
	var slp=sls[0].prop;
	for (var i=1; i<sls.length; i++) {
		if (sls[i].prop>=minProp && sls[i].seq.indexOf(sl)!=-1) {
			sl=sls[i].seq;
			slp=sls[i].prop;
			console.error("Updated from iteration "+(i+1), sl);
		}
	}
	console.error("Spliced leader sequence identified:");
	console.log(sl);
	console.error("Reverse complement:");
	console.log(revCompl(sl));
	console.error("Frequency:");
	console.log(slp);

	var cumulativeProp=0;
	for (var i=0; i<sls.length; i++) {
		if (sl.indexOf(sls[i].seq)!=-1) {
			cumulativeProp+=sls[i].prop;
		}
	}
	console.error("Found on "+Math.round(100*100*cumulativeProp)/100+"%"+" of transcripts");
}