FROM ubuntu:trusty
MAINTAINER ClassCat Co.,Ltd. <support@classcat.com>

########################################################################
# ClassCat/Ganglia-Monitor Dockerfile
#   Maintained by ClassCat Co.,Ltd ( http://www.classcat.com/ )
########################################################################

#--- HISTORY -----------------------------------------------------------
# 02-jun-15 : Kick gmond at CMD.
# 02-jun-15 : fixed.
#-----------------------------------------------------------------------

RUN apt-get update && apt-get -y upgrade \
  && apt-get install -y language-pack-en language-pack-en-base \
  && apt-get install -y language-pack-ja language-pack-ja-base \
  && update-locale LANG="en_US.UTF-8" \
  && apt-get install -y openssh-server supervisor rsyslog mysql-client \
  && apt-get install -y ganglia-monitor \
  && apt-get clean \
  && mkdir -p /var/run/sshd \
  && sed -ri "s/^PermitRootLogin\s+.*/PermitRootLogin yes/" /etc/ssh/sshd_config
# RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

COPY assets/supervisord.conf /etc/supervisor/supervisord.conf
COPY assets/gmond.conf /etc/ganglia/gmond.conf

WORKDIR /opt
ADD assets/cc-init.sh /opt/cc-init.sh

EXPOSE 22

CMD /opt/cc-init.sh; service ganglia-monitor restart; /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
