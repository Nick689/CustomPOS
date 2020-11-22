## Not working on Debian 10 (see details in wiki)

## Description
CustomPOS is a retail Point of sale system based on LibreOffice and written with macro you can customize easily. Don't think it is a simple spreadsheet file, it has network multi-user capabilities and use proven database engine. Reduced typing needs interface allow great efficiency like in POS module made of one page only where invoices are recorded after one popup.


CustomPOS main concepts:
- You can customize this program easily with basic programing skill. Some module has to be rewritten to fit yours needs, then you will appreciate full control over your software.
- Database content and organisation is the simplest possible. In combination with full database access it let you manage data in a diferent and more efficient way never seen in any other software.
- You are the master of your data: full database access let you develop new fonction like e-commerce, statistic, accounting, etc ...

## [Screenshot](https://github.com/Nick689/CustomPOS/blob/master/Preview/ViewAll.md)
Click the link ↑

## Features
* Unlimited users number
* Unlimited sessions number
* 3 ways product input:
  - Type one of the 6 reference codes
  - Scan barcode
  - If first methods fail a list of similar named product will be proposed
* Data update can be made with powerfull [spreadsheet style](https://github.com/Nick689/CustomPOS/blob/master/Preview/Stk.png) database editors
* Built-in PDF & PNG export
* Barcode printing (code128 or EAN13)
* Shortcut keys allow you to work with keybord only
* Multi-item combination insert
* Multi-cell copy-paste allow list insert
* Advanced pricing management with selectable scenarios for each item
* Detailed incomes page shows real time incomes for today or for any selected day
* Data export has never been so easy, you are already in Calc
* Advanced user right management
* Full database access (via LibreOffice Base or via SQL request) let you correct any mistake easily

 Yes, it is dangerous and it's the open door to mistakes that will be detected by the following modules:
* Invoice check module compare invoice's details with invoice's header and list every incoherencies
* Stock check module calculate for each item the theoretical quantity and the gap with current stock by compiling every input and output

## Planned features
* A single user simple to install version will be available later but you can install the client-server version for immediate use.
* Localized versions
* Sales statistics

## Advancement
Only Linux-French version is currently available.
Item edit page is not planned anymore, direct database edit has not caused me any trouble till now, but you have to be very carefull.
Only main features are currently available. Statistics have to be done externaly. Stability is good without being as good as other classic programs, but don't worry, data loss cannot happen with transactional request. Last version is the 0.7. See changelog in Wiki section for versions notes.

## Limitations
Despite CustomPOS's capability to handle many users, it is not recommended for big companies. You have to deal with LibreOffice powerful features that cannot all be locked so that advanced users can hack it.

* Max number of invoice: 18446744073709551615 BIGINT(20)
* Max number of sold item: 18446744073709551615 BIGINT(20)  (can be reseted after invoices archiving)
* Max number of item per invoice: 100 (limited by mysql connector)
* Number of reference per item: 6 (can be extended)

Demo version can only manage one user at a time due to the limitation of used database (HSQLDB)

## Licence
This program is free to use and to modify.
