#!/bin/sh
set -e
set -x

apt-get purge "lxc-docker*" || true
apt-get purge "docker.io*" || true
apt-get -y update
apt-get -y install apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
if [ "$(sh -c '. /etc/os-release; echo $VERSION_ID')" -eq "7" ]; then
  echo "deb http://http.debian.net/debian wheezy-backports main" >> /etc/apt/sources.list.d/backports.list
  echo "deb https://apt.dockerproject.org/repo debian-wheezy main" > /etc/apt/sources.list.d/docker.list
else
  echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list
fi
apt-get -y update
apt-get -y install ${DOCKER_ENGINE:-docker-engine-1.12.1-0~wheezy}
service docker start
groupadd docker || true
gpasswd -a $VAGRANT_USERNAME docker
${WGET:-"curl -L"} https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION:-1.8.0}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
