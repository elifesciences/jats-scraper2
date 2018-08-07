#!/bin/bash
set -e

python=$(which python3.6) # python3.6?
py=${python##*/} # ll: python3.6

# check for exact version of python3
if [ ! -e "venv/bin/$py" ]; then
    echo "could not find venv/bin/$py, recreating venv"
    rm -rf venv
    virtualenv --python=$python venv/
fi

source venv/bin/activate

# link the default (elife) config if no app.cfg file found
if [ ! -e app.cfg ]; then
    echo "* no app.cfg found! using the example settings (elife.cfg) by default."
    ln -s elife.cfg app.cfg
    if [ "$ENVIRONMENT_NAME" = "ci" ]; then
        echo "* share cache between builds for better performance (cache_path)"
        cp app.cfg app.cfg.ci
        sed -i -e 's#cache_path:.*#cache_path: /home/elife#g' app.cfg.ci
        mv app.cfg.ci app.cfg
    fi
fi

if pip list | grep elifetools; then
    pip uninstall -y elifetools
fi

# temporary until connexion library fixes their requirements config
if pip list | grep connexion; then
    pip uninstall -y connexion
fi

pip install -r requirements.txt

. download-api-raml.sh
