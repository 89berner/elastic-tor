#BASED FROM https://github.com/patrickod/docker-tor

FROM ubuntu
MAINTAINER "Juan <89berner@gmail.com>"

EXPOSE 9001
EXPOSE 9051
ENV VERSION 0.2.5.10

RUN apt-get update && apt-get install -y \
   build-essential \
   curl \
   libevent-dev \
   libssl-dev

RUN curl https://dist.torproject.org/tor-${VERSION}.tar.gz | tar xz -C /tmp

RUN cd /tmp/tor-${VERSION} && ./configure
RUN cd /tmp/tor-${VERSION} && make
RUN cd /tmp/tor-${VERSION} && make install

ADD ./torrc /etc/torrc
# Allow you to upgrade your relay without having to regenerate keys
VOLUME /.tor

# Generate a random nickname for the relay
RUN echo "Nickname nickname$(head -c 16 /dev/urandom  | sha1sum | cut -c1-10)" >> /etc/torrc

CMD /usr/local/bin/tor -f /etc/torrc
