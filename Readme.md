## Description
CustomPOS is a retail Point of Sale system. It is made of LibreOffice macro and SQL request. Everyone with basic programing skill can customize it (you need to know basics about programing, networking, SQL)

CustomPOS GUI has been designed to be highly efficient with only one page POS, without sub-page. Only one popup confirmation will show before invoice recording.

No data are stored in client side. All you have to do if you want to save your data is to backup the database.    
  
CustomPOS main concepts are:
- You can easily customize this program
- You are the master of your data: full database access allow you to correct any mistakes at their origin, you can also easily extract data for statistics, accounting, etc ...

## [Screenshot](https://github.com/Nick689/CustomPOS/blob/master/Preview/ViewAll.md)

## Features
* Multi-user
* Multi-session
* Built-in PDF export
* Barcode printing (code128 only)
* Shortkeys allow you to work with keybord only
* Advanced user right management
* Advanced pricing management with selectable scenarios for each item
* Detailed incomes page shows real time incomes of today or any previous day
* Data export has never been so easy, you are already in Calc
* Full database access let you correct any mistake easily,        and,    as this is dangerous
* InvoiceCHK script can be used to find any invoice data inconsistency
* stkchk() can be used to find any stock incoherence by comparing it with theoretical quantity compiled from every sales and supplies

## Planned features
* Portable demo version (do not need installation)
* Localized versions
* Sales statistics

## Advancement
Only Linux-French version is currently available. Item edit page does not exist yet, but you can edit database directly. Most important features are implemented and this program is used daily. Stability is good but not as good other classic program, however data lost cannot happen with transactional SQL. Current version is 0.7  Contact me to get it. Please see changelog in Wiki section for more details.

## Limitations
Despite CustomPOS's capabilities with unlimited users and light-weight server load, it is not recommended for big companies, considering that LibreOffice has powerful features that cannot all be locked and advanced users can hack it.

* Max number of invoice: 18446744073709551615 BIGINT(20)
* Max number of sold item: 18446744073709551615 BIGINT(20)
* Max number of item per invoice: 100 (limited by mysql connector)
* Number of reference per item: 6 (can be extended)

Demo version is planned for only one user at a time. It will use spreadsheets to store data. It will not have the same features than SQL version. LibreOffice is limited to 1 million rows, enough to store several years of data.
