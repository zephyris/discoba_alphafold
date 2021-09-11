import sys
import os.path as path

max_length = int(sys.argv[2]) # Max length of sequence, must be even
patch_size = 30 # Region around cuts in which to check score
patch_thr = 0.25 # Score threshold for making patch
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
residues_raw = residues

offset = 0
# Allow 10% over-length on final section
while len(residues) > max_length * 1.1:
	max_score = max(scores[int(max_length/2):max_length])
	index = scores[int(max_length/2):max_length].index(max_score) + int(max_length/2)
	file = open(f"{name}_{offset+1}-{offset+index}.fasta", "w")
	file.write(f">{path_tail}_{offset+1}-{offset+index}\n")
	file.write(f"{''.join(residues[:index])}\n")
	file.close()
	# Check cut region, and write spanning 'patch' if iupred score is too low
	min_score_patch = min(scores[max(index - 30, 0):min(index, len(residues))])
	if min_score_patch < patch_thr:
		patch_start = int(max(index - max_length / 4, 0))
		patch_end = int(min(index + max_length / 4, len(residues)))
		file = open(f"{name}_{patch_start+1}-{patch_end}.fasta", "w")
		file.write(f">{path_tail}_{patch_start+1}-{patch_end}\n")
		file.write(f"{''.join(residues_raw[patch_start:patch_end])}\n")
		file.close()
	# Update offsets for next iteration
	offset = offset + index
	residues = residues[index:]
	scores = scores[index:]
file = open(f"{name}_{offset+1}-{offset+len(residues)}.fasta", "w")
file.write(f">{path_tail}_{offset+1}-{offset+len(residues)}\n")
file.write(f"{''.join(residues)}\n")
file.close()
