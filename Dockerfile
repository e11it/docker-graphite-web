FROM alpine:3.4

MAINTAINER Alex Akulov <alexakulov86@gmail.com>

RUN	apk add --no-cache nginx supervisor build-base python-dev py-pip py-cffi py-cairo py-cairo-dev tzdata
	
RUN	pip install twisted==13.1 gunicorn gevent django==1.6 django-tagging==0.3.6 pytz pyparsing==1.5.7 python-memcached==1.47 whisper==0.9.15 cairocffi constants simplejson==2.1.6 whitenoise

RUN	pip install https://github.com/skbkontur/graphite-web/archive/stable.zip

RUN	addgroup -S graphite && \
	adduser -S graphite -G graphite && \
	mkdir -p /opt/graphite/webapp/graphite /var/log/graphite /opt/graphite/storage/whisper /var/log/supervisor

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
ADD ./docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

# Initialize database(sqlite3)
RUN 	cd /opt/graphite/webapp/graphite && django-admin.py syncdb --settings=graphite.settings --noinput && \
	cd /opt/graphite/webapp/graphite && django-admin.py loaddata --settings=graphite.settings initial_data.json && \
	touch /opt/graphite/storage/index && \
	chown -R graphite:graphite /opt/graphite /var/log/graphite

WORKDIR /opt/graphite/webapp
EXPOSE 80

CMD ["/usr/bin/docker-entrypoint.sh"]
