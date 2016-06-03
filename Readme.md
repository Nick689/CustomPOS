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
* Extensive and efficient cash register check that can be completed in seconds
* Data export has never been so easy, you are already in Calc
* Advanced user right management
* Advanced pricing management with selectable scenarios for each item



##Planned features
* Multilingual version
* Windows, OSX version
* Statistics
* Address book



##Performance, Advancement
Only Linux-French version is currently available. The item edit page does not exist yet, but you can edit the database directly. Most important features are implemented and this program is already used in production. You should find a comfortable reactivity and stability, but each change can break everything. And you should fully debug/test new version on a testing database before using it in production.

Despite CustomPOS's powerful features with unlimited number of users and a light-weight server load, it is not recommended for big companies, considering that LibreOffice has powerful features that can not all be locked and advanced users can hack it.
There is also 1 or 2 seconds lag in client printing functions.



##Limitations
* Max number of invoice: 18446744073709551615 BIGINT(20)
* Max number of sold item: 18446744073709551615 BIGINT(20)
* Max number of item per invoice: 100 (limited by mysql connector)
* Number of reference per item: 6 (can be extended)

##[License](License.md)
CustomPOS is published under GNU GPLv2
* You can copy and distribute this code as it is.
* You can copy and modify this code for personal use.
* If you distribute a program using a modified version of this code you have to publish your code under the same GPL license.
