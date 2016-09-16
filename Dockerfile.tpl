FROM #{FROM}

RUN apt-get update \
	&& apt-get install -y git zlib1g-dev build-essential liblzma curl pkg-config python-pip ca-certificates libssl-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& pip install awscli

ENV KMOD_VERSION 23
ENV KMOD_CHECKSUM b70f21c919bb44e7dd50b82a8adda3e27416ccf4cc812ab9d3ca4bf7597009cd

RUN curl -SLO https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-$KMOD_VERSION.tar.gz \
	&& echo "$KMOD_CHECKSUM  kmod-$KMOD_VERSION.tar.gz" | sha256sum -c - \
	&& mkdir /kmod-$KMOD_VERSION \
	&& tar -xzf kmod-$KMOD_VERSION.tar.gz -C /kmod-$KMOD_VERSION --strip-components=1 \
	&& rm -f kmod-$KMOD_VERSION.tar.gz

COPY . /
