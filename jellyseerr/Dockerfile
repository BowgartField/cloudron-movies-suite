# build stage
FROM cloudron/base:5.0.0@sha256:6bec2b5246567ef8b5b13ca0af756e2e596941e440d76b46635211cd84383922 AS BUILD_IMAGE

WORKDIR /app

RUN npm install --global pnpm

RUN git clone https://github.com/Fallenbagel/jellyseerr.git && cd jellyseerr

WORKDIR /app/jellyseerr

#COPY package.json pnpm-lock.yaml postinstall-win.js ./
RUN CYPRESS_INSTALL_BINARY=0 pnpm install --frozen-lockfile

RUN pnpm build

# remove development dependencies
RUN pnpm prune --prod --ignore-scripts

RUN rm -rf src server .next/cache

# RUN echo "**** install packages ****" && \
#     cd /app/code && \
#     npm install -g pnpm && \
#     git clone https://github.com/Fallenbagel/jellyseerr.git && cd jellyseerr && git checkout main && \
#     CYPRESS_INSTALL_BINARY=0 pnpm install --frozen-lockfile --network-timeout 1000000 && \
#     echo "**** build jellyseerr ****" && \
#     pnpm build;

FROM cloudron/base:5.0.0@sha256:6bec2b5246567ef8b5b13ca0af756e2e596941e440d76b46635211cd84383922

WORKDIR /app/code/jellyseerr
RUN npm install -g pnpm
RUN mkdir -p /app/code/jellyseerr
COPY --from=BUILD_IMAGE /app/jellyseerr /app/code/jellyseerr
RUN ln -s /app/code/jellyseerr/config /app/data 

CMD [ "pnpm","start" ]