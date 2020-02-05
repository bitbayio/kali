FROM kalilinux/kali-rolling

RUN echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list && \
    echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive
ENV TINI_VERSION v0.15.0
ENV HOME=/root \
    SHELL=/bin/bash

RUN apt-get -y update && apt-get -y dist-upgrade && apt-get clean \
    && apt-get install -y --no-install-recommends software-properties-common curl

RUN apt-get install -y --no-install-recommends --allow-unauthenticated \
      openssh-server pwgen sudo vim-tiny \
	    supervisor \
      net-tools \
      lxde x11vnc xvfb autocutsel \
      xfonts-base lwm xterm \
      nginx \
      python-pip python-dev build-essential \
      mesa-utils libgl1-mesa-dri \
      dbus-x11 x11-utils \
      && apt-get -y autoclean \
      && apt-get -y autoremove \
      && rm -rf /var/lib/apt/lists/*

# For installing Kali metapackages
RUN apt-get update && apt-cache search kali-linux && apt-get install -y \
      kali-desktop-xfce \
      kali-linux-full


ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

ADD image /
RUN pip install setuptools wheel && pip install -r /usr/lib/web/requirements.txt

EXPOSE 80

WORKDIR /root

ENTRYPOINT ["/startup.sh"]

CMD ["/bin/bash"]
