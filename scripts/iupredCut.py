import sys
import os.path as path

max_length = int(sys.argv[2]) # Max length of sequence, must be even
patch_size = 30 # Region around cuts in which to check score
patch_thr = 0.25 # Score threshold for making patch
patch_length = 200 # Patch overlap (half full patch length)
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
while len(residues) > max_length:
	max_score = max(scores[int(max_length/2):max_length])
	index = scores[int(max_length/2):max_length].index(max_score) + int(max_length/2)
	file = open(f"{name}_{offset+1}-{offset+index}.fasta", "w")
	file.write(f">{path_tail}_{offset+1}-{offset+index}\n")
	file.write(f"{''.join(residues[:index])}\n")
	file.close()
	# Check cut region, and write spanning 'patch' if iupred score is too low
	min_score_patch = min(scores[max(index - 30, 0):min(index, len(residues))])
	# Force the patch to always be used
	min_score_patch = patch_thr
	if min_score_patch < patch_thr:
		patch_start = int(max(index - patch_length, 0))
		patch_end = int(min(index + patch_length, len(residues)))
		file = open(f"{name}_{offset + patch_start+1}-{offset + patch_end}.fasta", "w")
		file.write(f">{path_tail}_{offset + patch_start+1}-{offset + patch_end}\n")
		file.write(f"{''.join(residues_raw[offset + patch_start:offset + patch_end])}\n")
		file.close()
	# Update offsets for next iteration
	offset = offset + index
	residues = residues[index:]
	scores = scores[index:]
file = open(f"{name}_{offset+1}-{offset+len(residues)}.fasta", "w")
file.write(f">{path_tail}_{offset+1}-{offset+len(residues)}\n")
file.write(f"{''.join(residues)}\n")
file.close()
