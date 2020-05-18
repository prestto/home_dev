# Presentation

A quick project to provide an easily reproducable development environment on a raspberry pi.

## Requirements

Gitlab requires at least 2 GB of RAM.  This is a minimum, but frankly with 4GB on a raspberry it's not the fastest, so i would recommend at last this.

If you wish to do more that just an example project, you will also need additional storage.  For the project I've used a 120Gb SSD.  This must be mounted in the fstab (see below), so that it's run on restart of raspberry.

Additionally, if there is a problem with git, or if the raspberry is disconnected, it's practival that gitlab restarts with the raspberry.  A guide for setting this up using init.d is included below.

## Mount your SSD

Mounting yous ssd essentially means attaching the filesystem of the ssd to a point in the filesystem of the raspberry.  There are 3 stages to this:

- Find your ssd's uuid
- create a mountpoint
- mount the ssd
- check that it can be written to
- configure the /etc/fstab, so that steps 1-3 above can be automated

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
