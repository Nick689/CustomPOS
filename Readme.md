##Description
CustomPOS is a retail Point of Sale system.
It is not really a program as it is only a spreadsheet with macros.
LibreOffice is used for GUI and MySQL for database. No data is stored in client side. For backup you only have to save the database.
The GUI has been designed to be extremely efficient with only one page POS, there is no sub-page, only one pop-up confirmation message will be displayed before invoice validation.



##[Screenshot](https://github.com/Nick689/CustomPOS/blob/master/Preview/ViewAll.md)




##Features
* Multi-user
* Multi-session
* Easy to customize with easy macro code
* Built-in PDF export
* Barcode printing (code128 only)
* Cash register check fit in one printable page and support multiple cashier 
* Data export has never been so easy, you are already in Calc
* Advanced user right management
* Advanced pricing management with selectable scenarios for each item



##Planned features
* Multilingual management
* Windows, OSX version
* Statistics
* Address book



##Performance, Advancement
Only Linux-French version is currently available.
The item edit page does not exist yet, but you can edit the database directly.
Most important features are already implemented and this program is already used in production.
You should find a comfortable reactivity and stability, but each change can break everything so that you should fully debug/test new version on a testing database before using in production.
The program's code is not yet securely locked and can be hacked by advanced users.
Although CustomPOS could support an unlimited number of users and do not load heavily the server, it is not recommended for big companies, considering that LibreOffice has powerful features that can not all be locked.
There is 1 or 2 seconds lag in client printing functions.



##Limitations
* Max number of invoice: 18446744073709551615 BIGINT(20)
* Max number of sold item: 18446744073709551615 BIGINT(20)
* Max number of item per invoice: 100 (limited by mysql connector)
* Number of reference per item: 6 (can be extended)



##Install (In construction)
Login:  Only one user is declared in default database. Passwords are managed in MySQL. You will have to grant new users in MySQL.



##Usage
Quantity check:  Instead of forcing stock quantity records without any justification, you can call "chk" stored procedure that will check every sales/arrivals and give you the theoretic quantity and the difference with current quantity for every items.

Inventory:  There is no inventory module in CustomPOS, however you can adjust the stock by invoicing to a special "Inventory" customer the properly signed quantity of 0 priced item (the purpose for the "FREE" button).

Stock moving, stock management:  See "Inventory", operate the same way.

Barcode:  Delete any zero at the beginning of barcodes record otherwise it will not work.
Linux user have to disable shift key while scanning case sensitive barcodes.

Special items:
*  *DIV* is the reference for miscellaneous item, it has editable name.
*  '  Single quote at the beginning of the name indicate a comment.

##[License](License.md)
CustomPOS is published under GNU GPLv2
* You can copy and distribute this code as it is.
* You can copy and modify this code for personal use.
* If you distribute a program using a modified version of this code you have to publish your code under the same GPL license.
