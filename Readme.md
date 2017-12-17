## Description
CustomPOS is a retail Point of Sale system.
It is not really a program since it is only a spreadsheet with macros.
LibreOffice is used for GUI and MySQL for database. No data is stored in client side. You only have to backup the database.
GUI has been designed to be extremely efficient with only one page POS, there is no sub-page, only one pop-up confirmation message will be displayed before invoice validation.

## [Screenshot](https://github.com/Nick689/CustomPOS/blob/master/Preview/ViewAll.md)

## Features
* Multi-user
* Multi-session
* Easy to customize with easy macro code
* Built-in PDF export
* Barcode printing (code128 only)
* Advanced user right management
* Advanced pricing management with selectable scenarios for each item
* Detailed income page shows instant cash state and can be viewed at any moment
* Data export has never been so easy, you are already in Calc
* Full database access let you correct any mistake easily, but full access can be dangerous and
* Invoice database inconsistencies will be found by InvoiceCHK script by comparing invoice header and details-database

## Planned features
* Localized versions
* Windows, OSX versions
* Statistics
* Address book

## Advancement
Only Linux-French version is currently available. Item edit page does not exist yet, but you can edit database directly. Most important features are implemented and this program is already used in production. You will find a confortable reactivity and stability.

## Limitations
Despite CustomPOS's powerful features with unlimited simultaneous users, light-weight server load, it is not recommended for big companies, considering that LibreOffice has powerful features that cannot all be locked and advanced users can hack it.

* Max number of invoice: 18446744073709551615 BIGINT(20)
* Max number of sold item: 18446744073709551615 BIGINT(20)
* Max number of item per invoice: 100 (limited by mysql connector)
* Number of reference per item: 6 (can be extended)
