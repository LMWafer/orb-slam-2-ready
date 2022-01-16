FROM lmwafer/realsense-ready:2.0-ubuntu18.04

RUN apt install -y nano libglew-dev && \
    cd /dpds && \
    
    wget https://github.com/stevenlovegrove/Pangolin/archive/refs/tags/v0.5.tar.gz && \
    tar -xzf v0.5.tar.gz && \
    rm v0.5.tar.gz && \
    cd Pangolin-0.5/ && \
    mkdir build && cd build && \
    cmake .. && \
    cmake --build . && \

    cd /dpds && \
    wget https://github.com/opencv/opencv/archive/refs/tags/3.2.0.tar.gz && \
    tar -xzf 3.2.0.tar.gz && \
    rm 3.2.0.tar.gz && \
    cd opencv-3.2.0/ && \
    mkdir build && cd build && \
    cmake .. && \
    make && \
    make install && \
    ldconfig && \

    cd /dpds && \
    wget https://gitlab.com/libeigen/eigen/-/archive/3.1.0/eigen-3.1.0.tar.gz && \
    tar -xzf eigen-3.1.0.tar.gz && \
    rm eigen-3.1.0.tar.gz && \
    cd eigen-3.1.0 && \
    mkdir build && cd build && \
    cmake .. && \
    make install && \
    
    cd /dpds && \
    git clone https://github.com/raulmur/ORB_SLAM2.git && \
    cd ORB_SLAM2/ && \
    rm include/System.h

COPY System.h /dpds/ORB_SLAM2/include/

RUN cd /dpds/ORB_SLAM2/ && \
    chmod +x build.sh && \
    ./build.sh