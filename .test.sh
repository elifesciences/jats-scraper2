#!/bin/bash

set -e # everything must pass

export PYTHONPATH="src"

pyflakes src/

# run tests
args="$@"
module=""
if [ ! -z "$args" ]; then
    module=".$args"
fi
green src"$module" --run-coverage --failfast

# run coverage test
# only report coverage if we're running a complete set of tests
if [ -z "$module" ]; then
    # is only run if tests pass
    covered=$(coverage report | grep TOTAL | awk '{print $6}' | sed 's/%//')
    if [ $covered -lt 97 ]; then
        coverage html
        echo
        echo -e "\e[31mFAILED\e[0m this project requires at least 97% coverage"
        echo
        exit 1
    fi
fi
