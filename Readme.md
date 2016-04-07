##Description
CustomPOS is a retail Point of Sale system.
It is not really a program as it is only made of a spreadsheet with scripts.
LibreOffice is used for GUI and MySQL for database. No data is stored on client side. you only have to backup the server database.
The interface is extremely efficient with only one page POS, there is no sub-page, only one pop-up confirmation message will be displayed before invoice validation.



##[Screenshot](https://github.com/Nick689/CustomPOS/wiki/Screenshot)




##Features
* Multi-user
* Multi-session
* Easy data export
* Easy to customize
* PDF export
* Barcode printing (code128)
* One button EndofDay totals
* Advanced user right management
* Advanced pricing management with scenarios
* Secured "enough" for newbies



##Not planned features (unless you want to code it)
* Items equivalence-replacement
* Item group composition
* Accounting



##Advancement
Only French version is currently available.
Most important features are already implemented, this program is already used in production.
You should find a good reactivity/stability.
Take care to fully debug/test new version on a test database before using in production.



##Performance
Heavy loads are not yet tested.
On i7-4770K server, MySQL is responding well with 5 users connected.
I'm planning to move it on a i5-6260U + nvmeSSD.
There is 1 or 2 seconds lag in client printing functions.



##Limitations
* Max number of invoice: 18446744073709551615 BIGINT(20)
* Max number of sold item: 18446744073709551615 BIGINT(20)
* Max number of item per invoice: 100 (limited by mysql connector)
* Number of reference per item: 6 (can be extended)



##Planned features
* Stronger security with the use of macro protection but only available in OpenOffice, not in LibreOffice !??
* Multilingual management
* Statistics per item
* Statistics per customer
* Statistics per period
* Statistics per branch
* Address book



##Install
...In construction




##Usage
Login:  Only one user is declared in default database: <root>    Password is managed by MySQL directly

Special item:
 -  *DIV* is the reference for miscellaneous item, it has editable name
 -  '  Single quote at beginning of the name indicate a comment



##[License](/License.md)
CustomPOS is published under GNU GPLv2
* You can copy and distribute this code as it is.
* You can copy and modify this code for personal use.
* If you distribute a program using a modified version of this code you have to publish your code under the same GPL license.


