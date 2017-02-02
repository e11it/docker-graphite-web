FROM centos:7.3.1611

MAINTAINER Alex Akulov <alexakulov86@gmail.com>

RUN	touch /etc/udev/rules.d/40-vm-hotadd.rules
RUN	yum install -y epel-release
RUN	yum install -y gcc
RUN	yum install -y python-devel python-pip pycairo nginx supervisor

RUN	pip install twisted==13.1 gunicorn gevent django==1.6 django-tagging==0.3.6 pytz pyparsing python-memcached whisper==0.9.15
RUN	yum remove -y gcc python-devel && \
	yum autoremove -y

RUN	pip install https://github.com/skbkontur/graphite-web/archive/0.9.x-performance.zip

RUN	useradd -r graphite && \
	mkdir -p /opt/graphite/webapp/graphite /var/log/graphite /opt/graphite/storage/whisper

ENV	TZ=UTC \
	GRAPHITE_STORAGE_DIR=/opt/graphite/storage \
	GRAPHITE_CONF_DIR=/opt/graphite/conf \
	PYTHONPATH=/opt/graphite/webapp \
	LOG_DIR=/var/log/graphite \
	DEFAULT_INDEX_TABLESPACE=graphite \
	GUNICORN_WORKERS=2

ADD ./config/graphite_wsgi.py /opt/graphite/conf/graphite_wsgi.py
ADD ./config/local_settings.py /opt/graphite/webapp/graphite/local_settings.py
ADD ./config/initial_data.json /opt/graphite/webapp/graphite/initial_data.json
ADD ./config/nginx.conf /etc/nginx/nginx.conf
ADD ./config/supervisord.conf /etc/supervisor/supervisord.conf

# Initialize database(sqlite3)
RUN	cd /opt/graphite/webapp/graphite && django-admin.py syncdb --settings=graphite.settings --noinput && \
	cd /opt/graphite/webapp/graphite && django-admin.py loaddata --settings=graphite.settings initial_data.json && \
	chown -R graphite:graphite /opt/graphite /var/log/graphite

WORKDIR /opt/graphite/webapp
EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
