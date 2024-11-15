FROM cloudron/base:5.0.0@sha256:6bec2b5246567ef8b5b13ca0af756e2e596941e440d76b46635211cd84383922

ARG UNRAR_VERSION=6.2.12

RUN mkdir -p /app/code

RUN apt upgrade -y
RUN sudo add-apt-repository ppa:jcfp/sab-addons
RUN apt-get update -y
RUN apt-get install -y  par2-turbo python3.12-venv

RUN echo "**** install unrar from source ****" && \
  mkdir /tmp/unrar && \
  curl -o /tmp/unrar.tar.gz -L "https://www.rarlab.com/rar/unrarsrc-${UNRAR_VERSION}.tar.gz" && \  
  tar -xf /tmp/unrar.tar.gz -C /tmp/unrar --strip-components=1 && \
  cd /tmp/unrar && \
  make -j ${MAKE_JOBS} && \
  install -v -m755 unrar /usr/bin

WORKDIR /app/code

RUN git config --global core.compression 0

RUN echo "**** install packages ****" && \
    git clone --depth 1 --branch master https://github.com/sabnzbd/sabnzbd 
    #&& cd sabnzbd &&  git fetch --unshallow && git pull --all

RUN echo "**** build sabnzbd ****" && \
    cd sabnzbd && python3 -m venv . && \
    ./bin/pip install -r requirements.txt -U  &&\
    echo "**** build sab translations ****" && \
   ./bin/python tools/make_mo.py
    
# COPY sabnzbd.ini /app/data/config/sabnzbd/sabnzbd.ini

CMD [ "/app/code/sabnzbd/bin/python", "-OO", "/app/code/sabnzbd/SABnzbd.py", "--config-file", "/app/data/config/sabnzbd/sabnzbd.ini","-b" ,"0", "-s", "0.0.0.0:8080"]
