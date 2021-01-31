#!/bin/bash
docker run -e WORKER_NAME=farm1 \
    --name farm \
    --runtime nvidia --gpus all \
    --restart unless-stopped \
    -e ETH_WALLET=0x18E02B0032c5C1aBc2A92c97FE149028e8eBAfdc \
    -P -d ethminer
