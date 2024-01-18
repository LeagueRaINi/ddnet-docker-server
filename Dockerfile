FROM debian:11

ARG BUILD_TYPE=Release
ARG GIT_VERSION_TAG=17.4.2

RUN apt-get update && apt-get install -y build-essential \
    cargo \
    rustc \
    cmake \
    ninja-build \
    git \
    python3 \
    ca-certificates \
    libcurl4-openssl-dev \
    libpng-dev \
    libsqlite3-dev \
    libwebsockets-dev \
    libminiupnpc-dev 

WORKDIR /ddnet-server

RUN git clone --depth 1 --recurse --branch "$GIT_VERSION_TAG" https://github.com/ddnet/ddnet.git .
RUN mkdir build && cd build && cmake .. \
        -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
        -DPREFER_BUNDLED_LIBS=OFF \
        -DWEBSOCKETS=ON \
        -DMYSQL=OFF \
        -DTEST_MYSQL=OFF \
        -DAUTOUPDATE=OFF \
        -DCLIENT=OFF \
        -DVIDEORECORDER=OFF \
        -DDOWNLOAD_GTEST=OFF \
        -DDEV=OFF \
        -DUPNP=ON \
        -DVULKAN=OFF \
        -GNinja \
    && ninja

FROM debian:11

RUN apt-get update && apt-get install -y libwebsockets16 \
    miniupnpc \
    curl \
    sqlite3

WORKDIR /ddnet-server
COPY --from=0 /ddnet-server/build/DDNet-Server .
COPY --from=0 /ddnet-server/build/data data

CMD ["/ddnet-server/DDNet-Server"]
