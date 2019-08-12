FROM python:3.6

RUN apt-get -y update && apt-get -y install libldap2-dev libsasl2-dev graphviz && apt-get clean
RUN pip install --no-cache-dir gunicorn django-auth-ldap whitenoise

WORKDIR /opt

ARG BRANCH=v2.6.2
ARG URL=https://github.com/digitalocean/netbox/archive/$BRANCH.tar.gz
RUN wget -q -O - "${URL}" | tar xz \
  && mv netbox* netbox

WORKDIR /opt/netbox
RUN pip install --no-cache-dir -r requirements.txt

COPY configuration.docker.py /opt/netbox/netbox/netbox/configuration.py
COPY gunicorn_config.py /opt/netbox/
COPY custom_wsgi.py /opt/netbox/netbox

WORKDIR /opt/netbox/netbox

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]

EXPOSE 8001

CMD ["gunicorn", "--log-level debug", "-c /opt/netbox/gunicorn_config.py", "custom_wsgi"]
