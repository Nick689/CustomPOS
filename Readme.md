## Description
CustomPOS is a retail Point of Sale system based on LibreOffice and mostly programmed with macros which you can customize easily. Spreadsheet interface has simplified the programming and allow functionnality with rarely available in classic interface like copy-paste, spreading, etc . However, CustomPOS is not a simple spreadsheet file, it's performance and reliability rely on the underlying database engine (MariaDB).

You must have guessed that efficiency has leaded customPOS design like in the one page POS where invoices are recorded after one popup validation only.

CustomPOS main concepts are:
- You can customize this program yourself. It may need some works to achieve what you want but the benefit to have full control over your software is priceless, i.e it's free :)
- You are the master of your data: full database access let you correct any mistakes at their origin without living correcting records in database, you can also extract datas for statistic, accounting, etc ...

## [Screenshot](https://github.com/Nick689/CustomPOS/blob/master/Preview/ViewAll.md)
.

## Features
* Multi-user
* Multi-session
* Built-in PDF export
* Barcode printing (code128 or EAN13)
* Shortcut keys allow you to work with keybord only
* Multi-item combination handling with one code insert
* Advanced pricing management with selectable scenarios for each item
* Detailed incomes page shows real time incomes of the day or any previous day
* Data export has never been so easy, you are already in Calc
* Advanced user right management based on users database privilege
* Full database access let you correct any mistake easily

 Yes, this is dangerous, the reason for:
* Invoice-verify module compare invoice details with invoice header to detect data incoherency
* STK-verify module compile every sales and entries for each item and compare it with current stock

## Planned features
* A simple install demo version will be available soon. But you can install right now the server version and use it localy
* Localized versions
* Sales statistics

## Advancement
Only Linux-French version is currently available. The item edit page does not exist yet, but direct database edition works great if you have correctly granted users. Only main features are currently available. Statistics have to be done externaly. Stability is good without being as good as other classic programs, but don't worry, data loss cannot happen with transactional request. Last version is the 0.7. See changelog in Wiki section for versions notes.

## Limitations
Despite CustomPOS's capacity to handle many users, it is not recommended for big companies. You have to consider that LibreOffice has powerful features that cannot all be locked so that advanced users can hack it.

* Max number of invoice: 18446744073709551615 BIGINT(20)
* Max number of sold item: 18446744073709551615 BIGINT(20)  (can be reseted when archiving invoices)
* Max number of item per invoice: 100 (limited by mysql connector)
* Number of reference per item: 6 (can be extended)

Demo version can only manage one user at a time due to the different type of database (HSQLDB) it use.

## Licence
Macros do not need licence. You can use and modify this program as you like. Special thanks to LibreOffice and MariaDB contributors
