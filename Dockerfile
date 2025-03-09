FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

ARG USER_UID
ARG USER_GID
ARG USERNAME


# install wget and xz-utils
RUN : \
  && apt-get update \
  && apt-get install -y \
  wget \
  xz-utils \
  && :
  
# Download and extract casa into /opt/casa
ARG CASA_VERSION=casa-6.7.0-31-py3.12.el8
RUN : \
  && wget \
    -O /tmp/casa.tar.xz \
    https://casa.nrao.edu/download/distro/casa/release/rhel/${CASA_VERSION}.tar.xz \
  && mkdir -p /opt/casa \
  && cd /opt/casa \
  && tar -xvf /tmp/casa.tar.xz \
  && rm /tmp/casa.tar.xz \
  && :

ENV PATH="/opt/casa/${CASA_VERSION}/bin:$PATH"

  
# install CASA prerequisites
RUN : \
  && apt-get install -y \
  fuse \
  fontconfig \
  imagemagick \
  libglib2* \
  libcanberra-gtk* \
  libgfortran* \
  && :
  
# install ANY other package (personal use or debugging)
RUN : \
  && apt-get install -y \
  nano \
  mesa-utils \
  && :


# Create the user
RUN : \
  && groupadd \
    --gid $USER_GID \
    $USERNAME \
  && useradd \
    --uid $USER_UID \
    --gid $USER_GID \
    -m \
    $USERNAME \
  && usermod \
    -aG video $USERNAME \
  && apt-get update \
  && apt-get install -y \
    sudo \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  && :

ENV USER_UID=${USER_UID}
ENV USER_GID=${USER_GID}
ENV USERNAME=${USERNAME}
ENV PYTHONWARNINGS="ignore::DeprecationWarning"
ENV PYTHONUNBUFFERED="1"

USER ${USERNAME}
WORKDIR /home/${USERNAME}/

ADD entrypoint.sh /app/entrypoint.sh
ENTRYPOINT [ "/app/entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null"]
