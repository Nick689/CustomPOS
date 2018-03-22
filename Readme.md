## Description
CustomPOS is a retail Point of Sale system. It is made of LibreOffice macros and SQL requests. You can customize this program if you know how to write macros.

CustomPOS GUI is highly efficient with only one page POS, there's no sub-page. Only one popup confirmation will show before invoice recording.

CustomPOS works in client-server mode, no data is stored in client side. All you have to do if you want your data safe is to backup the database.

CustomPOS main concepts are:
- You can easily customize this program (you need to know basics about programing, networking, SQL)
- You are the master of your data: full database access allow you to correct any mistakes at their origin, you can also easily extract data for statistics, accounting, etc ...

## [Screenshot](https://github.com/Nick689/CustomPOS/blob/master/Preview/ViewAll.md)
.

## Features
* Multi-user
* Multi-session
* Built-in PDF export
* Barcode printing (code128 only)
* Shortkeys allow you to work with keybord only
* Advanced user right management
* Advanced pricing management with selectable scenarios for each item
* Detailed incomes page shows real time incomes of the day or any previous day
* Data export has never been so easy, you are already in Calc
* Full database access let you correct any mistake easily.  Yes, this is dangerous, this is why there's:
* InvoiceCHK() script can find any invoice data inconsistency
* STKCHK() script compile every sales and supplies and show you any wrong quantities in stock

## Planned features
* Single user demo version with simple setup
* Localized versions
* Sales statistics

## Advancement
Only Linux-French version is currently available. There's no item edit page, you have to edit database directly. Most important features are implemented and this program is used daily. Stability is good but not as good as other classic program, however data loss cannot happen with transactional SQL. Contact me to get the last version 0.7. Please see changelog in Wiki section for versions notes.

## Limitations
Despite CustomPOS's capabilities with unlimited users and light server load, it's not recommended for big companies, considering that LibreOffice has powerful features that cannot all be locked and advanced users can hack it.

* Max number of invoice: 18446744073709551615 BIGINT(20)
* Max number of sold item: 18446744073709551615 BIGINT(20)
* Max number of item per invoice: 100 (limited by mysql connector)
* Number of reference per item: 6 (can be extended)

Demo version is planned for only one user at a time, it will store data differently (HSQLDB), it will not have the same features than full version.
