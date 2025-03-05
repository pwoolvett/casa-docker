FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

ARG USER_UID
ARG USER_GID
ARG USERNAME


# install prerequisites
RUN : \
  && apt-get update \
  && apt-get install -y \
  wget \
  xz-utils \
  fuse \
  fontconfig \
  imagemagick \
  libglib2* \
  libcanberra-gtk* \
  libgfortran* \
  && :

# extract casa into /opt/casa
RUN : \
  && wget \
    -O /tmp/casa.tar.xz \
    https://casa.nrao.edu/download/distro/casa/release/rhel/casa-6.7.0-31-py3.12.el8.tar.xz \
  && mkdir -p /opt/casa \
  && cd /opt/casa \
  && tar -xvf /tmp/casa.tar.xz \
  && rm /tmp/casa.tar.xz \
  && :

ENV PATH="/opt/casa/casa-6.7.0-31-py3.12.el8/bin:$PATH"


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

# FROM ubuntu:20.04

# ARG USER_ID
# ARG USER_GID

# RUN : \
#   && apt-get update \
#   && apt-get install -y \
#   wget \
#   && :

# RUN wget \
#   -O /tmp/casa.tar.xz \
#   https://casa.nrao.edu/download/distro/casa/release/rhel/casa-6.7.0-31-py3.12.el8.tar.xz

# RUN : \
#   && apt-get update \
#   && apt-get install -y \
#   xz-utils \
#   && :
# # extract casa into /opt/casa
# RUN mkdir -p /opt/casa
# RUN \
#   cd /opt/casa \
#   && tar -xvf /tmp/casa.tar.xz
# ENV PATH="/opt/casa/casa-6.7.0-31-py3.12.el8/bin:$PATH"

# ARG DEBIAN_FRONTEND=noninteractive
# RUN : \
#   && apt-get update \
#   && apt-get install -y \
#   fuse \
#   libglib2* \
#   fontconfig \
#   libcanberra-gtk* \
#   imagemagick \
#   libgfortran* \
#   && :

# ARG USERNAME=p
# ARG USER_UID
# ARG USER_GID
# # Create the user
# RUN : \
#   && groupadd \
#     --gid $USER_GID \
#     $USERNAME \
#   && useradd \
#     --uid $USER_UID \
#     --gid $USER_GID \
#     -m \
#     $USERNAME \
#   && apt-get update \
#   && apt-get install -y \
#     sudo \
#   && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
#   && chmod 0440 /etc/sudoers.d/$USERNAME

# USER ${USERNAME}
# WORKDIR /home/${USERNAME}/
# # $: sudo yum install ImageMagick*
# # $: sudo yum install xorg-x11-server-Xvfb
# # $: sudo yum install compat-libgfortran-48
# # $: sudo yum install libnsl
# # $: sudo yum install libcanberra-gtk2
# # ImageMagick can be obtained from EPEL 8: https://dl.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/i/. To add Epel via subscription manager (from RHEL docs):
# # $: subscription-manager repos --enable codeready-builder-for-rhel-8-$(arch)-rpms
# # $: dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm


# # install wget
# # RUN : \
# #   && apt-get update \
# #   && apt-get install -y \
# #   wget \
# #   xz \
# #   perl \
# #   fuse \
# #   fuse-devel \
# #   fontconfig



# # WORKDIR /root/.casa/data

# # ARG USER_NAME
# # ARG USER_GROUP
# # RUN usera
