# CLIENT INSTALL (in construction)

### Packages install
- apt-get install libreoffice-calc (if not installed)
- apt-get install libreoffice-base (if not installed)
- apt-get install libreoffice-mysql-connector
- apt-get install ntpdate
- sudo nano /etc/default/ntpdate
  - NTPDATE_USE_NTP_CONF=no
  - NTPSERVERS="yourNTPserverIP"
- sudo ntpdate *serverip* (to check if you can connect to the server)
- Create a new directory where you will place CustomPOS.ods  and Balance.ots

### Database connection
- create a new database in Libreoffice Base
  - File menu > New database
  - Connect to an existant database (MySQL)
  - Direct connection
  - Database name: custompos, *IP, port*
  - Select "Password is required"
  - Select "register the database", "open for edition"

### Files parameters
- Adjust LibreOffice security
  Option menu > Security > Macro security > Security Level > Very High
                                          > Trusted sources > Trusted directories > Folder where is CustomPOS.ods
- Adjust parameters in CustomPOS.ods (needed one time, then you can duplicate file)

- Disable Auto-completion
- Disable Auto-correction
- Disable Auto-save
- Setup shortcut keys
