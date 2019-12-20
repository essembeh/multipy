FROM debian:buster

# Custom
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8

# Custom apt-get source file and prereq install
ADD sources.list /etc/apt/
RUN apt-get update \
	&& apt-get install --yes \
		wget git rsync python3-all python3-pip \
	&& apt-get build-dep --yes python3.7 \
	&& apt-get clean

# Script to isntall python
ADD python-install.sh /tmp

# Supported python environments
RUN /tmp/python-install.sh altinstall 3.8.1 /opt/py38
# Python 3.7 is default stretch
RUN /tmp/python-install.sh altinstall 3.6.10 /opt/py36
RUN /tmp/python-install.sh altinstall 3.5.9 /opt/py35


# Update PATH to use installed pythons
ENV PATH /opt/py38/bin:$PATH
ENV PATH /opt/py36/bin:$PATH
ENV PATH /opt/py35/bin:$PATH

# Install tox
RUN pip3 install tox

# Install extra packages
ARG APT_EXTRA_PACKAGES=
RUN apt-get update \
	&& apt-get install --yes \
		${APT_EXTRA_PACKAGES} \
	&& apt-get clean
	
# Create tox user
RUN useradd --create-home --shell /bin/bash tox
USER tox
WORKDIR /home/tox

ADD entrypoint.sh /home/tox/
ENTRYPOINT ["/home/tox/entrypoint.sh"]
