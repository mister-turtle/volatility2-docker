FROM ubuntu:bionic

LABEL maintainer "knode@protonmail.com"

# create directories for use by the host
RUN mkdir /dumps && mkdir /host

# required os packages
RUN apt-get update && apt-get install -y git python python-distorm3 python-crypto yara

# clone the volatilit2 repo and remove the .git for a smaller image
RUN git clone https://github.com/volatilityfoundation/volatility.git && rm -rf /volatility/.git

# make executable for shell convenience, symlink to inside PATH
RUN chmod +x /volatility/vol.py && ln -s /volatility/vol.py /usr/bin/vol.py

# tidy the image a bit to reduce size
RUN apt-get -y remove --purge git && apt-get -y autoremove && apt-get -y clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["python", "/volatility/vol.py"]
