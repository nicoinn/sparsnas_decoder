all:
	g++ -o sparsnas_decode -O3 sparsnas_decode.cpp

clean: 
	rm sparsnas_decode
