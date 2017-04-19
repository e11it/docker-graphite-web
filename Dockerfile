FROM alpine:3.4

# ORIGINAL MAINTAINER Alex Akulov <alexakulov86@gmail.com>
MAINTAINER <im@e11it.ru>

RUN	apk add --no-cache nginx supervisor build-base python-dev py-pip py-cffi py-cairo tzdata
	
RUN pip install --no-binary=:all: https://github.com/graphite-project/graphite-web/archive/1.0.0.tar.gz

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
ADD ./config/graphouse.py /opt/graphite/webapp/graphite/graphouse.py
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
