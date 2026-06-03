# MikroTik Address List PLN Mobile

Script RouterOS v7 untuk membuat address-list dinamis aplikasi PLN Mobile memakai TLS SNI matcher.

## File

- `pln-mobile-addresslist.rsc`

## Cara pakai

Upload/import ke MikroTik:

```rsc
/import file-name=pln-mobile-addresslist.rsc
```

Cek address-list:

```rsc
/ip firewall address-list print where list="PLN-MOBILE"
```

## Catatan

- Butuh RouterOS v7.
- `tls-host` terbaca saat koneksi HTTPS awal.
- Jika aplikasi pakai IP langsung, DoH, certificate pinning, atau QUIC/HTTP3, rule bisa tidak menangkap semua trafik.
- Rule drop QUIC tersedia sebagai opsi dalam file `.rsc`.
