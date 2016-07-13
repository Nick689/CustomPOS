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
GRANT SELECT,UPDATE ON mybase.customer TO 'user'@'ip';
GRANT SELECT,INSERT ON mybase.devis TO 'user'@'ip';
GRANT SELECT,INSERT ON mybase.devisdet TO 'user'@'ip';
GRANT SELECT,INSERT ON mybase.entree TO 'user'@'ip';
GRANT SELECT,INSERT ON mybase.entreedet TO 'user'@'ip';
GRANT SELECT,INSERT ON mybase.fact TO 'user'@'ip';
GRANT SELECT,INSERT ON mybase.factdet TO 'user'@'ip';
GRANT SELECT ON mybase.fourn TO 'user'@'ip';
GRANT SELECT ON mybase.regl TO 'user'@'ip';
GRANT SELECT,UPDATE ON mybase.stk TO 'user'@'ip';
GRANT SELECT ON mybase.output TO 'user'@'ip';
GRANT SELECT ON mybase.utilisateur TO 'user'@'ip';
GRANT UPDATE (freecell) ON mybase.utilisateur TO 'user'@'ip';
GRANT EXECUTE ON PROCEDURE mybase.soldes TO 'user'@'ip';
GRANT EXECUTE ON PROCEDURE mybase.fdj TO 'user'@'ip';
FLUSH PRIVILEGES;
```
##Client:
- Install libreoffice-calc
- Install libreoffice-base
- copy CustomPOS.ods, Database.odb and Balance.ods in any user directory
- Add Database.odb to your database list in Tools/Options/LibreOfficeBase/Database or create a new database connection in Base and name it "mybase". If you want to manage several database, you will have to change the database name in "notconnected" function and save setting in a different .ods file:
```
source=createUnoService("com.sun.star.sdb.DatabaseContext").GetByName("yourdatabasename")
```
- Select "High security" in Tools/LibreOffice/Security/MacroSecurity and add the directory where is CustomPOS.ods in Trusted Locations
- sudo apt-get install libreoffice-mysql-connector                  #mysql connector for local and remote access
- sudo mkdir /usr/share/fonts/truetype/code128                      #barcode font install
- sudo mv code128.ttf /usr/share/fonts/truetype/code128/code128.ttf #place code128.ttf file in your home directory before
- sudo fc-cache -f -v                                               #will recharge font list



#SETTINGS (In construction)
- Default password is empty, you must change it to secure the spreadsheet: Change the value of "pass" variable in "global" library
- Most of parameters are declared at the begining of "global" library, set correctly yours printers names, files location, GST, and more ...
- Users and theirs rights must be defined in "utilisateur" table
- Enable "Load User Setting with document" in Tools/Options/Saving/General/
- Enable "Load Printer Setting with document" in Tools/Options/Saving/General/
- Disable "auto-save" in Tools/Options/Saving/General/


#USAGE AND ADVISES (In construction)
Quantity check:  Instead of forcing stock quantity records without any justification, you can call "chk" stored procedure that will check every sales/arrivals and give you the theoretic quantity and the difference with current quantity for every items.

Inventory:  There is no inventory module in CustomPOS, however you can adjust the stock by invoicing to a special "Inventory" customer the properly signed item quantity with 0 for price (the purpose for the "FREE" button).

Stock moving, stock management:  See "Inventory", operate the same way.

Barcode:  Delete any zero at the beginning of barcodes record otherwise it will not work.
Linux user have to disable shift key while scanning case sensitive barcodes.

Special items:
*  *DIV* is the reference for miscellaneous item, it has editable name.
*  '  Single quote at the beginning of the name indicate a comment.
