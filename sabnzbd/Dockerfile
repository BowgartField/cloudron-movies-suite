FROM cloudron/base:5.0.0@sha256:6bec2b5246567ef8b5b13ca0af756e2e596941e440d76b46635211cd84383922

RUN apt-get update -y
RUN mkdir -p /app/code

RUN sudo add-apt-repository ppa:jcfp/sab-addons
RUN apt-get update
RUN apt-get install par2-turbo

RUN echo "**** install unrar from source ****" && \
  mkdir /tmp/unrar && \
  curl -o /tmp/unrar.tar.gz -L "https://www.rarlab.com/rar/unrarsrc-${UNRAR_VERSION}.tar.gz" && \  
  tar xf /tmp/unrar.tar.gz -C /tmp/unrar --strip-components=1 && \
  cd /tmp/unrar && \
  make -j ${MAKE_JOBS} && \
  install -v -m755 unrar /usr/bin

RUN echo "**** build sab translations ****" && \
  python3 tools/make_mo.py

RUN echo "**** install packages ****" && \
    cd /app/code && \
    git clone https://github.com/sabnzbd/sabnzbd && cd sabnzbd && \
    echo "**** build sabnzbd ****" && \
    python3 -m pip install -r requirements.txt -U && \
    python3 setup.py install
    
# COPY sabnzbd.ini /app/data/config/sabnzbd/sabnzbd.ini

CMD [ "python3", "-OO", "/app/code/sabnzbd/SABnzbd.py", "--config-file", "/app/data/config/sabnzbd/sabnzbd.ini", "--server", "0.0.0.0:8080"]
