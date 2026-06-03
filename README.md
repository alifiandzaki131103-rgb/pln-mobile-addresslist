# MikroTik Address List PLN Mobile

Script MikroTik untuk membuat address-list aplikasi PLN Mobile.

## File

- `pln-mobile-addresslist-ros7.rsc` — RouterOS v7, memakai `tls-host`.
- `pln-mobile-addresslist-ros6.rsc` — RouterOS v6, memakai `layer7-protocol` + resolve domain.
- `pln-mobile-addresslist.rsc` — file awal ROS7, dipertahankan untuk kompatibilitas.

## RouterOS v7

Import:

```rsc
/import file-name=pln-mobile-addresslist-ros7.rsc
```

Metode:

- Deteksi SNI HTTPS pakai `tls-host`.
- Tambah IP tujuan ke address-list `PLN-MOBILE`.
- Lebih rapi daripada ROS6.

## RouterOS v6

Import:

```rsc
/import file-name=pln-mobile-addresslist-ros6.rsc
```

Metode:

- RouterOS v6 tidak punya `tls-host` mangle seperti ROS7.
- Pakai `layer7-protocol` untuk hostname HTTP/TLS ClientHello.
- Tambah hasil resolve domain utama ke address-list `PLN-MOBILE`.

## Cek hasil

```rsc
/ip firewall address-list print where list="PLN-MOBILE"
```

## Catatan penting

- IP aplikasi bisa berubah karena CDN.
- ROS7 lebih disarankan.
- ROS6 tidak seakurat ROS7.
- Jika aplikasi pakai IP langsung, DoH, certificate pinning, QUIC/HTTP3, ECH, rule bisa tidak menangkap semua trafik.
- Opsi drop QUIC tersedia dalam file `.rsc`, masih dikomentari.
