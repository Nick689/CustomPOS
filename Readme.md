## Description
CustomPOS is a retail Point of Sale system. It is made of LibreOffice macro and SQL request. Everyone with basic programing skill can customize it.    
CustomPOS GUI has been designed to be highly efficient with only one page POS, without sub-page. Only one popup confirmation will be asked before invoice is recorded.    
No data is stored in client side. To save all your data you only need to backup the database.    
CustomPOS main concepts are:
- You can easily customize this program without advanced programing skill
- You are the master of your data (full database access) allowing you to correct mistakes at their origin, and to easily extract data for statistics, accounting, etc ...

## [Screenshot](https://github.com/Nick689/CustomPOS/blob/master/Preview/ViewAll.md)

## Features
* Easy to customize
* Multi user
* Multi session
* Little server hardware needs (for Mysql or substitute)
* Transactional data write to avoid data corruption
* Built-in PDF export
* Barcode printing (code128 only)
* Advanced user right management
* Advanced pricing management with selectable scenarios for each item
* Detailed incomes page shows real time incomes of current or previous day.
* Data export has never been so easy, you are already in Calc
* Full database access let you correct any mistake easily, but, as it is dangerous
* InvoiceCHK can be used to find any invoice data inconsistency by comparing invoice header and detail data
* chk() can be used to find any stock incoherence by comparing it with theoretical quantity compiled from every sales and supplies

## Planned features
* Localized versions
* Windows, OSX versions
* Statistics
* Address book

## Advancement
Only Linux-French version is currently available. Item edit page does not exist yet, but you can edit database directly. Most important features are implemented and this program is used daily. Reliability is good. Current version is 0.7   Please see changelog for more details.

## Limitations
Despite CustomPOS's capabilities with unlimited users and light-weight server load, it is not recommended for big companies, considering that LibreOffice has powerful features that cannot all be locked and advanced users can hack it.

* Max number of invoice: 18446744073709551615 BIGINT(20)
* Max number of sold item: 18446744073709551615 BIGINT(20)
* Max number of item per invoice: 100 (limited by mysql connector)
* Number of reference per item: 6 (can be extended)
