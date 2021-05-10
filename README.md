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

## Gitlab setup

The following giles should be created:

```

external_url "https://gitlab.dali.com"
nginx['redirect_http_to_https'] = true
```
