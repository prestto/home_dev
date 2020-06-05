#!/bin/bash
function run_docker_gitlab {
    ARCH=$(arch)

    case $ARCH in
            armv7l)
                    echo "ARM system detected."
                    echo "running docker GITLAB build."
                    docker-compose --project-directory . -f gitlab/docker-compose.yml -f gitlab/docker-compose-raspberry.yml up -d
                    ;;
            x86_64)
                    echo "Linux x86_64 system detected."
                    echo "running docker GITLAB build for GITLAB"
                    docker-compose --project-directory . -f gitlab/docker-compose.yml up -d
                    ;;
            *)
                    echo "Unrecognized architecture ($ARCH)"
                    exit 1
                    ;;
    esac
}

function stop {
    echo "Stopping GITLAB build for RASPBERRY"
    docker-compose --project-directory . -f gitlab/docker-compose.yml -f gitlab/docker-compose-raspberry.yml stop
}

function kill80 {
    echo "Killing processes on port 80."
    PROCESSES=$(sudo lsof -t -i tcp:80 -s tcp:listen)
    
    if [[ $PROCESSES ]]
    then
        echo "killing processes:"
        echo $PROCESSES
        sudo lsof -t -i tcp:80 -s tcp:listen | sudo xargs kill
    else
        echo "nothing to kill"
    fi
}

function usage {
        echo "Usage: $0 <ACTION>"
        echo "Parameters :"
        echo " - ACTION values :"
        echo "   * git                                  - Launch git for linux."
        echo "   * stop                                 - Stop git for raspberry"
        echo "   * kill80                               - Kill process running on port 80."
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
    echo "normal" "removing pyc files"
    sudo find . -name "*.pyc" -exec rm -f {} \;
fi

case "$1" in
        git)
                run_docker_gitlab
                ;;
        stop)
                stop
                ;;
        kill80)
                kill80
                ;;
        *)
                echo "Unvalid environment detected (${1})"
                usage
                exit 1
                ;;
esac
