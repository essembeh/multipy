FROM debian:stretch

# Custom
ENV LANG C.UTF-8

# Custom apt-get source file and prereq install
ADD sources.list /etc/apt/
RUN apt-get update && apt-get install -y curl wget && apt-get build-dep -y python3.5 && apt-get clean

# Script to isntall python
ADD python-install.sh /tmp

# Supported python environments
RUN /tmp/python-install.sh altinstall 3.8.0 /opt/py38
RUN /tmp/python-install.sh altinstall 3.7.5 /opt/py37
RUN /tmp/python-install.sh altinstall 3.6.9 /opt/py36
RUN /tmp/python-install.sh altinstall 3.5.7 /opt/py35

# Trick to install python 3.4
RUN apt-get install -y libssl1.0-dev
RUN /tmp/python-install.sh altinstall 3.4.10 /opt/py34
RUN apt-get install -y libssl-dev

# Update PATH to use installed pythons
ENV PATH /opt/py34/bin:/opt/py35/bin:/opt/py36/bin:/opt/py37/bin:/opt/py38/bin:$PATH

# Install tox
RUN pip3.5 install tox