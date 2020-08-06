# docker-python3-opencv3-dlib-cuda

* Python 3
* OpenCV 3.4.9
* DLIB 19.19
* CUDA 10.1 cudnn 7
* tensorflow 2.2.0

## BUILD
```
docker build -t python3-opencv3-dlib-cuda .
```
## RUN
```
docker run --gpus all -it --rm \
    -v $PWD:/usr/src/app \
    -w /usr/src/app \
    lapidarioz/python3-opencv3-dlib-cuda python youraplication.py
```

## Dockerfile
```
FROM lapidarioz/python3-opencv3-dlib-cuda

WORKDIR /usr/src/app
COPY requirements.txt /usr/src/app/
RUN pip install -U --no-cache-dir -r requirements.txt
```
