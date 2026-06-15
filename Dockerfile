FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    gnupg \
    git \
    make \
    cmake \
    && rm -rf /var/lib/apt/lists/*

RUN wget -U "dkp-apt" https://apt.devkitpro.org/install-devkitpro-pacman \
    && chmod +x ./install-devkitpro-pacman \
    && yes | ./install-devkitpro-pacman \
    && rm ./install-devkitpro-pacman

ENV DEVKITPRO=/opt/devkitpro
ENV DEVKITPPC=/opt/devkitpro/devkitPPC
ENV PATH="${DEVKITPRO}/pacman/bin:${DEVKITPRO}/tools/bin:${DEVKITPRO}/portlibs/wiiu/bin:${PATH}"

RUN ln -sf /proc/self/mounts /etc/mtab \
    && dkp-pacman -Syu --noconfirm wiiu-dev

WORKDIR /work

RUN git clone https://github.com/devkitPro/wut.git \
    && mkdir -p dist \
    && cd wut/samples/cmake \
    && for sample in custom_default_heap erreula gx2_triangle helloworld helloworld_cpp my_first_rpl swkbd; do \
            echo "Building $sample..." \
            && cd "$sample" \
            && mkdir build && cd build \
            && powerpc-eabi-cmake .. \
            && make \
            && find . -maxdepth 1 -type f \( -name "*.rpx" -o -name "*.rpl" -o -name "*.elf" \) -exec cp {} /work/dist/ \; \
            && cd ../..; \
        done
