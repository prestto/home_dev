#!/bin/bash
function run_docker_gitlab {
    echo "running docker GITLAB build for GITLAB"
    docker-compose --project-directory . -f gitlab/docker-compose.yml up -d
}

function run_docker_taiga {
    echo "running docker TAIGA build for GITLAB"
    docker-compose --project-directory . -f taiga/docker-compose.yml up
}

function run_docker_gitlab_raspberry {
    echo "running docker GITLAB build for RASPBERRY"
    docker-compose --project-directory . -f gitlab/docker-compose.yml -f gitlab/docker-compose-raspberry.yml up -d
}

function run_docker_taiga_raspberry {
    echo "running docker TAIGA build for RASPBERRY"
    docker-compose --project-directory . -f taiga/docker-compose.yml up
}

function stop {
    echo "Stopping GITLAB build for RASPBERRY"
    docker-compose --project-directory . -f gitlab/docker-compose.yml -f gitlab/docker-compose-raspberry.yml stop
}

function usage {
        echo "Usage: $0 <ACTION>"
        echo "Parameters :"
        echo " - ACTION values :"
        echo "   * git                                  - Launch git for linux."
        echo "   * taiga                                - Launch taiga for linux"
        echo "   * git_raspberry                        - Launch git for raspberry"
        echo "   * taiga_raspberry                      - Launch taiga for raspberry"
        echo "   * stop                                 - Stop git for raspberry"
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
        taiga)
                run_docker_taiga
                ;;
        git_raspberry)
                run_docker_gitlab_raspberry
                ;;
        taiga_raspberry)
                run_docker_taiga_raspberry
                ;;
        stop)
                stop
                ;;
        *)
                echo "Unvalid environment detected (${1})"
                usage
                exit 1
                ;;
esac
