
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT TEST 1: Verify current invoice balances

SELECT
    invoice_id,
    estatecore_pkg.get_invoice_balance(invoice_id) AS balance
FROM rent_invoices
ORDER BY invoice_id;

PROMPT TEST 2: Test overpayment rejection

EXEC record_payment(604, 403, 6000, 'UPI', 'TEST-OVERPAY-001');

PROMPT TEST 3: Confirm overpayment was not inserted

SELECT *
FROM payments
WHERE reference_number = 'TEST-OVERPAY-001';

PROMPT TEST 4: Test a valid partial payment

SAVEPOINT phase6_test;

EXEC record_payment(604, 401, 1000, 'UPI', 'TEST-PAYMENT-001');

SELECT
    invoice_id,
    invoice_status,
    estatecore_pkg.get_invoice_balance(invoice_id) AS balance
FROM rent_invoices
WHERE invoice_id = 401;

ROLLBACK TO phase6_test;

PROMPT TEST 5: Verify invoice 401 was restored

SELECT
    invoice_id,
    invoice_status,
    estatecore_pkg.get_invoice_balance(invoice_id) AS balance
FROM rent_invoices
WHERE invoice_id = 401;

PROMPT TEST 6: Test duplicate active lease rejection

INSERT INTO leases (
    lease_id,
    unit_id,
    tenant_id,
    start_date,
    end_date,
    monthly_rent,
    lease_status
)
VALUES (
    304, 1, 202,
    DATE '2026-10-15',
    DATE '2027-10-14',
    16000, 'ACTIVE'
);

PROMPT TEST 7: Test invalid unit status rejection

UPDATE units
SET status = 'BROKEN'
WHERE unit_id = 1;

PROMPT TEST 8: Review audit history

SELECT *
FROM audit_log
ORDER BY audit_id;
