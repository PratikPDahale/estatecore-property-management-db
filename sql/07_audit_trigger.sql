
CREATE SEQUENCE audit_log_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE OR REPLACE TRIGGER trg_invoice_status_audit
AFTER UPDATE OF invoice_status ON rent_invoices
FOR EACH ROW
WHEN (OLD.invoice_status <> NEW.invoice_status)
BEGIN
    INSERT INTO audit_log (
        audit_id,
        table_name,
        operation,
        record_id,
        changed_by,
        changed_at,
        details
    )
    VALUES (
        audit_log_seq.NEXTVAL,
        'RENT_INVOICES',
        'UPDATE',
        :NEW.invoice_id,
        USER,
        SYSTIMESTAMP,
        'Status changed from ' ||
        :OLD.invoice_status ||
        ' to ' ||
        :NEW.invoice_status
    );
END;
/
