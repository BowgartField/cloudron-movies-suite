FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4

RUN apt-get update -y && \
    apt install -y curl sqlite3 dpkg

RUN mkdir -p /app/code/readarr
WORKDIR /app/code

RUN wget --content-disposition "http://readarr.servarr.com/v1/update/develop/updatefile?os=linux&runtime=netcore&arch=x64" && \
    tar -xvzf Readarr*.linux*.tar.gz -C /app/code/readarr

COPY start.sh /app/code/

CMD [ "/app/code/start.sh" ]