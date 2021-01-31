FROM nvidia/cuda:11.1.1-devel-ubuntu20.04 AS build

WORKDIR /

# Package and dependency setup
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    software-properties-common \
    git \
    cmake \
    build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add source files
COPY . /ethminer
WORKDIR /ethminer

# Build. Use all cores.
RUN mkdir build; \
    cd build; \
    cmake .. -DETHASHCUDA=ON -DAPICORE=ON -DETHASHCL=OFF -DBINKERN=OFF; \
    cmake --build . -- -j; \
    make -j$(nproc) install;

FROM nvidia/cuda:11.1.1-base-ubuntu20.04

# Copy only executable from build
COPY --from=build /usr/local/bin/ethminer /usr/local/bin/

# Prevent GPU overheading by stopping in 90C and starting again in 60C
ENV GPU_TEMP_STOP=90
ENV GPU_TEMP_START=60

# These need to be given in command line.
ENV ETH_WALLET=0x00
ENV WORKER_NAME="none"
ENV ETHMINER_API_PORT=3000
ENV GPU_INDEX=0

EXPOSE ${ETHMINER_API_PORT}

# Start miner. Note that wallet address and worker name need to be set
# in the container launch.
CMD ["bash", "-c", "/usr/local/bin/ethminer -U \
    # --farm-retries 10 --retry-delay 2 --farm-recheck 200 \
    --api-port ${ETHMINER_API_PORT} \
    --HWMON 2 --tstart ${GPU_TEMP_START} --tstop ${GPU_TEMP_STOP} --exit \
    --cuda-devices ${GPU_INDEX} \
    -P stratums://$ETH_WALLET.$WORKER_NAME@eth-sg.flexpool.io:5555 \
    -P stratums://$ETH_WALLET.$WORKER_NAME@eth-us-west.flexpool.io:5555 \
    -P stratums://$ETH_WALLET.$WORKER_NAME@asia1.ethermine.org:5555 \
    -P stratums://$ETH_WALLET.$WORKER_NAME@us1.ethermine.org:5555 \
    -P stratums://$ETH_WALLET.$WORKER_NAME@asia.sparkpool.com:3333"]
