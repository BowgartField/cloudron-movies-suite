# build stage
FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4

# args
ARG NZBGET_RELEASE=develop
ARG UNRAR_VERSION=6.2.12
ARG MAKE_JOBS=1

RUN echo "**** update host ****" && \
    apt-get update -y && \
    echo "**** install build packages ****" && \
    apt install -y autoconf automake g++ gcc git libxml2-dev libxslt-dev make ncurses-dev openssl autotools-dev libicu-dev libbz2-dev libboost-all-dev curl pkgconf

RUN wget https://boostorg.jfrog.io/artifactory/main/release/1.84.0/source/boost_1_84_0.tar.gz && \
    tar xf boost_1_84_0.tar.gz && \
    cd boost_1_84_0 && \
    ./bootstrap.sh --prefix=/usr/ && \
    ./b2 install
    
RUN echo "**** build nzbget ****" && \
    mkdir -p  /app/code/nzbget && \
    git clone https://github.com/nzbgetcom/nzbget.git nzbget && \
    cd nzbget/ && \
    git checkout ${NZBGET_RELEASE}

WORKDIR /nzbget

RUN autoreconf --install
RUN ./configure bindir='${exec_prefix}'

RUN make -j ${MAKE_JOBS}
RUN make prefix=/app/code/nzbget install
# RUN sed -i \
#     -e "s#^MainDir=.*#MainDir=/downloads#g" \
#     -e "s#^ScriptDir=.*#ScriptDir=$\{MainDir\}/scripts#g" \
#     -e "s#^WebDir=.*#WebDir=$\{AppDir\}/webui#g" \
#     -e "s#^ConfigTemplate=.*#ConfigTemplate=$\{AppDir\}/webui/nzbget.conf.template#g" \
#     -e "s#^UnrarCmd=.*#UnrarCmd=unrar#g" \
#     -e "s#^SevenZipCmd=.*#SevenZipCmd=7z#g" \
#     -e "s#^CertStore=.*#CertStore=$\{AppDir\}/cacert.pem#g" \
#     -e "s#^CertCheck=.*#CertCheck=yes#g" \
#     -e "s#^DestDir=.*#DestDir=$\{MainDir\}/completed#g" \
#     -e "s#^InterDir=.*#InterDir=$\{MainDir\}/intermediate#g" \
#     -e "s#^LogFile=.*#LogFile=$\{MainDir\}/nzbget.log#g" \
#     -e "s#^AuthorizedIP=.*#AuthorizedIP=127.0.0.1#g" \
#    /app/code/nzbget/share/nzbget/nzbget.config
RUN  mv /app/code/nzbget/share/nzbget/webui /app/code/nzbget/ && \
  cp /app/code/nzbget/share/nzbget/nzbget.conf /app/code/nzbget/webui/nzbget.conf.template && \
  ln -s /usr/bin/7z /app/code/nzbget/7za && \
  ln -s /usr/bin/unrar /app/code/nzbget/unrar && \
  cp /nzbget/pubkey.pem /app/code/nzbget/pubkey.pem && \
  curl -o /app/code/nzbget/cacert.pem -L "https://curl.se/ca/cacert.pem" && \
  echo "**** install unrar from source ****" && \
  mkdir /tmp/unrar && \
  curl -o /tmp/unrar.tar.gz -L "https://www.rarlab.com/rar/unrarsrc-${UNRAR_VERSION}.tar.gz" && \  
  tar xf /tmp/unrar.tar.gz -C /tmp/unrar --strip-components=1 && \
  cd /tmp/unrar && \
  make -j ${MAKE_JOBS} && \
  install -v -m755 unrar /usr/bin

# runtime stage
# FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4
ARG NZBGET_RELEASE=develop

# labels
LABEL org.opencontainers.image.description="NZBGet from nzbget.com, version ${NZBGET_RELEASE}"
LABEL org.opencontainers.image.source="https://github.com/nzbgetcom/nzbget"
LABEL maintainer="nzbget@nzbget.com" 

ENV TERM linux
RUN \
  echo "**** install packages ****" && \
  apt-get update -y && \
  apt install -y libxml2 libxslt1-dev openssl p7zip python3 && \
  ln -sf /usr/bin/python3 /usr/bin/python && \
  echo "**** cleanup ****" && \
  rm -rf /root/.cache /root/.cargo /tmp/*

# COPY --from=build /usr/bin/unrar /usr/bin/unrar
# COPY --from=build /app/code/nzbget/ /app/code/nzbget/

COPY nzbget.conf /app/data/config/nzbget/nzbget.conf

COPY start.sh /app/code/

CMD [ "/app/code/start.sh" ]

# ADD entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh && \
#   echo "**** create non-root user ****" && \
#   adduser -G users -D -u 1000 -h /config -s /bin/sh user && \
#   mkdir -p /config && \
#   mkdir -p /downloads && \
#   chown -R user:users /app /config /downloads
# ENTRYPOINT [ "/entrypoint.sh" ]
