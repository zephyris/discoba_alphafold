var fs=require("fs");
var path=require("path");

//Load sequences
var seqs=[];
var data="\n"+fs.readFileSync(path.resolve(process.cwd(), process.argv[2])).toString();
data=data.replace(/\r/gi, "").split("\n>");
for (var i=1; i<data.length; i++) {
	seqs.push(data[i].substring(data[i].indexOf("\n")).replace(/\n/gi, ""));
}

stats={
	start: 0,
	stops: 0,
	length: 0,
	count: 0,
	lenList: []
};
for (var i=0; i<seqs.length; i++) {
	stats.count++;
	if (seqs[i][0]=="M") stats.start++;
	if (seqs[i][seqs[i].length-1]=="*") {
		seqs[i]=seqs[i].substring(0, seqs[i].length-1);
	}
	if (seqs[i].indexOf("*")!=-1) stats.stops++;
	stats.length+=seqs[i].length;
	stats.lenList.push(seqs[i].length);
}
stats.lenList.sort(function(a, b) {
	return a-b;
});
console.log([process.argv[2], stats.count, stats.length, stats.length/stats.count, stats.start/stats.count, stats.stops/stats.count, stats.lenList[Math.floor(stats.count*0.25)], stats.lenList[Math.floor(stats.count*0.50)], stats.lenList[Math.floor(stats.count*0.75)]].join(","));