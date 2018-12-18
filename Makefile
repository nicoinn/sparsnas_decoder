all:
	g++ -o sparsnas_decode -O3 -static sparsnas_decode.cpp

clean: 
	rm sparsnas_decode
