#!/bin/sh

rtl_sdr -f 868000000 -s 1024000 -g 40 - | sparsnas_decode
