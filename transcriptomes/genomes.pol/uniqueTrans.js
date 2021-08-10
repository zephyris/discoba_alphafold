//uniqueTrans.js
//Usage: nodejs changedTrans.js <sequences.fa>
//Outputs only sequences which are unique

var fs=require("fs");
var path=require("path");

function loadSeqs(data) {
	var data="\n"+data
	var seqs=[];
	data=data.replace(/\r/gi, "").split("\n>");
	for (var i=1; i<data.length; i++) {
		name=data[i].substring(0, data[i].indexOf("\n"));
		if (name.indexOf(" ")!=-1) name=name.substring(0, name.indexOf(" "));
		seqs.push({
			name: name,
			seq: data[i].substring(data[i].indexOf("\n")).replace(/\n/gi, "")
		});
	}
	return seqs;
}

//Load sequences
console.error("Loading sequences");
var seqs=fs.readFileSync(path.resolve(process.cwd(), process.argv[2])).toString();
seqs=loadSeqs(seqs);

var initialCount=seqs.length;
var remCount=0;
for (var i=0; i<seqs.length; i++) {
	if (i%1000==0) console.error("Processing sequence "+i+" of "+seqs.length+" remaining sequences");
	//Check all later sequences
	for (var j=i+1; j<seqs.length; j++) {
		//If the sequences are identical
		if (seqs[i].seq==seqs[j].seq) {
			remCount++;
			seqs.splice(j, 1);
			//Decrement j if we've just deleted an entry
			j--;
		}
	}
}
console.error(initialCount+" sequences initially present");
console.error(remCount+" duplicate sequences removed");
console.error(seqs.length+" unique sequences remaining");

for (var i=0; i<seqs.length; i++) {
	console.log(">"+seqs[i].name);
	console.log(seqs[i].seq);
}