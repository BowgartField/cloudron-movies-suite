FROM --platform=amd64 cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4

RUN apt-get update -y && \
    apt install -y curl sqlite3 dpkg 7zip python3-dev python3-pip python3-distutils unrar unzip

# Create necessary directories in /app/config
RUN mkdir -p /app/config/data /app/config/logs /app/config/config

WORKDIR /app/code

RUN wget --content-disposition "https://github.com/morpheus65535/bazarr/releases/latest/download/bazarr.zip" && \
    unzip bazarr.zip -d /app/code/bazarr && \
    rm bazarr.zip

RUN cd /app/code/bazarr && \
    python3 -m pip install -r requirements.txt

# Copy configuration file
COPY config.json /app/code/bazarr/config.json

COPY start.sh /app/code/
RUN chown -R cloudron:cloudron /app/code/bazarr /app/config

CMD [ "/app/code/start.sh" ]