
CREATE OR REPLACE PROCEDURE update_invoice_status (
    p_invoice_id IN NUMBER
)
AS
    v_amount_due rent_invoices.amount_due%TYPE;
    v_total_paid NUMBER(10,2);
    v_new_status rent_invoices.invoice_status%TYPE;
BEGIN
    SELECT amount_due
    INTO v_amount_due
    FROM rent_invoices
    WHERE invoice_id = p_invoice_id;

    SELECT NVL(SUM(amount_paid), 0)
    INTO v_total_paid
    FROM payments
    WHERE invoice_id = p_invoice_id;

    IF v_total_paid = 0 THEN
        v_new_status := 'UNPAID';
    ELSIF v_total_paid < v_amount_due THEN
        v_new_status := 'PARTIAL';
    ELSE
        v_new_status := 'PAID';
    END IF;

    UPDATE rent_invoices
    SET invoice_status = v_new_status
    WHERE invoice_id = p_invoice_id;

    DBMS_OUTPUT.PUT_LINE(
        'Invoice ' || p_invoice_id ||
        ' status updated to ' || v_new_status
    );

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(
            'Error: Invoice ' || p_invoice_id || ' does not exist.'
        );
END;
/

CREATE OR REPLACE PROCEDURE refresh_all_invoice_statuses
AS
BEGIN
    FOR inv IN (
        SELECT invoice_id
        FROM rent_invoices
    )
    LOOP
        update_invoice_status(inv.invoice_id);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('All invoice statuses refreshed.');
END;
/
