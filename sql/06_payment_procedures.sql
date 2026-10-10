
CREATE OR REPLACE PROCEDURE record_payment (
    p_payment_id IN NUMBER,
    p_invoice_id IN NUMBER,
    p_amount IN NUMBER,
    p_payment_method IN VARCHAR2,
    p_reference_number IN VARCHAR2
)
AS
    v_amount_due rent_invoices.amount_due%TYPE;
    v_total_paid NUMBER(10,2);
BEGIN
    IF p_amount IS NULL OR p_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Payment amount must be greater than zero.'
        );
    END IF;

    SELECT amount_due
    INTO v_amount_due
    FROM rent_invoices
    WHERE invoice_id = p_invoice_id
    FOR UPDATE;

    SELECT NVL(SUM(amount_paid), 0)
    INTO v_total_paid
    FROM payments
    WHERE invoice_id = p_invoice_id;

    IF v_total_paid + p_amount > v_amount_due THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Payment exceeds the remaining invoice balance.'
        );
    END IF;

    INSERT INTO payments (
        payment_id,
        invoice_id,
        payment_date,
        amount_paid,
        payment_method,
        reference_number
    )
    VALUES (
        p_payment_id,
        p_invoice_id,
        SYSDATE,
        p_amount,
        UPPER(p_payment_method),
        p_reference_number
    );

    update_invoice_status(p_invoice_id);

    DBMS_OUTPUT.PUT_LINE('Payment recorded successfully.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, 'Invoice does not exist.');
END;
/


