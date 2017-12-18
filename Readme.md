## Description
CustomPOS is a retail Point of Sale system.
It is not really a program since it is only a spreadsheet with macros.
LibreOffice is used for GUI and MySQL for database. No data is stored in client side. You only have to backup the database.
GUI has been designed to be extremely efficient with only one page POS, there is no sub-page, only one pop-up confirmation message will be displayed before invoice validation.

## [Screenshot](https://github.com/Nick689/CustomPOS/blob/master/Preview/ViewAll.md)

## Features
* Multi-user
* Multi-session
* Every database write is made transactionally to avoid data corruption
* Easy to customize macro code
* Built-in PDF export
* Barcode printing (code128 only)
* Advanced user right management
* Advanced pricing management with selectable scenarios for each item
* Detailed income page shows instant cash state and can be viewed at any moment
* Data export has never been so easy, you are already in Calc
* Full database access let you correct any mistake easily, but, as it is dangerous
* InvoiceCHK will find any invoice data inconsistencies by comparing invoice header and detail data
* And when chk() stored procedure is called it will compile every sales and supplies and will notify you any difference with current stock.

## Planned features
* Localized versions
* Windows, OSX versions
* Statistics
* Address book

## Advancement
Only Linux-French version is currently available. Item edit page does not exist yet, but you can edit database directly. Most important features are implemented and this program is used daily. You will find a comfortable reactivity and stability. Current version is 0.7   Please see changelog for more details.

## Limitations
Despite CustomPOS's capabilities with unlimited users and light-weight server load, it is not recommended for big companies, considering that LibreOffice has powerful features that cannot all be locked and advanced users can hack it.

* Max number of invoice: 18446744073709551615 BIGINT(20)
* Max number of sold item: 18446744073709551615 BIGINT(20)
* Max number of item per invoice: 100 (limited by mysql connector)
* Number of reference per item: 6 (can be extended)
