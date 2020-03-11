/*1ST EX. Find all vendors (name and full address, terms, credit total and payments date) who paid in june 2014,
 List them by their name. */
USE ap;
SELECT vendor_name AS Vendor, CONCAT(COALESCE(vendor_address1,''),', ',COALESCE(vendor_city,''),', ',COALESCE(vendor_state,''),', ',COALESCE(vendor_zip_code,'')) AS Address, terms_description AS Terms, credit_total AS Credit, payment_date AS PaymentDate
	FROM vendors v
    LEFT JOIN terms t ON v.default_terms_id = t.terms_id
    RIGHT JOIN invoices i USING(vendor_id)
    WHERE i.payment_date BETWEEN DATE('2014/06/01') AND DATE('2014/06/30')
    ORDER BY vendor_name;
    
/* 2ND EX. Find the all the invoices from all vendors (name, city and state) 
whose name starts with a c and where the line item amount (line item amount, account number) is greater than 1000,
 list them by account number.*/
 SELECT vendor_name AS Vendor, vendor_city AS City, vendor_state AS State, invoice_number AS Invoice, li.line_item_amount AS Amount, default_account_number AS Account
	FROM vendors v
    JOIN invoices i USING(vendor_id)
    JOIN invoice_line_items li USING(invoice_id)
    WHERE v.vendor_name LIKE 'c%' AND li.line_item_amount > 1000
    ORDER BY v.default_account_number;
    
/*3RD EX. Find and list the vendors (name, address, state, contacts last name and their ID) from ‘California’. 
Only the ones who have either ‘on’ or ‘ny’ in their first or last name (first name, last name),
list them by their last name.  */
  SELECT vendor_name AS Vendor, COALESCE(vendor_address1,'') AS Address, vendor_state AS State, vendor_contact_last_name AS Contact, vendor_id AS ID
	FROM vendors v
    WHERE v.vendor_state = 'CA' AND (v.vendor_contact_first_name LIKE '%on%' OR v.vendor_contact_last_name LIKE '%on%' OR v.vendor_contact_first_name LIKE '%ny%' OR v.vendor_contact_last_name LIKE '%ny%')
    ORDER BY v.vendor_contact_last_name;

/*4TH EX. Find and list all the invoices (vendor id, invoice number, due date) 
where the line item is ‘freight’ (account number, amount, description). 
But only those who belong to account number 520, 553 or 572, list them by their id highest number first.  */
	SELECT vendor_id AS VendorID, invoice_number AS Invoice, invoice_due_date AS DueDate
	FROM invoices
    JOIN invoice_line_items li USING(invoice_id)
    WHERE li.line_item_description = 'Freight' AND (li.account_number = '520' OR li.account_number = '553' OR li.account_number = '572')
    ORDER BY invoice_id DESC;
    
/*5Ex. Find information (you choose the relevant attributes) about all the accounts that ‘Charles Bucket’ handles.
 But only those who should be paid within 30 days, there should be no duplicate vendors in your resultset, 
 list them by their due date.*/    

SELECT DISTINCT vendor_id AS VendorID, v.vendor_name AS Vendor, invoice_number AS Invoice, payment_total AS Payment, invoice_due_date AS DueDate, CONCAT(c.last_name,' ',c.first_name) AS AccountHandler
	FROM invoices i
    JOIN vendors v USING(vendor_id)
    JOIN vendor_contacts c USING(vendor_id)
    JOIN terms t USING(terms_id)
    WHERE t.terms_due_days <= 30 AND c.last_name = 'Bucket'
    ORDER BY i.invoice_due_date;
    
/*6th Ex. Find all the contacts (you choose the relevant attributes) who have a last names starting with ‘B’. 
(There are no results for 'M')
List all the vendors they handle within these dates 16. june 2014 to 11. juli 2014, 
list them so that the newest payment comes first.*/

SELECT vendor_id AS VendorID, vendor_name AS Vendor, invoice_number AS Invoice, payment_total AS Payment, invoice_due_date AS DueDate, CONCAT(vendor_contact_last_name,' ',vendor_contact_first_name) AS AccountHandler
	FROM vendors v
    JOIN invoices i USING(vendor_id)
    WHERE v.vendor_contact_last_name LIKE 'b%' AND i.payment_date BETWEEN DATE('2014/06/16') AND DATE('2014/07/11')
    ORDER BY i.payment_date;
    
/*7th Ex. List all the the vendors and information about their invoices (you choose the relevant attributes). 
But list only the invoices from juli 2014. Make a new column that you name invoice_account_total where 
you list the total of the individual vendor. List them by the highest total first.*/    

SELECT vendor_id AS VendorID, vendor_name AS Vendor, CONCAT(vendor_contact_last_name,' ',vendor_contact_first_name) AS AccountHandler, SUM(i.payment_total) AS invoice_account_total
	FROM vendors v
    JOIN invoices i USING(vendor_id)
    WHERE i.invoice_date BETWEEN DATE('2014/07/01') AND DATE('2014/07/31')
    GROUP BY i.vendor_id
	ORDER BY invoice_account_total;