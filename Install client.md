# CLIENT INSTALL (in construction)

### Packages & files install
- apt-get install libreoffice-calc (if not installed)
- apt-get install libreoffice-base (if not installed)
- apt-get install libreoffice-mysql-connector
- apt-get install ntpdate
- sudo nano /etc/default/ntpdate
  - NTPDATE_USE_NTP_CONF=no
  - NTPSERVERS="yourServerIP"
- sudo ntpdate *serverip* (to check if you can connect to the server)
- Create a new directory where you will place CustomPOS.ods  and Balance.ots

### Database connection setting
- create a new database in Libreoffice-Base: File menu > New database
- Connect to an existing database (MySQL)
- Direct connection
- Database name: custompos, *IP, port*
- Select "Password is required"
- Select "register the database", "open for edition"
you can modify settings in Option menu > LibreOffice-Base > Databases

### CALC setting (optional for testing)
- Adjust LibreOffice security
  Option menu > Security > Macro security > Security Level > Very High
                                          > Trusted sources > Trusted directories > Folder where is CustomPOS.ods
- Disable Auto-completion
- Disable Auto-correction
- Disable Auto-save
- Setup shortcut keys to call related script in Global section

### CustomPOS.ods setting (to set one time, then you can duplicate file)
- 
- 
- 
