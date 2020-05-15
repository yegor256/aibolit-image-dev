# Copyright (c) 2020, Yegor Bugayenko
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met: 1) Redistributions of source code must retain the above
# copyright notice, this list of conditions and the following
# disclaimer. 2) Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following
# disclaimer in the documentation and/or other materials provided
# with the distribution. 3) Neither the name of the rultor.com nor
# the names of its contributors may be used to endorse or promote
# products derived from this software without specific prior written
# permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT
# NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
# THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.

# The software packages configured here (PHP, Node, Ruby, Java etc.) are for
# the convenience of the users going to use this default container.
# If you are going to use your own container, you may remove them.
# Rultor has no dependency on these packages.

FROM jupyter/datascience-notebook
MAINTAINER Yegor Bugayenko <yegor256@gmail.com>
LABEL Description="This is the default image for Aibolit" Vendor="Aibolit" Version="1.0"

RUN wget -q https://github.com/yegor256/aibolit/releases/download/v1.0.0/dataset.zip
RUN wget -q https://github.com/yegor256/aibolit/releases/download/v1.0.0/halstead.jar
RUN wget -q https://github.com/yegor256/aibolit/releases/download/v1.0.0/pmd-bin.zip

RUN git config --global user.email "docker@example.com"
RUN git config --global user.name "Docker Dockerovich"
RUN git config --global core.editor "vim"

RUN mkdir in
RUN mkdir out

USER root
RUN apt-get -y update && apt-get -y install vim
RUN apt-get -y install default-jdk maven

USER jovyan
RUN mkdir _tmp
RUN mkdir java_files
RUN unzip -q dataset.zip -d ./java_files
ENV JAVA_FILES_PATH /home/jovyan/in
ENV SAVE_MODEL_FOLDER /home/jovyan/out

ARG PULL_ID
ENV PULL_ID ${PULL_ID:-}

# fetch and install Aibolit from source#
ADD --chown=jovyan:users ./git_clone_and_pull_pr.sh .
RUN chmod +x ./git_clone_and_pull_pr.sh
RUN ./git_clone_and_pull_pr.sh

WORKDIR /home/jovyan

ENTRYPOINT []
CMD ["aibolit", "train",  "--java_folder=/home/jovyan/in"]

