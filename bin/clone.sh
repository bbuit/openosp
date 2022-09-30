#!/bin/bash


set -uxo

repo=${1:-https://github.com/bbuit/openoscar.git}
branch=${2:-release/Oscar-BC-15}

echo "Cloning oscar from bitbucket"
if [ -d "./docker/oscar/oscar" ]; then
    echo "already cloned"
else
    git clone $repo docker/oscar/oscar
    cd docker/oscar/oscar
    git checkout $branch
fi
