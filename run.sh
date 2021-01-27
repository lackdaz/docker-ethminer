#!/bin/bash
docker run -e WORKER_NAME=farm1 \
    --name farm1 \
    --runtime nvidia --gpus all \
    --restart unless-stopped \
    -e ETH_WALLET=0xF65F7b0A01fE59DF50e284Fd21cAEb8Ce5E8746D \
    -P -d ethminer
