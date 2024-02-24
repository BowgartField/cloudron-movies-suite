# build stage
FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4

RUN mkdir -p /app/code/jellyseerr

RUN echo "**** install packages ****" && \
    cd /app/code && \
    git clone https://github.com/Fallenbagel/jellyseerr.git && cd jellyseerr && git checkout main && \
    CYPRESS_INSTALL_BINARY=0 yarn install --frozen-lockfile --network-timeout 1000000 && \
    echo "**** build jellyseerr ****" && \
    yarn run build;

RUN ln -s /app/code/jellyseerr/config /app/data 

CMD [ "yarn","--cwd","/app/code/jellyseerr","start" ]