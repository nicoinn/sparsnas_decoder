FROM alpine as BUILD_ENV

RUN apk add --update --no-cache \
    g++ \
    cmake \
    make

COPY CMakeLists.txt /build/
COPY main.cpp /build/

RUN cd /build && cmake ./ && make 

FROM alpine

COPY --from=BUILD_ENV /build/sparsnas_decode /usr/bin/

ENTRYPOINT ["/usr/bin/sparsnas_decode"]
