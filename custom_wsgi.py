from whitenoise import WhiteNoise

from netbox.wsgi import application

application = WhiteNoise(application, root='/opt/netbox/netbox/static', prefix='/static')