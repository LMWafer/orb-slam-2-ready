[**Introduction**](#introduction) | [**I want vSLAM now !**](#i-want-vslam-now) | [**General info**](#general-info) | [**Prerequisites**](#image-prerequisites) | [**Installation**](#image-installation) | [**How-tos**](#image-usage)

# Introduction 

## Reference

[Stereo and RGB-D] Raúl Mur-Artal and Juan D. Tardós. **ORB-SLAM2: an Open-Source SLAM System for Monocular, Stereo and RGB-D Cameras**. IEEE Transactions on Robotics, vol. 33, no. 5, pp. 1255-1262, 2017. **[PDF](https://128.84.21.199/pdf/1610.06475.pdf)**. **[Github](https://github.com/raulmur/ORB_SLAM2)**. 

## What's that repo?

Just a Docker image that makes you skip the whole ORB-SLAM 2 installation process. Simply run a container and start vSLAM examples. No additional applications, no fancy dependencies... just the source code!
Moreover, all the images and their build are tested on 3 different machines with Ubuntu 20.04 to ensure they work properly!

Solved common issues (the real bois will know) : 
- *what(): Pangolin X11: Failed to create an OpenGL context*
- *OpenCV > 4.4 not found*
- *CMakeFiles/ORB_SLAM2.dir/build.make:some number: recipe for target 'CMakeFiles/ORB_SLAM2.dir/some file.cc' failed*
- Container that keeps restarting
- *docker: Error response from daemon: could not select device driver "" with capabilities: [[gpu]]*


This repository contains release info and advanced image manipulation. See the project's **[Dockerhub](https://hub.docker.com/repository/docker/lmwafer/orb-slam2-ready)** for more tag info.

# I want demo now
1. Make sure to have the basic docker dependencies mentioned [here](#image-prerequisites). 
  
2. This will pull the image from [Docker hub](https://hub.docker.com/r/lmwafer/orb-slam2-ready/tags) and run a container (needs a GPU for Pangolin, container removed after exit)
```bash
sudo xhost +local:root && docker run --privileged --name orb-2-container --rm -p 8086:8086 -e DISPLAY=$DISPLAY -e QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev:/dev:ro --gpus all -it lmwafer/orb-slam2-ready:1.1-ubuntu18.04
```

3. Run this inside the container to start a dataset demo. This is not real-time vSLAM but a loop of 4 TUM dataset 
```bash
cd /app/ && make prepare && make demo
```
You can run every example that comes along the library. Everything in the image is already built!

# General info
The image is based on two image layers : [Ubuntu 18.04](https://hub.docker.com/_/ubuntu?tab=tags&page=1&name=18.04), [realsense-ready](https://hub.docker.com/r/lmwafer/realsense-ready). 

The *realsense-ready* layer only adds the [Intel Realsense SDK 2.0](https://github.com/IntelRealSense/librealsense). For now, this layer is mandatory but more camera flexibility will be added in the future. You can still try to change the `FROM` image, see below. 

The images tag follows this template : `<image version>-<os name><os version>`. 
`<os name>` is the name of the **Docker os** not the system one, same thing for `<os version>`. `<image version>` is specific to `<os name><os version>`. That means image version refers to the work advancement for the Docker version.

Every dependency is installed in */dpds* directory. Reach original ORB_SLAM2 directory with 
```bash
cd /dpds/ORB_SLAM2/
```

You may want better control of what's inside the image. To this matter you will find here : 

- Image *Dockerfile*. Note that **orb-slam-2-ready** lays on top of **realsense-ready**. Modify that by changing `FORM` instruction in *Dockerfile-orb*. Don't forget general usage dependencies that came along realsense-ready image !

- *docker-compose.yml* to start container automatically and for Kubernetes-like deployement. Note that stopping a container removes it. An external *app* directory is linked to the containers */app* one in order to provide a permanent save point.

- *Makefile* to provide usual commands

# Image prerequisites

- Ubuntu 20.04

- Docker (tested with Docker 20.10.7), see [Install Docker Engine](https://docs.docker.com/engine/install/)

- Docker Compose (tested with Docker Compose 1.29.2), see [Install Docker Compose](https://docs.docker.com/compose/install/)
  You may have a `/usr/local/bin/docker-compose: no such file or directory` error. In this case, use
  ```bash
  sudo mkdir /usr/local/bin/docker-compose
  ```
  before restarting the installation process

- Nvidia Container Toolkit (tested with ubuntu20.04 distribution), see [NVIDIA Container Toolkit Installation Guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

- A PC with GPU. Use the following to list available graphics units
  ```bash
  lshw -c display
  ```

# Image installation

```bash
docker pull lmwafer/orb-slam2-ready:<desired tag>
```

# Image usage

All the commands need to be run in **orb-slam-2-ready** directory. 

Get inside a freshly new container (basically `up` + `enter`)
```bash
make
```

Start an *orb-slam-2-container* (uses **docker-compose.yml**)
```bash
make up
```

Enter running *orb-slam-2-container*
```bash
make enter
```

Stop running *orb-slam-2-container* (and removes it, by default only data in */app* is saved here in *app* directory)
```bash
make down
```

Build *orb-slam-2-ready* image (uses *Dockerfile*)
```bash
make build
```