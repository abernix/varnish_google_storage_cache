FROM varnish:6.3

COPY default.vcl /etc/varnish/

CMD varnishd -F -f /etc/varnish/default.vcl -a ":${PORT:-80}"
