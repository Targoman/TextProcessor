FROM alpine:3.7
LABEL maintainers "S.Mehran M.ziabary <zaiabry@targoman.com>"

WORKDIR /tmp

RUN apk update && apk upgrade \
    && apk add --no-cache bash sed grep coreutils qt5-qtbase zlib libxml2 \
    && apk add --virtual .build-dependencies --no-cache gcc g++ make qt5-qtbase-dev zlib-dev libxml2-dev \
    && ln -s /lib/libz.so /usr/lib/ \
    && wget -qO- https://github.com/Targoman/ISO639/archive/v1.0.tar.gz         | tar xvz \
    && wget -qO- https://github.com/Targoman/TargomanCommon/archive/v1.0.tar.gz | tar xvz \
    && wget -qO- https://github.com/Targoman/TextProcessor/archive/v1.0.tar.gz  | tar xvz \
    && wget -qO- https://github.com/Targoman/qjsonrpc/archive/v1.1.0.tar.gz     | tar xvz \
    && mkdir -p ~/local/include \
    && cp ISO639-1.0/ISO639.h ~/local/include \
    && cd qjsonrpc-1.1.0 && ./buildAndTest.sh full release && make install && cd .. \
    && cd TargomanCommon-1.0 && ./buildAndTest.sh full release && make install && cd .. \
    && cd TextProcessor-1.0  && ./buildAndTest.sh full release && make install && cd .. \
    && mv ~/local/bin/* /usr/bin \
    && mv ~/local/lib/* /usr/lib \
    && mv ~/local/conf/* /etc/E4MT \
    && apk del .build-dependencies \
    && rm -rf /tmp/* \

COPY ./scripts/E4MT.server.conf ./scripts/tsa.ini /etc/E4MT/

EXPOSE 10000

ENTRYPOINT [ "E4MT", "-c","/etc/E4MT/E4MT.server.conf","-l", "en", "-m", "Server", "--admin-mode", "LegacyTcp" ]
