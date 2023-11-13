# Only UBI cuda images are compiled for ppc64, so we have to use UBI
FROM nvidia/cuda:11.7.1-devel-ubi8

# Set the CFLAGS and CXXFLAGS environment variables. Without this, we cannot compile the project for ppc64le architecture
ENV CFLAGS="-O2 -mcpu=power9 -mtune=power9"
ENV CXXFLAGS="-O2 -mcpu=power9 -mtune=power9"

### SETUP PYTHON 3.9
# UBI uses too old python by default (python 3.6 lmao cringe), so we have to manualy install new version
# Dependencies for python 3.9
RUN yum install -y gcc openssl-devel bzip2-devel libffi-devel zlib-devel wget sqlite-devel

# This part takes a looooong time, around 15 mins
RUN yum install -y python3-pip
RUN wget https://www.python.org/ftp/python/3.9.6/Python-3.9.6.tgz
RUN tar -xvf Python-3.9.6.tgz
RUN cd Python-3.9.6 && ./configure --enable-optimizations && make && make altinstall

### SETUP LLAMA
# Install required packages for building and running the application
RUN yum update -y && yum install -y python3-devel cmake openssl-devel ninja-build

RUN mkdir /app
WORKDIR /app
COPY . /app


# This is to setup python 3.9 as the default for commands python3 and python. 
# This is the minimum required version for llama-cpp-python
ENV VIRTUAL_ENV=/app/my_venv
RUN python3.9 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"


RUN python3 -m pip install --upgrade pip scikit-build

RUN python3 -m pip install --upgrade pip wheel pytest cmake scikit-build setuptools fastapi uvicorn sse-starlette pydantic-settings cython

RUN make build.cuda && make clean

# Set environment variable for the host
ENV HOST=0.0.0.0
ENV PORT=8000

# Expose a port for the server
EXPOSE 8000

# Run the server start script
CMD ["/bin/sh", "/app/docker/custom_cuda/run.sh"]
