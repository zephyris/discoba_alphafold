import sys
import os.path as path

max_length = int(sys.argv[2]) #Must be even
name = sys.argv[1][:-len(".fasta.iupred")]
path_head, path_tail = path.split(name)
file = open(sys.argv[1])
lines = file.read().splitlines()
file.close()
residues = []
scores = []
for i in range(len(lines)):
	data = lines[i].split("\t")
	residues.append(data[1])
	scores.append(float(data[2]))

offset = 0
while len(residues) > max_length:
	max_score = max(scores[int(max_length/2):max_length])
	index = scores[int(max_length/2):max_length].index(max_score) + int(max_length/2)
	file = open(f"{name}_{offset+1}-{offset+index}.fasta", "w")
	file.write(f">{path_tail}_{offset+1}-{offset+index}\n")
	file.write(f"{''.join(residues[:index])}\n")
	file.close()
	offset = offset + index
	residues = residues[index:]
	scores = scores[index:]
file = open(f"{name}_{offset+1}-{offset+len(residues)}.fasta", "w")
file.write(f">{path_tail}_{offset+1}-{offset+len(residues)}\n")
file.write(f"{''.join(residues)}\n")
file.close()
