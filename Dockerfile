from ubuntu:xenial-20170119

ARG DEBIAN_FRONTEND=noninteractive
 
RUN echo '***** update apt packages and install utilities *****'                                    \
 && apt-get -y update                                                                               \
 && apt-get -y install -y apt-utils                                                                 \
 && apt-get -y install wget makepasswd                                                              \
                                                                                                    \
 && echo '***** create the skope group *****'                                                       \
 && groupadd skope --gid 1000                                                                       \
                                                                                                    \
 && echo '***** create the skope user *****'                                                        \
 && useradd skope --uid 1000                                                                        \
                  --gid skope                                                                       \
                  --shell /bin/bash                                                                 \
                  --create-home                                                                     \
                  --password `echo skope | makepasswd --crypt-md5 --clearfrom - | cut -b11-`        \
                                                                                                    \
 && echo '***** create the /workspace directory *****'                                              \
 && mkdir /workspace                                                                                \
 && chown skope.skope /workspace

WORKDIR /workspace
VOLUME ["/workspace"]

USER skope

CMD echo "Usage: docker run openskope/base <linux command> [linux-command-arguments]"
