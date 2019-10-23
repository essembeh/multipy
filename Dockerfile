FROM debian:stretch

# Custom
ENV LANG C.UTF-8

# Custom apt-get source file and prereq install
ADD sources.list /etc/apt/
RUN apt-get update \
	&& apt-get install --yes \
		wget git rsync python3-all python3-pip \
	&& apt-get build-dep --yes python3.5 \
	&& apt-get clean

# Script to isntall python
ADD python-install.sh /tmp

# Supported python environments
RUN /tmp/python-install.sh altinstall 3.8.0 /opt/py38
RUN /tmp/python-install.sh altinstall 3.7.5 /opt/py37
RUN /tmp/python-install.sh altinstall 3.6.9 /opt/py36

# Python 3.5 is default stretch

# Trick to install python 3.4
RUN apt-get install --yes libssl1.0-dev
RUN /tmp/python-install.sh altinstall 3.4.10 /opt/py34
RUN apt-get install --yes libssl-dev

# Update PATH to use installed pythons
ENV PATH /opt/py38/bin:$PATH
ENV PATH /opt/py37/bin:$PATH
ENV PATH /opt/py36/bin:$PATH
ENV PATH /opt/py34/bin:$PATH

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
