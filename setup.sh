#!/bin/bash
ETH_WALLET=0xF65F7b0A01fE59DF50e284Fd21cAEb8Ce5E8746D
WORKER_NAME=*

if grep -Fxq "$FILENAME" ~/.profile; then
    echo "Wallet address and worker have already been added. Skipping..."
else
    echo "export ETH_WALLET=${ETH_WALLET}" >>~/.profile
    echo "export WORKER_NAME=${WORKER_NAME}" >>~/.profile
    source ~/.profile
fi

git submodule update --init --recursive
docker build -t ethminer .
