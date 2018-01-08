## Description
CustomPOS is a retail Point of Sale system.
It is not exactly a program since it is only a spreadsheet with macros.
LibreOffice is used for GUI and MySQL for database. No data is stored in client side. Only the database backup is needed to save all your data.
GUI has been designed to be highly efficient with only one page POS, there is no sub-page, only one pop-up confirmation message will be displayed before invoice validation.
CustomPOS main concepts are:
- You can customize this program as you like
- You are the master of your data so that you can:
  - correct problems at their origin
  - Extract data  for analyzing, statistics, accounting, etc ...

## [Screenshot](https://github.com/Nick689/CustomPOS/blob/master/Preview/ViewAll.md)

## Features
* The macros are easily customizable
* Multi-user
* Multi-session
* Only Mysql (or substitute) is needed on the server which can run on intel i3 or i5 without trouble
* Every data write are made transactionally to avoid data corruption
* Built-in PDF export
* Barcode printing (code128 only)
* Advanced user right management
* Advanced pricing management with selectable scenarios for each item
* Detailed income page shows instant cash state and can be viewed at any moment
* Data export has never been so easy, you are already in Calc
* Full database access let you correct any mistake easily, but, as it is dangerous
* InvoiceCHK can be used to find any invoice data inconsistency by comparing invoice header and detail data
* chk() can be used to find any stock incoherency by comparing it with theoretical quantity compiled from every sales and supplies

## Planned features
* Localized versions
* Windows, OSX versions
* Statistics
* Address book

## Advancement
Only Linux-French version is currently available. Item edit page does not exist yet, but you can edit database directly. Most important features are implemented and this program is used daily. Reactivity and stability are good. Current version is 0.7   Please see changelog for more details.

## Limitations
Despite CustomPOS's capabilities with unlimited users and light-weight server load, it is not recommended for big companies, considering that LibreOffice has powerful features that cannot all be locked and advanced users can hack it.

* Max number of invoice: 18446744073709551615 BIGINT(20)
* Max number of sold item: 18446744073709551615 BIGINT(20)
* Max number of item per invoice: 100 (limited by mysql connector)
* Number of reference per item: 6 (can be extended)
