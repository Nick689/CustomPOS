## Description
CustomPOS is a retail Point of sale system based on LibreOffice and writed with macro so that you can customize it easily. Don't think it is a simple spreadsheet file, it has network multi-user capabilities and use proven database engine. The interface has been designed for the best efficiency with reduced typing needs. POS module is made of one page only where invoices are recorded after one popup only.

CustomPOS main concepts are:
- You can customize this program easily with only basic programing skill. Some module has to be rewritten to fit yours needs, but you will appreciate full control over this software.
- You are the master of your data: full database access let you correct any mistakes at their origin without living correcting records in database, you can also extract datas for statistic, accounting, etc ...

## [Screenshot](https://github.com/Nick689/CustomPOS/blob/master/Preview/ViewAll.md)
Click the link ↑

## Features
* Unlimited users number
* Unlimited sessions number
* Data update can be made with powerfull [spreadsheet style](https://github.com/Nick689/CustomPOS/blob/master/Preview/Stk.png) database editors
* Built-in PDF & PNG export
* Barcode printing (code128 or EAN13)
* Shortcut keys allow you to work with keybord only
* Multi-item combination insert
* Multi-cell copy-paste allow list insert
* Advanced pricing management with selectable scenarios for each item
* Detailed incomes page shows real time incomes for the day or for any day before
* Data export has never been so easy, you are already in Calc
* Advanced user right management based on users database privilege
* Full database access (via LibreOffice Base or via SQL request) let you correct any mistake easily

 Yes, this is dangerous and it open the door to mistakes that will be detected by the following modules:
* Invoice check module compare invoice's details with invoice's header and list every incoherencies
* Stock check module compile every sales and entries for each item and compare to current stock

## Planned features
* A simple install single user version will be available later but you can install the client-server version for immediate use.
* Localized versions
* Sales statistics

## Advancement
Only Linux-French version is currently available.
An item edit page was planned but direct database edit is so practicle that item module is canceled.
Only main features are currently available. Statistics have to be done externaly. Stability is good without being as good as other classic programs, but don't worry, data loss cannot happen with transactional request. Last version is the 0.7. See changelog in Wiki section for versions notes.

## Limitations
Despite CustomPOS's capability to handle many users, it is not recommended for big companies. You have to consider that LibreOffice powerful features cannot all be locked and can be hacked by dvanced users.

* Max number of invoice: 18446744073709551615 BIGINT(20)
* Max number of sold item: 18446744073709551615 BIGINT(20)  (can be reseted after invoices archiving)
* Max number of item per invoice: 100 (limited by mysql connector)
* Number of reference per item: 6 (can be extended)

Demo version can only manage one user at a time due to the different type of database (HSQLDB) it use.

## Licence
This program is free and can be used and modifyed without licence.
