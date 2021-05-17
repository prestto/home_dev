# Presentation

A quick project to provide an easily reproducable development environment on a raspberry pi.

## Requirements

Gitlab requires at least 2 GB of RAM.  This is a minimum, but frankly with 4GB on a raspberry it's not the fastest, so i would recommend at last this.

If you wish to do more that just an example project, you will also need additional storage.  For the project I've used a 120Gb SSD.  This must be mounted in the fstab (see below), so that it's run on restart of raspberry.

Additionally, if there is a problem with git, or if the raspberry is disconnected, it's practival that gitlab restarts with the raspberry.  A guide for setting this up using init.d is included below.

## Docker

```bash
# deps
sudo apt-get install -y libffi-dev libssl-dev
sudo apt install python3-dev
sudo apt-get install -y python3 python3-pip

sudo apt-get remove docker docker-engine docker.io containerd runc

curl -fsSL https://get.docker.com -o get-docker.sh

sudo sh get-docker.sh

sudo usermod -aG docker tp

# test
docker run hello-world

# docke compose
sudo pip3 install docker-compose

sudo groupadd docker

sudo usermod -aG docker $USER
```

## Mount your SSD

Mounting yous ssd essentially means attaching the filesystem of the ssd to a point in the filesystem of the raspberry.  There are 3 stages to this:

```bash
# to find the disk's UUID
sudo blkid
sudo fdisk -l

# make a mount point
mkdir /media/ssd

# open fstab
nano /etc/fstab

# mount the disk using a command like
UUID=89596814-b32e-446b-ac1c-ecd2daf0d4cd /media/ssd ext4 defaults,nofail 0 0
```

## Run git on startup

The file git-startup must be moved to the folder /etc/init.d/ This will thenn be run on starting the raspberry.

This can be done using the commmand 

```bash
cp /home/pi/projects/home_dev/git-startup /etc/init.d/git-startup
```

## Create an ssl certificate for HTTPS

```bash

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./ssl/private/nginx-selfsigned.key -out ./ssl/certs/nginx-selfsigned.crt

sudo openssl dhparam -out ./ssl/certs/dhparam.pem 2048
```
## Gitlab HTTPS setup

To setup https in gitlab, follow this [guide](https://gitlab.com/gitlab-org/omnibus-gitlab/-/blob/master/doc/settings/nginx.md#enable-https)

```bash

```

## Git

```bash
export GITLAB_HOME=/media/ssd/srv/gitlab

# to reconfigure gitlab as necessary
nohup /opt/gitlab/embedded/bin/runsvdir-start &
sudo gitlab-ctl reconfigure

# to run with docker run
docker run -it -v /media/ssd/srv/gitlab/config:/srv/gitlab -v /media/ssd/srv/gitlab/logs:/var/log/gitlab -v /media/ssd/srv/gitlab/data:/var/opt/gitlab  ulm0/gitlab:12.10.0 /bin/bash
```

## Gitlab runner

To setup a gitlab runner on the pi, unfortunately i cant find a reliable containerized way (on raspberry), so we have to install it manually:

```bash
# add self to /etc/hosts
sudo nano /etc/hosts

# install gitlab runner
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get install gitlab-runner

# get the token
sudo gitlab-runner register -n \
    --url http://gitlab.dali.dev \
    --registration-token <<<YOUR-TOKEN>>> \
    --executor docker \
    --description "Tester Runner" \
    --docker-image "docker:stable" \
    --docker-privileged
```

## fix

https://hrushi-deshmukh.medium.com/ros%C2%B9-on-raspberry-pi-with-docker-50ab4c70dadc

```bash
wget http://ftp.debian.org/debian/pool/main/libs/libseccomp/libseccomp2_2.5.1-1_armhf.deb
sudo dpkg -i libseccomp2_2.5.1-1_armhf.deb 
```
