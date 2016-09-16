FROM #{FROM}

RUN apt-get update \
	&& apt-get install -y \
		zlib1g-dev \
		liblzma-dev \
		curl \
		pkg-config \
		python-pip \
		ca-certificates \
		libssl-dev \
		xsltproc \
		autoconf \
		automake \
		libtool \
		gtk-doc-tools \
		build-essential \
		devscripts \
		debhelper \
		fakeroot \
		quilt \
		git-core \
		cmake \
		dpkg-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& pip install awscli

RUN echo "deb-src http://httpredir.debian.org/debian #{SUITE} main " >> /etc/apt/sources.list \
	&& apt-get update && apt-get source kmod

COPY . /
