# docker-python3-opencv3-dlib-cuda

* Python 3
* OpenCV 3.4.9
* DLIB 19.19
* CUDA 10.1 cudnn 7

## BUILD
```
docker build -t python3-opencv3-dlib-cuda .
```
## RUN
```
docker run -ti -v $(pwd):/usr/src/app lapidarioz/python3-opencv3-dlib-cuda /bin/sh
cd /usr/src/app
python youraplication.py
```
