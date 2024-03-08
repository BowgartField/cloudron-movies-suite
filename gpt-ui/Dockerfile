# build stage
FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4 AS app_base

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

RUN . /scripts/checkout_src_version.sh
# Copy source to app
RUN mkdir -p /app/code
RUN cp -r /src/text-generation-webui /app/code/text-generation-webui

# CPU [Everyone can join in, as long as they have the patience.]
# Base
FROM app_base AS app_cpu
# Install pytorch for CPU
RUN pip3 install torch==2.1.* torchvision==0.16.* torchaudio==2.1.* \
    --index-url https://download.pytorch.org/whl/cpu

RUN ls -la /src
RUN ls -la /app/code

# Install oobabooga/text-generation-webui
RUN pip3 install -r /app/code/text-generation-webui/requirements_cpu_only.txt

# Extended
FROM app_cpu AS app_cpu_x
# Install extensions
RUN chmod +x /scripts/build_extensions.sh && \
    . /scripts/build_extensions.sh


# COMMON
FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4 AS run_base
# Runtime pre-reqs
RUN apt-get update && apt-get install --no-install-recommends -y \
    python3-venv python3-dev git
# Copy app and src
COPY --from=app_base /app/code /app/code
COPY --from=app_base /src /src
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

# Run
ENTRYPOINT ["/scripts/docker-entrypoint.sh"]

RUN ls -s /app/code/text-generation-webui/characters /app/data/config/characters
RUN ls -s /app/code/text-generation-webui/loras /app/data/config/loras
RUN ls -s /app/code/text-generation-webui/models /app/data/config/models
RUN ls -s /app/code/text-generation-webui/presets /data/config/presets
RUN ls -s /app/code/text-generation-webui/prompts /app/data/config/prompts
RUN ls -s /app/code/text-generation-webui/training /app/data/config/training

# CPU
# Base
FROM run_base AS base-cpu
# Copy venv
COPY --from=app_cpu $VIRTUAL_ENV $VIRTUAL_ENV
# Variant parameters
RUN echo "CPU Base" > /variant.txt
ENV EXTRA_LAUNCH_ARGS=""
CMD ["python3", "/app/code/text-generation-webui/server.py"]
