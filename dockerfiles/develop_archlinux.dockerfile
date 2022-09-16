FROM archlinux:latest

ARG user=developer
ARG ohmyzsh_url=https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git


RUN echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' > temp.txt && \
    cat /etc/pacman.d/mirrorlist >> temp.txt && \
    mv temp.txt /etc/pacman.d/mirrorlist

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm gcc gdb clang llvm lldb lld && \
    pacman -S --noconfirm libc++ libc++abi && \
    pacman -S --noconfirm git cmake ninja

RUN pacman -S --noconfirm vim zsh && \
    pacman -S --noconfirm python python-pip && \
    pacman -S --noconfirm rust go jdk17-openjdk

RUN echo "root:root" | chpasswd && \
    useradd --create-home --shell /bin/zsh ${user} && \
    echo "${user}:${user}" | chpasswd && \
    pacman -S --noconfirm sudo && \
    echo "${user}  ALL=(ALL:ALL) ALL" > /etc/sudoers.d/${user}

USER ${user}
WORKDIR /home/${user}

# 安装ohmyzsh
RUN git clone ${ohmyzsh_url} && \
    REMOTE=${ohmyzsh_url} sh ./ohmyzsh/tools/install.sh && \
    rm ./ohmyzsh -r