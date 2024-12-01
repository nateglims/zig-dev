FROM docker.io/library/archlinux:latest

RUN pacman -Sy --noconfirm curl git jq

# Install latest development build of Zig.
RUN mkdir -p /zig && \
    curl -L --no-progress-meter \
    $(curl -L --no-progress-meter "https://ziglang.org/download/index.json" | jq -r '.master | ."x86_64-linux" | .tarball') |\
    tar xJ -C /zig --strip-components 1

# Install ZLS
RUN git clone https://github.com/zigtools/zls && \
    cd zls && /zig/zig build -Doptimize=ReleaseSafe && \
    install /zls/zig-out/bin/zls /zig/

ENV PATH="/zig:$PATH"

