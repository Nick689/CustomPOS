# USAGE AND ADVISES (In construction)
**For testing CustomPOS:** You can use Testing-data.sql to populate database

**Sale scenario (custompos.stk)**:
- senario -1 - Price will never be modified automaticaly. Usefull for Miscelaneous item and other freely fixed item. (IMPORTANT:Set base price to 1.00)
- senario 0 - Price cannot be under public price. Public price will be applied when changing customer.
- senario 1 - Discount cannot exceed Maxdisc. Public price will be applied when changing customer.
- senario 2 - Discount can be set freely up to Maxdisc. Public price will be applied when changing customer.
- senario 3 - Price can be set freely. Public price will be applied when changing customer.
- senario 4 - Promo discount will be applied when adding item, duplicating invoice, public price button pressed, changing customer.

**Quantity correction:**  Avoid mofiying quantities directly in stk table, you should make this only when error are detected by Stkchk that will give you theoretical quantity.

**Inventory:**  There is no dedicated inventory module in CustomPOS, you have to create a new account every year and charge it with $0.00 priced item you want to adjust (the purpose for the "ALL FREE" button).

**Stock moving-management:**  See "Inventory", same operation.

**Barcode:**  Linux user have to disable shift key while scanning case sensitive barcode.

**Comment:**  Comment can be added on invoice preceded with one of these characters:  " ' ` _ - ~ #

**Stoping CustomPOS** You don't need to save this document when closing the file, partial cleanup is executed on staing and on closing.
