FROM ubuntu:22.04

ARG user=developer
ARG ohmyzsh_url=https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y debconf dialog apt-utils && \
    apt-get install -y make gcc g++ gdb build-essential binutils clang llvm lld lldb clangd clang-format clang-tidy clang-tools && \
    apt-get install -y libstdc++6 libc++1 libc++abi1 && \
    apt-get install -y git cmake ninja-build

RUN apt-get install -y zsh vim

RUN useradd --create-home --shell /bin/zsh ${user} && \
    echo "${user}:${user}" | chpasswd

USER ${user}
WORKDIR /home/${user}

# 安装ohmyzsh
RUN git clone ${ohmyzsh_url} && \
    REMOTE=${ohmyzsh_url} sh ./ohmyzsh/tools/install.sh && \
    rm ./ohmyzsh -r