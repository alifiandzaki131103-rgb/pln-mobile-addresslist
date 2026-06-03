# MikroTik RouterOS v6 script
# Address-list statis kandidat domain/IP untuk aplikasi PLN Mobile
# Catatan: RouterOS v6 tidak mendukung tls-host di mangle untuk add-dst-to-address-list seperti ROS7.
# Karena itu script ini memakai layer7-protocol untuk menangkap hostname di HTTP/TLS ClientHello.
# Hasil bisa tidak seakurat ROS7, terutama jika trafik memakai QUIC/HTTP3, ECH, IP langsung, atau CDN berubah.
# List hasil: PLN-MOBILE

/ip firewall address-list
remove [find list="PLN-MOBILE"]

/ip firewall layer7-protocol
remove [find name="pln-mobile-l7"]
add name="pln-mobile-l7" regexp="^.+(pln\\.co\\.id|plnmobile\\.com|iconpln\\.co\\.id|pln123\\.co\\.id).*$"

/ip firewall mangle
remove [find comment~"PLN MOBILE"]

add chain=prerouting protocol=tcp dst-port=80,443 layer7-protocol=pln-mobile-l7 \
    action=add-dst-to-address-list address-list=PLN-MOBILE address-list-timeout=1d \
    comment="PLN MOBILE ROS6 - L7 detect hostname"

# Opsional: tambahkan domain utama via DNS statis jika dipakai router sebagai DNS client/server.
# RouterOS v6 address-list tidak bisa isi FQDN langsung. Resolve manual bisa berubah mengikuti CDN.
# Jalankan ulang jika IP domain berubah.

:do {
    :local ip1 [:resolve "pln.co.id"]
    /ip firewall address-list add list=PLN-MOBILE address=$ip1 timeout=1d comment="PLN MOBILE ROS6 - resolve pln.co.id"
} on-error={ :log warning "PLN MOBILE ROS6: gagal resolve pln.co.id" }

:do {
    :local ip2 [:resolve "www.pln.co.id"]
    /ip firewall address-list add list=PLN-MOBILE address=$ip2 timeout=1d comment="PLN MOBILE ROS6 - resolve www.pln.co.id"
} on-error={ :log warning "PLN MOBILE ROS6: gagal resolve www.pln.co.id" }

:do {
    :local ip3 [:resolve "plnmobile.com"]
    /ip firewall address-list add list=PLN-MOBILE address=$ip3 timeout=1d comment="PLN MOBILE ROS6 - resolve plnmobile.com"
} on-error={ :log warning "PLN MOBILE ROS6: gagal resolve plnmobile.com" }

:do {
    :local ip4 [:resolve "iconpln.co.id"]
    /ip firewall address-list add list=PLN-MOBILE address=$ip4 timeout=1d comment="PLN MOBILE ROS6 - resolve iconpln.co.id"
} on-error={ :log warning "PLN MOBILE ROS6: gagal resolve iconpln.co.id" }

:do {
    :local ip5 [:resolve "pln123.co.id"]
    /ip firewall address-list add list=PLN-MOBILE address=$ip5 timeout=1d comment="PLN MOBILE ROS6 - resolve pln123.co.id"
} on-error={ :log warning "PLN MOBILE ROS6: gagal resolve pln123.co.id" }

# Opsional: mark routing untuk pisah jalur internet
# /ip firewall mangle
# add chain=prerouting dst-address-list=PLN-MOBILE action=mark-routing \
#     new-routing-mark=to-PLN passthrough=no comment="ROUTE PLN MOBILE"

# Opsional: mark packet untuk queue/prioritas
# /ip firewall mangle
# add chain=prerouting dst-address-list=PLN-MOBILE action=mark-packet \
#     new-packet-mark=PLN-MOBILE-PACKET passthrough=no comment="PACKET PLN MOBILE"

# Opsional: drop QUIC supaya deteksi L7 HTTPS lebih stabil
# /ip firewall filter
# add chain=forward protocol=udp dst-port=443 action=drop comment="DROP QUIC for L7 detection"

# Cek hasil:
# /ip firewall address-list print where list="PLN-MOBILE"
