FROM ubuntu:18.04
MAINTAINER github.com/insight-icon

RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && apt-get update \
 && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    wget \
    sudo \
    ca-certificates \
    unzip \
    apt-transport-https \
    libssl-dev \
    build-essential \
    automake \
    make \
    gcc \
    pkg-config \
    libtool \
    libffi-dev \
    libgmp-dev \
    libyaml-cpp-dev \
    libsecp256k1-dev \
    build-essential \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    python-pip \
    python3-dev \
    python3-pip \
    curl \
    git \
    jq \
    netcat \
    openssh-server \
    openssh-client \
    rsync

RUN apt-get install -y software-properties-common && add-apt-repository ppa:rmescandon/yq -y && apt-get install -y yq
RUN apt-get clean &&  rm -r /var/lib/apt/lists/* && apt-get update && apt-get install gpg-agent -y

RUN pip3 install setuptools wheel
RUN pip3 install \
    cookiecutter \
    ansible \
    docker \
    molecule \
    requests \
    preptools \
    fire \
    awscli \
    && rm -rf /var/lib/apt/lists/*

ARG TG_VERSION="v0.21.11"
ARG TF_VERSION="0.12.21"
ARG PACKER_VERSION="1.4.4"

#   Terraform
RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip -O /tmp/terraform.zip \
	&& unzip /tmp/terraform.zip -d /usr/local/bin/ && chmod +x /usr/local/bin/terraform

#   Packer
RUN wget https://releases.hashicorp.com/packer/1.4.4/packer_1.4.4_linux_amd64.zip -O /tmp/packer.zip \
	&& unzip /tmp/packer.zip -d /usr/local/bin/ && chmod +x /usr/local/bin/packer

#   Terragrunt
RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/${TG_VERSION}/terragrunt_linux_amd64 -O /usr/local/bin/terragrunt \
	&& chmod +x /usr/local/bin/terragrunt

#	meta
RUN curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash - && apt-get install nodejs &&  npm i -g meta

#	Cloud nuke
RUN wget https://github.com/gruntwork-io/cloud-nuke/releases/download/v0.1.13/cloud-nuke_linux_amd64 -O /usr/local/bin/cloud-nuke \
	&& chmod u+x /usr/local/bin/cloud-nuke

RUN curl -s https://storage.googleapis.com/golang/go1.13.linux-amd64.tar.gz| tar -v -C /usr/local -xz

ENV PATH $PATH:/usr/local/go/bin
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8