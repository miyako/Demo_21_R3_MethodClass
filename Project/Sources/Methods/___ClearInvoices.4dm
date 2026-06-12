//%attributes = {"lang":"en"}
// Delete all invoices and invoice lines, reset auto-increment IDs

TRUNCATE TABLE([INVOICES])
TRUNCATE TABLE([INVOICE_LINES])
SET DATABASE PARAMETER([INVOICES]; Table sequence number; 0)
SET DATABASE PARAMETER([INVOICE_LINES]; Table sequence number; 0)

ALERT("OK")
