FROM alpine:3.19 as builder

RUN apk add --no-cache git make autoconf pkgconfig automake g++ libtool db-dev boost-dev openssl-dev libevent-dev
RUN addgroup --gid 1000 jump
RUN adduser --disabled-password --gecos "" --home /jump --ingroup jump --uid 1000 jump

USER jump

RUN git clone https://github.com/Jumperbillijumper/jumpcoin.git /jump/jumpcoin/jumpcoin
WORKDIR /jump/jumpcoin
RUN wget http://download.oracle.com/berkeley-db/db-6.2.32.tar.gz
RUN tar -xzf db-6.2.32.tar.gz

WORKDIR /jump/jumpcoin/jumpcoin
RUN git checkout tags/2.0
RUN chmod +x autogen.sh configure.ac
RUN ./autogen.sh
RUN ./configure BDB_LIBS="-L/jump/jumpcoin/db-6.2.32/build_unix -ldb_cxx" BDB_CFLAGS="-I/jump/jumpcoin/db-6.2.32/build_unix"
RUN make

FROM alpine:3.19

RUN apk add --no-cache boost-dev db-dev miniupnpc-dev zlib-dev bash curl
RUN addgroup --gid 1000 jump
RUN adduser --disabled-password --gecos "" --home /jump --ingroup jump --uid 1000 jump

USER jump
COPY --from=builder /jump /jump
COPY ./entrypoint.sh /

RUN mkdir /jump/.jumpcoin
VOLUME /jump/.jumpcoin
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 31242/tcp
EXPOSE 31240/tcp
