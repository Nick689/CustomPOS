# USAGE AND ADVISES (In construction)
 
**Quantity check:**  Instead of forcing stock quantity records without any justification, you can call "stkchk()" stored procedure that will check every sales/arrivals and give you the theoretic quantity and the difference with current quantity for every items.

**Inventory:**  There is no dedicated inventory module in CustomPOS, however you can adjust quantities by charging special "Inventory" customer with the properly signed quantity, 0 priced (the purpose for the "FREE" button) item you want to adjust.

**Stock moving-management:**  See "Inventory", same operation.

**Barcode:**  Delete any zero at the beginning of barcode database record otherwise it will not work.
Linux user have to disable shift key while scanning case sensitive barcode.

**Special items:**
- **DIV** is the reference for miscellaneous item, it has editable name and price. You have to define correctly the "misc" constant in "global" library so that the program can retrieve this item in database.
- **'**  Single quote at the beginning of the name indicate a comment.
