FROM alpine:3.18.2 as builder

RUN apk add --no-cache git make g++ boost-dev openssl-dev db-dev miniupnpc-dev zlib-dev
RUN addgroup --gid 1000 jump
RUN adduser --disabled-password --gecos "" --home /jump --ingroup jump --uid 1000 jump

USER jump

RUN git clone git@github.com:Jumperbillijumper/jumpcoin.git /jump/jumpcoin
WORKDIR /jump/jumpcoin
RUN git checkout tags/2.0
WORKDIR /jump/jumpcoin/src
RUN make -f makefile.unix

FROM alpine:3.18.2

RUN apk add --no-cache boost-dev db-dev miniupnpc-dev zlib-dev bash curl
RUN addgroup --gid 1000 jump
RUN adduser --disabled-password --gecos "" --home /jump --ingroup jump --uid 1000 jump

USER jump
COPY --from=builder /jump /jump
COPY ./entrypoint.sh /

RUN mkdir /jump/.jumpcoin
VOLUME /jump/.jumpcoin
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 4555/tcp
EXPOSE 4444/tcp
EXPOSE 14555/tcp
EXPOSE 14444/tcp
