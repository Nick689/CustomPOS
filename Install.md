##Install (In construction)

sudo apt-get install libreoffice-mysql-connector                  #mysql connector for local and remote access
sudo mkdir /usr/share/fonts/truetype/code128                      #barcode font install
sudo mv code128.ttf /usr/share/fonts/truetype/code128/code128.ttf #place code128.ttf file in your home directory before
sudo fc-cache -f -v                                               #will recharge font list

Login:  Only one user is declared in default database. Passwords are managed in MySQL. You will have to grant new users in MySQL.



##Usage
Quantity check:  Instead of forcing stock quantity records without any justification, you can call "chk" stored procedure that will check every sales/arrivals and give you the theoretic quantity and the difference with current quantity for every items.

Inventory:  There is no inventory module in CustomPOS, however you can adjust the stock by invoicing to a special "Inventory" customer the properly signed item quantity with 0 for price (the purpose for the "FREE" button).

Stock moving, stock management:  See "Inventory", operate the same way.

Barcode:  Delete any zero at the beginning of barcodes record otherwise it will not work.
Linux user have to disable shift key while scanning case sensitive barcodes.

Special items:
*  *DIV* is the reference for miscellaneous item, it has editable name.
*  '  Single quote at the beginning of the name indicate a comment.
