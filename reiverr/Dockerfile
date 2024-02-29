FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4

RUN apt-get update -y
RUN mkdir -p /app/code

RUN echo "**** install packages ****" && \
    cd /app/code && \
    git clone https://github.com/aleksilassila/reiverr && cd reiverr && \
    yarn install && \
    echo "**** build reiverr ****" && \
    yarn build;
    
RUN ln -s /app/code/reiverr/config /app/data 

CMD [ "yarn","--cwd","/app/code/reiverr", "deploy" ]
