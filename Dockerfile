# This is a Docker file to build a Docker image with ORB-SLAM 2 and all its dependencies pre-installed
# For more info about ORB-SLAM 2 dependencies go check https://github.com/raulmur/ORB_SLAM2
# For more info about this particular image go check https://github.com/LMWafer/orb-slam-2-ready

FROM lmwafer/realsense-ready:2.0-ubuntu18.04

#-> Initialize a variable to change simultaneous build jobs
#-? ARG instruction does not cover the entire file scope thus its value is passed to an environment variable that persists through the build
#-? For more info see https://docs.docker.com/engine/reference/builder/#using-arg-variables
ARG jobs=4
ENV JOBS=${jobs}

#-> Medatada of the image
LABEL info.author="LMWafer" \
      info.version="1.2" \
      info.description="This is a Docker file to build a Docker image with ORB-SLAM 2 and all its dependencies pre-installed \nFor more info about ORB-SLAM 2 dependencies go check https://github.com/raulmur/ORB_SLAM2 \nFor more info about this particular image go check https://github.com/LMWafer/orb-slam-2-ready"

#-> Small message to give developers source files
ONBUILD RUN echo "This image is based on lmwafer/orb-slam2-ready Docker image, go check https://github.com/LMWafer/orb-slam-2-ready"

#-> Install general usage dependencies
RUN echo "Installing general usage dependencies ..." && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    nano \
    libglew-dev \
    libgtk2.0-dev \
    pkg-config
    
#-> Install Pangolin
#-? 3D Vizualisation tool
WORKDIR /dpds/
RUN echo "Configuring and building Pangolin 0.5 ..." && \
    wget https://github.com/stevenlovegrove/Pangolin/archive/refs/tags/v0.5.tar.gz && \
    tar -xzf v0.5.tar.gz && \
    rm v0.5.tar.gz && \
    cd Pangolin-0.5/ && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$JOBS && \
    make install

#-> Install OpenCV
#-? Usual computer vision library
WORKDIR /dpds/
RUN echo "Configuring and building OpenCV 3.2.0 ..." && \
    wget https://github.com/opencv/opencv/archive/refs/tags/3.2.0.tar.gz && \
    tar -xzf 3.2.0.tar.gz && \
    rm 3.2.0.tar.gz && \
    cd opencv-3.2.0/ && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$JOBS && \
    make install && \
    ldconfig

#-> Install Eigen 3 last version
#-? Linear algebra library
WORKDIR /dpds/
RUN echo "Configuring and building Eigen 3.1.0 ..." && \
    wget https://gitlab.com/libeigen/eigen/-/archive/3.1.0/eigen-3.1.0.tar.gz && \
    tar -xzf eigen-3.1.0.tar.gz && \
    rm eigen-3.1.0.tar.gz && \
    cd eigen-3.1.0 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$JOBS && \
    make install
    
#-> Get ORB-SLAM 3 installation ready
#-> "System.h" is slightly changed in order to avoid a build error
WORKDIR /dpds/
RUN echo "Getting ORB-SLAM 2 installation ready ..." && \
    git clone https://github.com/raulmur/ORB_SLAM2.git && \
    cd ORB_SLAM2/ && \
    rm include/System.h
COPY System.h /dpds/ORB_SLAM2/include/

#-! From here, a compilation method is proposed by the repo: "chmod +x build.sh && ./build.sh"
#-! Such method remove some control over the image build (simultaneous jobs number, directories) 
#-! Thus evey step in build.sh has been added here and slightly modified

#-> Install DBoW2
#-? Images to bag-of-word library
WORKDIR /dpds/ORB_SLAM2/Thirdparty/DBoW2/
RUN echo "Configuring and building thirdparty DBoW2 ..." && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make -j$JOBS

#-> Install g2o
#-? Graph optimization
WORKDIR /dpds/ORB_SLAM2/Thirdparty/g2o/
RUN echo "Configuring and building thirdparty g2o ..." && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make -j$JOBS

#-> Uncompress vocabulary
#-? ORB-SLAM 2 useful data
WORKDIR /dpds/ORB_SLAM2/Vocabulary/
RUN echo "Uncompressing vocabulary ..." && \
    tar -xf ORBvoc.txt.tar.gz

#-> Install ORB-SLAM 3
WORKDIR /dpds/ORB_SLAM2/
RUN echo "Configuring and building ORB-SLAM 2 ..." && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make -j$JOBS