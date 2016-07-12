##Install (In construction)

- sudo apt-get install libreoffice-mysql-connector                  #mysql connector for local and remote access
- sudo mkdir /usr/share/fonts/truetype/code128                      #barcode font install
- sudo mv code128.ttf /usr/share/fonts/truetype/code128/code128.ttf #place code128.ttf file in your home directory before
- sudo fc-cache -f -v                                               #will recharge font list



##Settings (In construction)
- Default MySQL settings work. no need to change anything, except IP and port
- Inject Dump.sql file
- Only "root" user is declared in default database.
- You will have to create and grant new users in MySQL with this type of privileges:
```
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
```
- In addition to declaring user in MySQL you will have to add them in "utilisateur" table
- default password is empty so that you must change it to secure the program. Change "pass" variable in "global" library
- Most of parameters are declared at the begining of "global" library, set correctly yours printers, files location, GST, and more ...



##Usage and advise (In construction)
Quantity check:  Instead of forcing stock quantity records without any justification, you can call "chk" stored procedure that will check every sales/arrivals and give you the theoretic quantity and the difference with current quantity for every items.

Inventory:  There is no inventory module in CustomPOS, however you can adjust the stock by invoicing to a special "Inventory" customer the properly signed item quantity with 0 for price (the purpose for the "FREE" button).

Stock moving, stock management:  See "Inventory", operate the same way.

Barcode:  Delete any zero at the beginning of barcodes record otherwise it will not work.
Linux user have to disable shift key while scanning case sensitive barcodes.

Special items:
*  *DIV* is the reference for miscellaneous item, it has editable name.
*  '  Single quote at the beginning of the name indicate a comment.
