FROM ubuntu:18.04

MAINTAINER ZenTauro <zentauro@riseup.net>

RUN apt-get update && apt-upgrade \
    && apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    clang \
    wget \
    git \
    pkg-config \
    libjpeg-dev \
    libtiff-dev \
    libjasper-dev \
    libpng-dev \
    libavcodec-dev \
    libopenblas-dev \
    liblapacke-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libgtk2.0-dev \
    libatlas-base-dev \
    gfortran \
    freeglut3 \
    freeglut3-dev \
    libtbb-dev \
    libqt4-dev \
    && apt-get -y clean all \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/user/devel
RUN mkdir -p /home/user/opencv

WORKDIR /home/user/opencv

RUN git clone https://github.com/opencv/opencv.git \
    && cd opencv \
    && git checkout 3.4.6 \
    && cd ..
RUN git clone https://github.com/opencv/opencv_contrib.git \
    && cd opencv_contrib \
    && git checkout 3.4.6 \
    && cd ..

RUN CC=clang CXX=clang++ cd /home/user/opencv/opencv \
	&& cmake -Bbuild -GNinja \
	  -DCMAKE_BUILD_TYPE=RELEASE \
      -DCMAKE_EXE_LINKER_FLAGS='-fuse-ld=gold' \
      -DOPENCV_EXTRA_MODULES_PATH=/home/user/opencv/opencv_contrib \
	  -DCMAKE_INSTALL_PREFIX=/usr/local \
	  -DENABLE_AVX=ON \
      -DWITH_TBB=ON \
	  -DWITH_OPENGL=ON \
	  -DWITH_OPENCL=ON \
      -DWITH_OPENMP=ON \
	  -DWITH_IPP=ON \
	  -DWITH_TBB=ON \
	  -DWITH_EIGEN=ON \
	  -DWITH_V4L=ON \
      -DWITH_CSTRIPES=ON \
	  -DBUILD_opencv_java=OFF \
	  -DBUILD_TIFF=ON \
	  -DBUILD_TESTS=OFF \
      -DBUILD_DOCS=OFF \
      -DBUILD_EXAMPLES=OFF \
	  -DBUILD_PERF_TESTS=OFF

RUN cd /home/user/opencv/opencv/build \
	&& ninja install \
    && cd /home/user/ \
    && rm -r opencv \
    && bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf' \
    && ldconfig
