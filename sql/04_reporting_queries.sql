
SET PAGESIZE 100
SET LINESIZE 200
SET NUMWIDTH 12


/*Report A — Invoice balance by tenant */

SELECT
    ri.invoice_id,
    t.full_name AS tenant_name,
    ri.invoice_month,
    ri.amount_due,
    NVL(SUM(p.amount_paid), 0) AS amount_paid,
    GREATEST(ri.amount_due - NVL(SUM(p.amount_paid), 0), 0)
        AS outstanding_balance,
    ri.invoice_status
FROM rent_invoices ri
JOIN leases l ON ri.lease_id = l.lease_id
JOIN tenants t ON l.tenant_id = t.tenant_id
LEFT JOIN payments p ON ri.invoice_id = p.invoice_id
GROUP BY
    ri.invoice_id,
    t.full_name,
    ri.invoice_month,
    ri.amount_due,
    ri.invoice_status
ORDER BY ri.invoice_id;


/* Report B — Overall rent collection for October 2026 */

SELECT
    COUNT(*) AS total_invoices,
    SUM(amount_due) AS total_billed,
    SUM(CASE WHEN invoice_status = 'PAID'
             THEN amount_due ELSE 0 END) AS fully_paid_amount,
    SUM(amount_due) -
        SUM(CASE WHEN invoice_status = 'PAID'
                 THEN amount_due ELSE 0 END) AS not_fully_paid_amount,
    ROUND(
        100 * SUM(CASE WHEN invoice_status = 'PAID'
                       THEN amount_due ELSE 0 END)
        / NULLIF(SUM(amount_due), 0),
        2
    ) AS fully_paid_percentage
FROM rent_invoices
WHERE invoice_month >= DATE '2026-10-01'
  AND invoice_month < DATE '2026-11-01';



/* Report C — Property-wise rent collection */


SELECT
    p.property_id,
    p.property_name,
    COUNT(ri.invoice_id) AS invoice_count,
    NVL(SUM(ri.amount_due), 0) AS total_billed,
    NVL(
        SUM(CASE WHEN ri.invoice_status = 'PAID'
                 THEN ri.amount_due ELSE 0 END),
        0
    ) AS fully_paid_amount,
    ROUND(
        100 * NVL(
            SUM(CASE WHEN ri.invoice_status = 'PAID'
                     THEN ri.amount_due ELSE 0 END),
            0
        ) / NULLIF(SUM(ri.amount_due), 0),
        2
    ) AS fully_paid_percentage
FROM properties p
LEFT JOIN units u ON p.property_id = u.property_id
LEFT JOIN leases l ON u.unit_id = l.unit_id
LEFT JOIN rent_invoices ri ON l.lease_id = ri.lease_id
GROUP BY p.property_id, p.property_name
ORDER BY p.property_id;


/* Report D — Actual outstanding rent by property */

SELECT
    p.property_id,
    p.property_name,
    NVL(SUM(ri.amount_due), 0) AS total_billed,
    NVL(SUM(NVL(pay.total_paid, 0)), 0) AS total_collected,
    NVL(
        SUM(GREATEST(ri.amount_due - NVL(pay.total_paid, 0), 0)),
        0
    ) AS outstanding_rent
FROM properties p
LEFT JOIN units u ON p.property_id = u.property_id
LEFT JOIN leases l ON u.unit_id = l.unit_id
LEFT JOIN rent_invoices ri ON l.lease_id = ri.lease_id
LEFT JOIN (
    SELECT invoice_id, SUM(amount_paid) AS total_paid
    FROM payments
    GROUP BY invoice_id
) pay ON ri.invoice_id = pay.invoice_id
GROUP BY p.property_id, p.property_name
ORDER BY p.property_id;


/* Report E — Occupancy by property */

SELECT
    p.property_name,
    COUNT(u.unit_id) AS total_units,
    SUM(CASE WHEN u.status = 'OCCUPIED' THEN 1 ELSE 0 END)
        AS occupied_units,
    SUM(CASE WHEN u.status = 'VACANT' THEN 1 ELSE 0 END)
        AS vacant_units,
    ROUND(
        100 * SUM(CASE WHEN u.status = 'OCCUPIED' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(u.unit_id), 0),
        2
    ) AS occupancy_percentage
FROM properties p
LEFT JOIN units u ON p.property_id = u.property_id
GROUP BY p.property_id, p.property_name
ORDER BY p.property_id;


/* Report F — Maintenance status and costs */

SELECT
    p.property_name,
    COUNT(m.request_id) AS total_requests,
    SUM(CASE WHEN m.request_status = 'OPEN' THEN 1 ELSE 0 END)
        AS open_requests,
    SUM(CASE WHEN m.request_status = 'IN_PROGRESS' THEN 1 ELSE 0 END)
        AS in_progress_requests,
    SUM(CASE WHEN m.request_status = 'RESOLVED' THEN 1 ELSE 0 END)
        AS resolved_requests,
    NVL(SUM(m.actual_cost), 0) AS total_actual_cost
FROM properties p
LEFT JOIN units u ON p.property_id = u.property_id
LEFT JOIN maintenance_requests m ON u.unit_id = m.unit_id
GROUP BY p.property_id, p.property_name
ORDER BY p.property_id;


/* Report G — Financial performance (rent collected minus expenses) */

WITH rent_summary AS (
    SELECT
        u.property_id,
        SUM(p.amount_paid) AS rent_collected
    FROM rent_invoices ri
    JOIN leases l ON ri.lease_id = l.lease_id
    JOIN units u ON l.unit_id = u.unit_id
    JOIN payments p ON ri.invoice_id = p.invoice_id
    WHERE p.payment_date >= DATE '2026-10-01'
      AND p.payment_date < DATE '2026-11-01'
    GROUP BY u.property_id
),
expense_summary AS (
    SELECT
        property_id,
        SUM(amount) AS total_expenses
    FROM expenses
    WHERE expense_date >= DATE '2026-10-01'
      AND expense_date < DATE '2026-11-01'
    GROUP BY property_id
)
SELECT
    p.property_name,
    NVL(r.rent_collected, 0) AS rent_collected,
    NVL(e.total_expenses, 0) AS total_expenses,
    NVL(r.rent_collected, 0) - NVL(e.total_expenses, 0)
        AS net_operating_cash
FROM properties p
LEFT JOIN rent_summary r ON p.property_id = r.property_id
LEFT JOIN expense_summary e ON p.property_id = e.property_id
ORDER BY p.property_id;


/* Report H — Use the package functions */

SELECT
    invoice_id,
    estatecore_pkg.get_invoice_balance(invoice_id)
        AS outstanding_balance
FROM rent_invoices
ORDER BY invoice_id;

SELECT
    property_id,
    property_name,
    estatecore_pkg.get_property_outstanding(property_id)
        AS outstanding_rent
FROM properties
ORDER BY property_id;


/* Report I — Audit history */

SELECT
    audit_id,
    table_name,
    operation,
    record_id,
    changed_by,
    changed_at,
    details
FROM audit_log
ORDER BY audit_id;




