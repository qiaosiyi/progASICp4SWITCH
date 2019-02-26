#read pcap text file
#generate verilog test init code
import re
file = open("1.txt")
times = 0
def delfun(line):
	a = len(line)
	b = a/3
	out=''
	for i in range(b):
		out=out + line[3*i+1]
		out=out + line[3*i+2]
	return out

while 1:
	line = file.readline()
	if not line:
		break
	if line[0] == "|":
		line = line[5:]
		ll = delfun(line)
		print ll,"times=",times,"len",len(ll)/2
		times = times + 1





	
	
