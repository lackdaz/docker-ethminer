#!/bin/bash
docker run --name ethminer --gpus all --restart unless-stopped -e ETH_WALLET -e WORKER_NAME -P -d ethminer
