
CREATE INDEX idx_units_property
ON units(property_id);

CREATE INDEX idx_leases_unit_status
ON leases(unit_id, lease_status);

CREATE INDEX idx_leases_tenant
ON leases(tenant_id);

CREATE INDEX idx_payments_invoice
ON payments(invoice_id);

CREATE INDEX idx_maintenance_unit_status
ON maintenance_requests(unit_id, request_status);

CREATE INDEX idx_expenses_property_date
ON expenses(property_id, expense_date);

CREATE UNIQUE INDEX uq_one_active_lease_per_unit
ON leases (
    CASE WHEN lease_status = 'ACTIVE' THEN unit_id END
);
