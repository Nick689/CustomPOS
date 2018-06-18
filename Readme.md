## Description
CustomPOS is a retail Point of Sale system programmed with macros and SQL requests so that you can customize it with only basic programming skill.

The use of spreadsheet has greatly accelerated CustomPOS's programming. Why reinventing the wheel ? However the POS interface is a great success of efficiency with only one interface page, there is no sub-page, only one popup validation will run invoice recording

CustomPOS is not a simple spreadsheet file, the engine running at the heart of the system is a database server. And you only need a database dump to save all your datas.

CustomPOS main concepts are:
- You can easily customize this program (you need to know basics about programing, networking and SQL)
- You are the master of your data: full database access let you correct any mistakes at their origin, you can also extract data for statistics, accounting, etc ...

## [Screenshot](https://github.com/Nick689/CustomPOS/blob/master/Preview/ViewAll.md)
.

## Features
* Multi-user
* Multi-session
* Built-in PDF export
* Barcode printing (code128 or EAN13)
* Shortkeys allow you to work with keybord only
* Advanced user right management
* Advanced pricing management with selectable scenarios for each item
* Detailed incomes page shows real time incomes of the day or any previous day
* Data export has never been so easy, you are already in Calc
* Full database access let you correct any mistake easily.  Yes, this is dangerous, the reason for:
* IVCHK script compare invoice details with invoice header to determine if it is correct
* STKCHK script compile every sales and entries for each item and compare it with the current stock

## Planned features
* Single user demo version with simple setup will be available later. But instead of waiting the demo, you can install the database server on the user desktop and you get the full version.
* Localized versions
* Sales statistics

## Advancement
Only Linux-French version is currently available. The item edit page does not exist yet, but direct database edition works great if you have correctly granted users. Only main features are currently available. Statistics have to be done externaly. Stability is good without being as good as other classic programs, but don't worry, data loss cannot happen with transactional request. Last version is the 0.7. See changelog in Wiki section for versions notes.

## Limitations
Despite CustomPOS's capabilities with unlimited users and light server load, it is not recommended for big companies. You have to consider that LibreOffice has powerful features that cannot all be locked so that advanced users can hack it.

* Max number of invoice: 18446744073709551615 BIGINT(20)
* Max number of sold item: 18446744073709551615 BIGINT(20)
* Max number of item per invoice: 100 (limited by mysql connector)
* Number of reference per item: 6 (can be extended)

Demo version can only manage one user at a time due to the different type of database (HSQLDB) it use.
