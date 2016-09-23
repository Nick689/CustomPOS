#INSTALL (In construction)
##Server:
- sudo apt-get install mysql-server
- Default MySQL settings works, no need to change anything, except IP and port

##Administrator:
- Install **MySQL workbench** or any mysql manager
- Inject **Dump.sql**
- Inject **Stored procedures.sql**
- Create and grant **new users** like this:
```
CREATE USER 'newuser'@'ip' IDENTIFIED BY 'password';
GRANT SELECT,UPDATE ON mybase.customer TO 'newuser'@'ip';
GRANT SELECT,INSERT ON mybase.devis TO 'newuser'@'ip';
GRANT SELECT,INSERT ON mybase.devisdet TO 'newuser'@'ip';
GRANT SELECT,INSERT ON mybase.entree TO 'newuser'@'ip';
GRANT SELECT,INSERT ON mybase.entreedet TO 'newuser'@'ip';
GRANT SELECT,INSERT ON mybase.fact TO 'newuser'@'ip';
GRANT SELECT,INSERT ON mybase.factdet TO 'newuser'@'ip';
GRANT SELECT ON mybase.fourn TO 'newuser'@'ip';
GRANT SELECT ON mybase.regl TO 'newuser'@'ip';
GRANT SELECT,UPDATE ON mybase.stk TO 'newuser'@'ip';
GRANT SELECT ON mybase.output TO 'newuser'@'ip';
GRANT SELECT ON mybase.utilisateur TO 'newuser'@'ip';
GRANT UPDATE (freecell) ON mybase.utilisateur TO 'newuser'@'ip';
GRANT EXECUTE ON PROCEDURE mybase.soldes TO 'newuser'@'ip';
GRANT EXECUTE ON PROCEDURE mybase.fdj TO 'newuser'@'ip';
FLUSH PRIVILEGES;
```
- **MACRO SETTING:** The password used to protect CustomPOS.ods is empty by default, you must change it in two locations: -- change the value for "pass" variable in "global" library
-- the same password is combined to the database users passwords you have to change like this:
```
SET PASSWORD FOR 'bob'@'ip' = PASSWORD('newpassword');
```
- **DATABASE SETTING:** Users and theirs rights must be defined in "utilisateur" table
- **MACRO SETTING:** Most parameters are declared at the begining of "global" library. Set correctly yours printers names, files location, GST, ...
- **MACRO SETTING:**  Printer settings are defined in "iprint" and "label" libraries. For detailed printer setting see [this](https://wiki.openoffice.org/wiki/Documentation/BASIC_Guide/StarDesktop).

##Client:
- Install libreoffice-calc
- Install libreoffice-base
- copy CustomPOS.ods, Database.odb and Balance.ods in any user directory
- sudo apt-get install libreoffice-mysql-connector                  #mysql connector for local and remote access

commande for barcode font install if your font manager don't work:
- sudo mkdir /usr/share/fonts/truetype/code128
- sudo mv code128.ttf /usr/share/fonts/truetype/code128/code128.ttf #place code128.ttf file in your home directory before
- sudo fc-cache -f -v                                               #will recharge font list

- **CALC SETTING:** Add Database.odb to your database list in Tools/Options/LibreOfficeBase/Database or create a new database connection in Base and name it "mybase". If you want to manage several database, you will have to change the database name in "notconnected" function and save setting in a different .ods file:
```
source=createUnoService("com.sun.star.sdb.DatabaseContext").GetByName("yourdatabasename")
```
- For multi-session ability you simply need to duplicate CustomPOS.ods file you can rename as you like.
- **CALC SETTING:** Select "High security" in Tools/LibreOffice/Security/MacroSecurity and add the directory where is CustomPOS.ods in Trusted Locations
- **CALC SETTING:** Enable "Load User Setting with document" in Tools/Options/Saving/General/
- **CALC SETTING:** Enable "Load Printer Setting with document" in Tools/Options/Saving/General/
- **CALC SETTING:** Disable "auto-save" in Tools/Options/Saving/General/

#USAGE AND ADVISES (In construction)
**Quantity check:**  Instead of forcing stock quantity records without any justification, you can call "chk" stored procedure that will check every sales/arrivals and give you the theoretic quantity and the difference with current quantity for every items.

**Inventory:**  There is no dedicated inventory module in CustomPOS, however you can adjust quantities by charging "Inventory" special customer account with the properly signed quantity, 0 priced (the purpose for the "FREE" button) item you want to adjust.

**Stock moving-management:**  See "Inventory", same operation.

**Barcode:**  Delete any zero at the beginning of barcode database record otherwise it will not work.
Linux user have to disable shift key while scanning case sensitive barcode.

**Special items:**
- **DIV** is the reference for miscellaneous item, it has editable name. This item is identified by "misc" constant you have to define in "global" library.
- **'**  Single quote at the beginning of the name indicate a comment.
