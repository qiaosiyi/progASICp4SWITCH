import random
import math
import sys
quint64 = 18446744073709551615
quint8 = 255
quint32 = 4294967295
quint16 = 65535

D = 3012#3456
di = 1.0068


def getPC(cc,di):
	flag = 0
	with open("DISCOplut.txt","wt") as ofile:
		with open("DISCOplutDMA.txt","wt") as ofiledma:
			for i in range(int(D - cc)):
				c = cc + i
				fC = (math.pow(di,c) - 1) / ( di - 1 )
				fC1 = (math.pow(di,c+1) - 1) / ( di - 1 )
				pc = 1/(fC1 - fC)*quint32
				# print "c",c,"Pc",pc
				ofile.write("PLUT["+str(int(c))+"] <= "+str(int(math.floor(pc)))+";")
				ofiledma.write(str(int(c))+" "+str(int(math.floor(pc)))+"\n")
				if flag == 0:
					plutmax = int(math.floor(pc))
					cmax = c
					flag = 1
	# print "plutmax =",plutmax,"plutwidth =",plutmax.bit_length()+2
	print "= Plut Width =",plutmax.bit_length()+2
	print "="
	aaa = (math.pow(di,D) - 1) / ( di - 1 )
	aaaGB = aaa/1024/1024/1024
	print "= Max counting value for one flow =", aaa,"Bytes( %.2f" % aaaGB,"GB)"
	print "="
	print "= Write PLUT calculation values in file named DISCOplut.txt !!"
	print "=","cmax=",int(cmax)
	print "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="
	print

def main(di):
	c = 0
	sumL = 1
	for i in range(1500):
		v = random.random()													#generate v random
		#l = int(random.random()*1500 + 64)		
		l = 1560			#max packet lenth
		fC = int((math.pow(di,c) - 1) / ( di - 1 ))							#calc f(c)
		fcniC = math.log(1+(di - 1)*( l + fC ),di)							#calc f-1(x)
		dertaCL = math.ceil(fcniC - c) - 1									#calc derta(c,l)
		fCPlusDerta = (math.pow(di,c + dertaCL) - 1) / ( di - 1 )			#calc f(c+derta(c,l))
		fCPlusDertaPlus1 = (math.pow(di,c + dertaCL + 1) - 1) / ( di - 1 ) 	#clac f(c+derta(c,l)+1)
		pdCL = (l + fC - fCPlusDerta) / (fCPlusDertaPlus1 - fCPlusDerta) 	#calc Pd(c,l)
		err = (float(fC) - sumL + 1)/sumL*100.0
		sumL = sumL + l
		if v <= pdCL:
			c = c + dertaCL + 1
		else :
			c = c + dertaCL	
		if dertaCL < 1 and c % 50 ==0:
			print
			print
			print "= = = =","di =",di,"= = = = Plut depth =",D,"= = = = = = = = = ="
			print "="
			print "= Magic Number =",fC
			print "="
			print "= Counter Width =",fC.bit_length()+1
			print "="
			break
	getPC(c, di)

main(di)










