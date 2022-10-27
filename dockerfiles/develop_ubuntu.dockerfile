FROM ubuntu:22.04

ARG user=developer
ARG ohmyzsh_url=https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y apt-utils && \
    apt-get install -y dialog  && \
    apt-get install -y debconf && \
    apt-get install -y locales-all locales language-pack-zh-hans

RUN apt-get install -y make gcc g++ gdb build-essential binutils clang llvm lld lldb clangd clang-format clang-tidy clang-tools && \
    apt-get install -y libstdc++6 libc++1 libc++abi1 && \
    apt-get install -y openjdk-17-jdk golang python3 python2 python3-pip && \
    apt-get install -y git cmake ninja-build && \
    apt-get install -y zsh vim


RUN apt-get install -y sudo && \
    echo "root:root" | chpasswd && \
    useradd --create-home --shell /bin/zsh ${user} && \
    echo "${user}:${user}" | chpasswd && \
    adduser ${user} sudo

USER ${user}
WORKDIR /home/${user}

# 安装ohmyzsh
RUN git clone ${ohmyzsh_url} && \
    REMOTE=${ohmyzsh_url} sh ./ohmyzsh/tools/install.sh && \
    rm ./ohmyzsh -r

RUN echo "export LANG=zh_CN.UTF-8">> .zshrc && \
    echo "export LANGUAGE=zh_CN:zh:en_US:en">> zshrc && \
    echo "export LC_ALL=zh_CN.UTF-8">> zshrc