# CLIENT INSTALL (in construction)

- apt-get install libreoffice-base
- apt-get install libreoffice-mysql-connector
- apt-get install ntpdate
- sudo nano /etc/default/ntpdate
  - NTPDATE_USE_NTP_CONF=no
  - NTPSERVERS="yourNTPserverIP"
