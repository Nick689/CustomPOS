# USAGE AND ADVISES (In construction)
**Testing** For testing you can use TestingDatas.sql to populate database

**Sale scenario (custompos.stk)**
- senario -1 - Price will never be modified automaticaly. Usefull for Miscelaneous item and other freely fixed item. (IMPORTANT:Set base price to 1.00)
- senario 0 - Price cannot be under public price. Public price will be applied when changing customer.
- senario 1 - Discount cannot exceed Maxdisc. Public price will be applied when changing customer.
- senario 2 - Maxdisc can be applied as you like. Public price will be applied when changing customer.
- senario 3 - Price can be set freely. Public price will be applied when changing customer.
- senario 4 - Promo discount will be applied automaticaly when adding new item, duplicating invoice, public price button pressed, changing customer.

**Quantity check:**  Instead of forcing stock quantity records without any justification, you can call "stkchk()" stored procedure that will check every sales/arrivals and give you the theoretic quantity and the difference with current quantity for every items.

**Inventory:**  There is no dedicated inventory module in CustomPOS, however you can adjust quantities by charging special "Inventory" customer with the properly signed quantity, 0 priced (the purpose for the "FREE" button) item you want to adjust.

**Stock moving-management:**  See "Inventory", same operation.

**Barcode:**  Linux user have to disable shift key while scanning case sensitive barcode.

**Special items:**
- **DIV** is the reference for miscellaneous item, it has editable name and price. You have to define correctly the "misc" constant in "global" library so that the program can retrieve this item in database.
- **'**  Single quote at the beginning of the name indicate a comment.

**Stoping CustomPOS** You don't need to save this document when closing the file, partial cleanup is executed on staing and on closing.
