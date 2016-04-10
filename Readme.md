##Description
CustomPOS is a retail Point of Sale system.
It is not really a program as it is only a spreadsheet with macros.
LibreOffice is used for GUI and MySQL for database. No data is stored in client side. You only have to backup the server database.
The GUI is extremely efficient with only one page POS, there is no sub-page, only one pop-up confirmation message will be displayed before invoice validation.



##[Screenshot](https://github.com/Nick689/CustomPOS/wiki/Screenshot)




##Features
* Multi-user
* Multi-session
* Data export has never been so easy, you are already in Calc
* Easy to customize with easy macro code
* PDF export
* Barcode printing (code128)
* You will be surprised by the efficiency of the cash register check page
* Advanced user right management
* Advanced pricing management with selectable scenarios for each item



##Planned features
* Multilingual management
* Windows, OSX version
* Stronger security with the use of macro protection but only available in OpenOffice, not in LibreOffice !??
* Statistics
* Address book



##Not planned features (unless you want to code it)
* Items equivalence-replacement
* Item group composition
* Accounting



##Advancement
The item edit page does not exist yet, but you can edit the database directly.
Only Linux-French version is currently available.
Most important features are already implemented, this program is already used in production.
You should find a good reactivity/stability.
Take care to fully debug/test new version on a test database before using in production.



##Performance
Heavy loads are not yet tested. MySQL is responding well on a i7-4770K server with 5 users connected.
There is 1 or 2 seconds lag in client printing functions.



##Limitations
* Max number of invoice: 18446744073709551615 BIGINT(20)
* Max number of sold item: 18446744073709551615 BIGINT(20)
* Max number of item per invoice: 100 (limited by mysql connector)
* Number of reference per item: 6 (can be extended)



##Install
...In construction




##Usage
Login:  Only one user is declared in default database. Passwords are managed in MySQL. You will have to grant new users in MySQL.

Special items:
*  *DIV* is the reference for miscellaneous item, it has editable name.
*  '  Single quote at the beginning of the name indicate a comment.

Quantity management:  Before adjusting item record quantity you can call "chk" stored procedure that will check every sales/arrivals and give you the theoretic quantity and difference with current quantity for every items. It is advised to keep adjusted yours sales/arrivals records instead of forcing item's quantity without justification.

Inventory:  There is no inventory module. "Inventory" is managed in CustomPOS as a special customer whose every invoiced item will be 0 priced (the purpose for "FREE" button).

Stock moving, stock management:  See "Inventory", same operation.

Barcode:  Delete any zero at the beginning of barcodes record otherwise it will not work.
Linux user have to disable shift key while scanning case sensitive barcodes.

##[License](License.md)
CustomPOS is published under GNU GPLv2
* You can copy and distribute this code as it is.
* You can copy and modify this code for personal use.
* If you distribute a program using a modified version of this code you have to publish your code under the same GPL license.


