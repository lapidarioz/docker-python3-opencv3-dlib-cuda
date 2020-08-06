FROM tensorflow/tensorflow:2.2.0-gpu

# from https://github.com/kbobrowski/docker-deep-learning-essentials/blob/master/Dockerfile
ARG OPENCV_VERSION=3.3.1
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /

# OpenCV dependencies
RUN apt-get update && \
	apt-get install -y \
	build-essential \
	cmake \
	git \
	wget \
	unzip \
	yasm \
	pkg-config \
	libswscale-dev \
	libtbb2 \
	libtbb-dev \
	libjpeg-dev \
	libpng-dev \
	libtiff-dev \
	libavformat-dev \
	libpq-dev \
	libgtk2.0-dev && \
# from https://github.com/janza/docker-python3-opencv/issues/16
git clone https://github.com/jasperproject/jasper-client.git jasper && \
    chmod +x jasper/jasper.py && \
    pip install --upgrade setuptools && \ 
    pip install -r jasper/client/requirements.txt && \
# OpenCV compilation
wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
&& unzip ${OPENCV_VERSION}.zip \
&& mkdir /opencv-${OPENCV_VERSION}/cmake_binary \
&& cd /opencv-${OPENCV_VERSION}/cmake_binary \
&& cmake -DBUILD_TIFF=ON \
  -DBUILD_opencv_java=OFF \
  -DWITH_CUDA=OFF \
  -DENABLE_AVX=ON \
  -DWITH_OPENGL=ON \
  -DWITH_OPENCL=ON \
  -DWITH_IPP=ON \
  -DWITH_TBB=ON \
  -DWITH_EIGEN=ON \
  -DWITH_V4L=ON \
  -DWITH_GTK=ON \
  -DWITH_GTK_2_X=ON \
  -DBUILD_TESTS=OFF \
  -DBUILD_PERF_TESTS=OFF \
  -DCMAKE_BUILD_TYPE=RELEASE \
  -DCMAKE_INSTALL_PREFIX=$(python -c "import sys; print(sys.prefix)") \
  -DPYTHON_EXECUTABLE=$(which python) \
  -DPYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
  -DPYTHON_PACKAGES_PATH=$(python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") .. \
&& make install \
&& rm /${OPENCV_VERSION}.zip \
&& rm -r /opencv-${OPENCV_VERSION} \
&& python --version && \
   python -c "import cv2 ; print(cv2.__version__)"  && \
# keras
pip install --no-cache-dir keras && \
# image and video processing
apt-get update && apt-get install -y \
        ffmpeg \
        python3-tk \
        libgstreamer1.0 \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-0 \
        libgstreamer-plugins-base1.0-dev \
&& \
pip install --no-cache-dir \
        scikit-image \
        sk-video \


# from https://github.com/ageitgey/face_recognition/blob/master/Dockerfile.gpu
RUN apt update -y; apt install -y \
git \
cmake \
libsm6 \
libxext6 \
libxrender-dev \
bzip2

RUN pip install scikit-build

# Install compilers

RUN apt install -y software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt update -y; apt install -y gcc-6 g++-6

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 50
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 50

#Install dlib 

RUN git clone -b 'v19.16' --single-branch https://github.com/davisking/dlib.git
RUN mkdir -p /dlib/build

RUN cmake -H/dlib -B/dlib/build -DDLIB_USE_CUDA=1 -DUSE_AVX_INSTRUCTIONS=1
RUN cmake --build /dlib/build

RUN cd /dlib; python3 /dlib/setup.py install

# Install the face recognition package
RUN pip install face_recognition

#Cleaning
RUN apt-get autoremove -y && \
apt-get clean && \
rm -rf /opencv /opencv_contrib /var/lib/apt/lists/* 
