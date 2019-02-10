## Description
CustomPOS is a retail Point of sale system based on LibreOffice and writed with macro so that you can customize it easily. Don't think it is a simple spreadsheet file, it has network multi-user capabilities and use proven database engine. The interface has been designed for the best efficiency with reduced typing needs. POS module is made of one page only where invoices are recorded after one popup validation only.

CustomPOS main concepts are:
- You can customize this program easily with only basic programing skill. Some module has to be rewritten to fit yours needs, it is simpler than it looks like. You'll have full control over your software. It is priceless, i.e free :)
- You are the master of your data: full database access let you correct any mistakes at their origin without living correcting records in database, you can also extract datas for statistic, accounting, etc ...

## [Screenshot](https://github.com/Nick689/CustomPOS/blob/master/Preview/ViewAll.md)
Click the link ↑

## Features
* Unlimited users number
* Unlimited sessions number
* multi-cell copy-paste -> product insert
* Multi-item combination insert
* Built-in PDF & PNG export
* Barcode printing (code128 or EAN13)
* Shortcut keys allow you to work with keybord only
* Advanced pricing management with selectable scenarios for each item
* Detailed incomes page shows real time incomes for the day or for any day you want
* Data export has never been so easy, you are already in Calc
* Advanced user right management based on users database privilege
* Full database access (via LibreOffice Base or via SQL request) let you correct any mistake easily

 Yes, this is dangerous and it open the door to mistakes who will be detected by these verification modules:
* Invoice check module compare invoice's details with invoice's header and list every incoherency
* Stock check module compile every sales and entries for each item and compare it with current stock

## Planned features
* A simple install demo version will be available soon. But you can install right now the client-server version and use it localy
* Localized versions
* Sales statistics

## Advancement
Only Linux-French version is currently available. The item edit page does not exist yet, but direct database edition works great if you have correctly granted users. Only main features are currently available. Statistics have to be done externaly. Stability is good without being as good as other classic programs, but don't worry, data loss cannot happen with transactional request. Last version is the 0.7. See changelog in Wiki section for versions notes.

## Limitations
Despite CustomPOS's capacity to handle many users, it is not recommended for big companies. You have to consider that LibreOffice has powerful features that cannot all be locked so that advanced users can hack it.

* Max number of invoice: 18446744073709551615 BIGINT(20)
* Max number of sold item: 18446744073709551615 BIGINT(20)  (can be reseted after invoices archiving)
* Max number of item per invoice: 100 (limited by mysql connector)
* Number of reference per item: 6 (can be extended)

Demo version can only manage one user at a time due to the different type of database (HSQLDB) it use.

## Licence
This macro made program do not need licence. You can use and modify this program as you like. Special thanks to LibreOffice and MariaDB contributors
