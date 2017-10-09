FROM nvidia/digits:latest

ENV SRC '/usr/local/src'

#basic installs
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
            vim \
            unzip \
            wget \
            openssl \
            ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# python environment (since it's a docker container, we don't need virtual envs)
# bootstrap this way unless using py3 (to get pip 9.0.1)

RUN wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py
RUN pip --no-cache-dir install --upgrade sklearn \
                                         tensorflow-gpu==1.2.1 \
                                         keras \
                                         tensorboard && \
    rm -rf get-pip.py
