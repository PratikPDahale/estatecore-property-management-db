
CREATE OR REPLACE PACKAGE estatecore_pkg AS

    FUNCTION get_invoice_balance(
        p_invoice_id IN NUMBER
    ) RETURN NUMBER;

    FUNCTION get_property_outstanding(
        p_property_id IN NUMBER
    ) RETURN NUMBER;

END estatecore_pkg;
/

CREATE OR REPLACE PACKAGE BODY estatecore_pkg AS

    FUNCTION get_invoice_balance(
        p_invoice_id IN NUMBER
    ) RETURN NUMBER
    AS
        v_amount_due NUMBER(10,2);
        v_total_paid NUMBER(10,2);
    BEGIN
        SELECT amount_due
        INTO v_amount_due
        FROM rent_invoices
        WHERE invoice_id = p_invoice_id;

        SELECT NVL(SUM(amount_paid), 0)
        INTO v_total_paid
        FROM payments
        WHERE invoice_id = p_invoice_id;

        RETURN GREATEST(v_amount_due - v_total_paid, 0);
    END get_invoice_balance;

    FUNCTION get_property_outstanding(
        p_property_id IN NUMBER
    ) RETURN NUMBER
    AS
        v_outstanding NUMBER(12,2);
    BEGIN
        SELECT NVL(
            SUM(
                GREATEST(
                    ri.amount_due - NVL(
                        (
                            SELECT SUM(pm.amount_paid)
                            FROM payments pm
                            WHERE pm.invoice_id = ri.invoice_id
                        ),
                        0
                    ),
                    0
                )
            ),
            0
        )
        INTO v_outstanding
        FROM properties p
        JOIN units u
            ON p.property_id = u.property_id
        JOIN leases l
            ON u.unit_id = l.unit_id
        JOIN rent_invoices ri
            ON l.lease_id = ri.lease_id
        WHERE p.property_id = p_property_id;

        RETURN v_outstanding;
    END get_property_outstanding;

END estatecore_pkg;
/
