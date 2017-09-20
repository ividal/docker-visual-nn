FROM gcr.io/tensorflow/tensorflow:latest-devel-gpu-py3

#basic installs
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
            git \
            unzip \
            vim \
            wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# installs for OpenCV
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
            pkg-config \
            build-essential \
            cmake \
            libgtk2.0-dev \
            libavcodec-dev \
            libavformat-dev \
            libswscale-dev \
            libtbb2 \
            libtbb-dev \
            libjpeg-dev \
            libpng-dev \
            libtiff-dev \
            libjasper-dev \
            libdc1394-22-dev \
            python3-dev \
            python3-setuptools \
            libboost-all-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# python environment (since it's a docker container, we don't need virtual envs)
RUN pip3 install pytest \
                 tensorboard \
                 h5py \
                 scikit-learn

# OpenCV

ENV SRC /usr/local/src
ARG SRC=/usr/local/src

RUN mkdir -p $SRC && \
    cd $SRC && \
    git clone --branch 3.3.0 --depth 1 https://github.com/Itseez/opencv.git && \
    git clone --branch 3.3.0 --depth 1 https://github.com/Itseez/opencv_contrib.git && \
    mkdir -p $SRC/opencv/build && \
    cd $SRC/opencv/build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D INSTALL_C_EXAMPLES=OFF \
          -D INSTALL_PYTHON_EXAMPLES=ON \
          -D OPENCV_EXTRA_MODULES_PATH=$SRC/opencv_contrib/modules \
          -D BUILD_EXAMPLES=ON \
          -D CUDA_CUDA_LIBRARY=/usr/local/cuda/lib64/stubs/libcuda.so \
          -D PYTHON_EXECUTABLE=$(which python3) \
		  -D PYTHON_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
		  -D PYTHON_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") .. \
          .. && \
    make -k -j8 && \
    make install &&\
    rm -rf $SRC/opencv && \
    rm -rf $SRC/opencv_contrib && \
    ln /dev/null /dev/raw1394

WORKDIR $SRC
