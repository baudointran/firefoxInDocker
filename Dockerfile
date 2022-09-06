FROM ubuntu:bionic 
ARG user
ARG uid
ARG gid

#Add new user with our credentials
ENV USERNAME ${user}
RUN useradd -m $USERNAME && \
        echo "$USERNAME:$USERNAME" | chpasswd && \
        usermod --shell /bin/bash $USERNAME && \
        usermod  --uid ${uid} $USERNAME && \
        groupmod --gid ${gid} $USERNAME

USER ${user}

WORKDIR /home/${user}

USER root

RUN buildPkgs="curl ca-certificates libx11-xcb1 libgtk-3-0 libdbus-glib-1-2 libxt6" ; \
    apt-get update && apt-get install -y --no-install-recommends $buildPkgs

RUN curl https://ftp.mozilla.org/pub/firefox/releases/78.15.0esr/linux-x86_64/fr/firefox-78.15.0esr.tar.bz2 --output firefox.78.15.0esr.tar.bz2 && tar xjf firefox.78.15.0esr.tar.bz2

USER ${user}
CMD firefox/firefox
