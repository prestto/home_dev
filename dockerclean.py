#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from subprocess import run, PIPE

def run_cmd(cmd, exit_if_error=True):

    response = run(cmd, shell=True, stdout=PIPE, stderr=PIPE)
    if response.returncode != 0 and exit_if_error:
        print("  Errors with command '" + cmd + "' : \n  stdout: [[" + str(response.stdout) + "]]\n  stderr: [["+ str(response.stderr) + "]]")

    return response


def get_docker_list(cmd):

    response = run_cmd(cmd)
    docker_list = response.stdout.decode('utf-8').splitlines()
    if '' in docker_list:
        docker_list.remove('')
    return docker_list


if __name__ == '__main__':

    # Digglerz Header ;)
    print(" *************************************************************************** ")
    print("  _____  _             _                 ______         _                    ")
    print(" |  __ \(_)           | |               |  ____|       | |                   ")
    print(" | |  | |_  __ _  __ _| | ___ _ __ ____ | |__ __ _  ___| |_ ___  _ __ _   _  ")
    print(" | |  | | |/ _` |/ _` | |/ _ \ '__|_  / |  __/ _` |/ __| __/ _ \| '__| | | | ")
    print(" | |__| | | (_| | (_| | |  __/ |   / /  | | | (_| | (__| || (_) | |  | |_| | ")
    print(" |_____/|_|\__, |\__, |_|\___|_|  /___| |_|  \__,_|\___|\__\___/|_|   \__, | ")
    print("            __/ | __/ |                                                __/ | ")
    print("           |___/ |___/                                                |___/  ")
    print(" *************************************************************************** ")
    print(" *                              Docker Cleaner                             * ")
    print(" *************************************************************************** ")

    print("* Stopping all running containers ...")

    containers = get_docker_list("docker ps -q")

    for container in containers:
        print("  stopping container '" + container + "'")
        response = run_cmd("docker stop -t 5 " + container, False)
        if response.returncode != 0:
            print("  > not stopping, force killing it !")
            run_cmd("docker kill" + container)
    
    print("* Removing all containers ...")
    containers = get_docker_list("docker ps -a -q")
    for container in containers:
        print("  removing container '" + container + "'")
        response = run_cmd("docker rm -f -v " + container)

    print("* Removing all images ...")
    images = get_docker_list("docker images -a -q")
    images_retry = []
    for image in images:
        print("  removing image '" + image + "'")
        response = run_cmd("docker rmi -f " + image)
        if response.returncode != 0:
          images_retry.append(image)

    # Retry might be needed as all children of an image must be deleted first before removing the parent.
    if len(images_retry) > 0:
      print("* Retry - removing all images ...")
      for image in images_retry:
        print("  removing image '" + image + "'")
        response = run_cmd("docker rmi -f " + image)

    print("* Pruning ...")
    run_cmd("docker volume prune -f")

