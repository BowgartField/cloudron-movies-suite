# build stage
FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4

# Pre-reqs
RUN apt-get update && apt-get install --no-install-recommends -y \
 git vim build-essential python3-dev python3-venv python3-pip

# Instantiate venv and pre-activate
RUN pip3 install virtualenv
RUN virtualenv /venv
ENV VIRTUAL_ENV=/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip3 install --upgrade pip setuptools
# Copy and enable all scripts
COPY ./scripts /scripts
RUN chmod +x /scripts/*

RUN git clone https://github.com/oobabooga/text-generation-webui /src/text-generation-webui

# RUN . /scripts/checkout_src_version.sh
# Copy source to app
RUN mkdir -p /app/code
RUN cp -r /src/text-generation-webui /app/code/text-generation-webui

# Install pytorch for CPU
RUN pip3 install torch==2.1.* torchvision==0.16.* torchaudio==2.1.* \
    --index-url https://download.pytorch.org/whl/cpu

# Install oobabooga/text-generation-webui
RUN pip3 install -r /app/code/text-generation-webui/requirements_cpu_only.txt

# Install extensions
RUN chmod +x /scripts/build_extensions.sh && \
    . /scripts/build_extensions.sh

# Runtime pre-reqs
RUN apt-get update && apt-get install --no-install-recommends -y \
    python3-venv python3-dev git

# Instantiate venv and pre-activate
ENV VIRTUAL_ENV=/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
# Finalise app setup
WORKDIR /app/code
# EXPOSE 7860
# EXPOSE 5000
# EXPOSE 5005
# Required for Python print statements to appear in logs
ENV PYTHONUNBUFFERED=1
# Force variant layers to sync cache by setting --build-arg BUILD_DATE
ARG BUILD_DATE
ENV BUILD_DATE=$BUILD_DATE
RUN echo "$BUILD_DATE" > /build_date.txt
ARG VERSION_TAG
ENV VERSION_TAG=$VERSION_TAG
RUN echo "$VERSION_TAG" > /version_tag.txt
# Copy and enable all scripts
COPY ./scripts /scripts
RUN chmod +x /scripts/*

WORKDIR /app/code/text-generation-webui
RUN mkdir -p /tmp/config/characters
RUN mv characters/* /tmp/config/characters \
    && mv loras /tmp/config \
    &&	mv models /tmp/config \
    &&	mv presets /tmp/config \
    &&	mv prompts /tmp/config \ 
    &&	mv training /tmp/config \
    &&  mv extensions /tmp/config;

RUN rm -r characters;
 
RUN ln -s /app/data/characters /app/code/text-generation-webui/characters \
    && ln -s /app/data/loras /app/code/text-generation-webui/loras \
    && ln -s /app/data/models /app/code/text-generation-webui/models \
    && ln -s /app/data/presets /app/code/text-generation-webui/presets \
    && ln -s /app/data/prompts /app/code/text-generation-webui/prompts \
    && ln -s /app/data/training /app/code/text-generation-webui/training \
    && ln -s /app/data/extensions /app/code/text-generation-webui/extensions \
    && ln -s /app/data/logs /app/code/text-generation-webui/logs \
    && ln -s /app/data/cache /app/code/text-generation-webui/cache;

# Variant parameters
RUN echo "CPU Base" > /variant.txt

ENV PYTHONUNBUFFERED=1

# Run
CMD ["/scripts/start.sh"]
