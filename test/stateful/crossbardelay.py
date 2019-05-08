import random
import math
import sys

ff = [0,0,0,0]

for i in range(400):
	v1 = int(random.random()*4)
	v2 = int(random.random()*4)
	v3 = int(random.random()*4)
	v4 = int(random.random()*4)

	if random.random() < 0.80:
		ff[v1] = ff[v1] + 1
	if random.random() < 0.80:
		ff[v2] = ff[v2] + 1
	if random.random() < 0.80:
		ff[v2] = ff[v2] + 1
	if random.random() < 0.80:
		ff[v2] = ff[v2] + 1

	if ff[0] > 0:
		ff[0] = ff[0] - 1
	if ff[1] > 0:
		ff[1] = ff[1] - 1
	if ff[2] > 0:
		ff[2] = ff[2] - 1
	if ff[3] > 0:
		ff[3] = ff[3] - 1

	print ff[0],ff[1],ff[2],ff[3]
	# print ff[1]
	# print ff[2]
	# print ff[3]
