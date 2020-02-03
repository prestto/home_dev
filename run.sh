#!/bin/bash
function run_docker_env {
    echo "running docker build"
    docker-compose --project-dir . -f docker/docker-compose.yml up
}

function usage {
        echo "Usage: $0 <ACTION>"
        echo "Parameters :"
        echo " - ACTION values :"
        echo "   * dev                      - Launching an enviromane containing gitlab and open project."
}


# Checking parameters and Env

if [[ "$1" == "" ]]; then
   echo "Missing arguments."
   usage
   exit 1
fi

# if sudo then we are not running in a docker
# run before each run to ensure no pyc are used
CAN_I_RUN_SUDO=$(sudo -n uptime 2>&1|grep "load"|wc -l)
if [ ${CAN_I_RUN_SUDO} -gt 0 ]
then
    nicecho "normal" "removing pyc files"
    sudo find . -name "*.pyc" -exec rm -f {} \;
fi

case "$1" in
        dev)
                run_docker_env
                ;;
        *)
                echo "Unvalid environment detected (${1})"
                usage
                exit 1
                ;;
esac
