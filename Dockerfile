from ubuntu:xenial-20170119

ARG DEBIAN_FRONTEND=noninteractive

ENV DOCKER_IMAGE_NAME openskope/base

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
 && echo '***** create the workspace directory *****'                                               \
 && mkdir /workspace                                                                                \
 && chown skope.skope /workspace

VOLUME ["/workspace"]
WORKDIR /workspace

USER skope

ENV SELFTEST_BASE /home/skope/selftest
ENV SELFTEST_DIR ${SELFTEST_BASE}/${DOCKER_IMAGE_NAME}

RUN echo '***** create the selftest directory tree *****'                                           \
 && mkdir -p ${SELFTEST_DIR}

COPY ./selftest/runtest.sh ${SELFTEST_BASE}
COPY ./selftest/expected.txt ${SELFTEST_BASE}
COPY ./selftest/test.sh ${SELFTEST_DIR}

RUN ${SELFTEST_BASE}/runtest.sh


CMD echo "Usage: docker run openskope/base <linux command> [linux-command-arguments]"
