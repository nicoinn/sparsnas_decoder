#Compile RTL_SDR --- based on https://github.com/bemasher/rtl-sdr
FROM alpine as RTLSDR_BUILD_ENV

RUN apk add --no-cache musl-dev gcc make cmake pkgconf git libusb-dev

WORKDIR /usr/local/
RUN git clone git://git.osmocom.org/rtl-sdr.git && cd rtl-sdr && git checkout tags/0.6.0 -b compile

RUN mkdir /usr/local/rtl-sdr/build
WORKDIR /usr/local/rtl-sdr/build
RUN cmake ../ -DDETACH_KERNEL_DRIVER=ON -DCMAKE_C_FLAGS="-static-libstdc++"
RUN make
RUN make install

#Compile Sparnas_decoder
FROM alpine as SPARSNAS_BUILD_ENV

RUN apk add --update --no-cache \
    g++ \
    make

COPY Makefile /build/
COPY sparsnas_decode.cpp /build/

WORKDIR /build
RUN make


#Assemble the final image
FROM alpine

RUN apk add --no-cache libusb python2

COPY --from=RTLSDR_BUILD_ENV /usr/local/rtl-sdr/build/src/rtl_sdr /usr/bin/
COPY --from=RTLSDR_BUILD_ENV /usr/local/rtl-sdr/build/src/librtlsdr.so.0 /usr/local/lib/
COPY --from=SPARSNAS_BUILD_ENV /build/sparsnas_decode /usr/bin/
COPY run_sparsnas.sh /usr/bin
COPY sensor_data_forwarder/Sensor_record.py /sensor_data_forwarder/
COPY sensor_data_forwarder/Reporters.py /sensor_data_forwarder/
COPY sensor_data_forwarder/sparsnas_forwarder.py /sensor_data_forwarder/

RUN chmod 755 /usr/bin/sparsnas_decode && chmod 755 /usr/bin/rtl_sdr

ENTRYPOINT ["/usr/bin/run_sparsnas.sh"]
