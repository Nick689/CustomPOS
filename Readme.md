## Description
CustomPOS is a retail Point of Sale system using LibreOffice Calc as interface and programmed with macros which can be customized easily. However CustomPOS is not a simple spreadsheet file, it's performance and reliability rely on the underlying database engine (MariaDB) combined with some auto-completion listeners, it give an interface needing minimal typing/validation.

To achive the highest efficiency the whole POS module consist of only one page where invoices are recorded after one popup validation only.

Security has not been forgotten and every module is protected by an advanced right management

CustomPOS main concepts are:
- You can customize this program yourself. Some more work is needed to make your localised version but the benefit to have full control over your software is priceless, i.e it's free.  :)   Don't be affraid about the apparent program's complexity, it integrates advanced pricing scenario you may not need and can be removed.
- You are the master of yours datas: full database access let you correct any mistakes at their origin without living correcting records in the database, you can also extract datas for statistic, accounting, etc ...

## [Screenshot](https://github.com/Nick689/CustomPOS/blob/master/Preview/ViewAll.md)
.

## Features
* Multi-user
* Multi-session
* multi-cell copy-paste -> product insert
* Built-in PDF export
* Barcode printing (code128 or EAN13)
* Shortcut keys allow you to work with keybord only
* Multi-item combination insert handling
* Advanced pricing management with selectable scenarios for each item
* Detailed incomes page shows real time incomes of the day or any previous day
* Data export has never been so easy, you are already in Calc
* Advanced user right management based on users database privilege
* Full database access let you correct any mistake easily

 Yes, this is dangerous, that is why some verification modules are present:
* Invoice check module which compare invoice's details with invoice's header to detect data incoherency
* Stock check module which compile every sales and entries for each item and compare it with current stock

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
Macros do not need licence. You can use and modify this program as you like. Special thanks to LibreOffice and MariaDB contributors
