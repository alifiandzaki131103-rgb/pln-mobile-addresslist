# MikroTik RouterOS v7 script
# Address-list dinamis untuk aplikasi PLN Mobile berbasis TLS SNI
# List hasil: PLN-MOBILE

/ip firewall address-list
remove [find list="PLN-MOBILE"]

/ip firewall mangle
remove [find comment~"PLN MOBILE"]

add chain=prerouting protocol=tcp dst-port=443 tls-host=*.pln.co.id \
    action=add-dst-to-address-list address-list=PLN-MOBILE address-list-timeout=1d \
    comment="PLN MOBILE - pln.co.id"

add chain=prerouting protocol=tcp dst-port=443 tls-host=*.plnmobile.com \
    action=add-dst-to-address-list address-list=PLN-MOBILE address-list-timeout=1d \
    comment="PLN MOBILE - plnmobile.com"

add chain=prerouting protocol=tcp dst-port=443 tls-host=*.iconpln.co.id \
    action=add-dst-to-address-list address-list=PLN-MOBILE address-list-timeout=1d \
    comment="PLN MOBILE - iconpln"

add chain=prerouting protocol=tcp dst-port=443 tls-host=*.pln123.co.id \
    action=add-dst-to-address-list address-list=PLN-MOBILE address-list-timeout=1d \
    comment="PLN MOBILE - pln123"

# Opsional: mark routing untuk pisah jalur internet
# /ip firewall mangle
# add chain=prerouting dst-address-list=PLN-MOBILE action=mark-routing \
#     new-routing-mark=to-PLN passthrough=no comment="ROUTE PLN MOBILE"

# Opsional: mark packet untuk queue/prioritas
# /ip firewall mangle
# add chain=prerouting dst-address-list=PLN-MOBILE action=mark-packet \
#     new-packet-mark=PLN-MOBILE-PACKET passthrough=no comment="PACKET PLN MOBILE"

# Opsional: drop QUIC supaya TLS-HOST detection lebih stabil
# /ip firewall filter
# add chain=forward protocol=udp dst-port=443 action=drop comment="DROP QUIC for TLS-HOST detection"

# Cek hasil:
# /ip firewall address-list print where list="PLN-MOBILE"
