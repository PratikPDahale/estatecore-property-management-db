
SET ECHO ON
SET FEEDBACK ON

CREATE TABLE properties (
    property_id NUMBER PRIMARY KEY,
    property_name VARCHAR2(100) NOT NULL,
    city VARCHAR2(50) NOT NULL,
    property_type VARCHAR2(30),
    created_at DATE DEFAULT SYSDATE
);

CREATE TABLE units (
    unit_id NUMBER PRIMARY KEY,
    property_id NUMBER NOT NULL,
    unit_number VARCHAR2(20) NOT NULL,
    monthly_rent NUMBER(10,2) NOT NULL,
    status VARCHAR2(20) DEFAULT 'VACANT' NOT NULL,
    CONSTRAINT fk_units_property
        FOREIGN KEY (property_id) REFERENCES properties(property_id),
    CONSTRAINT uq_unit_property
        UNIQUE (property_id, unit_number),
    CONSTRAINT chk_unit_rent CHECK (monthly_rent >= 0),
    CONSTRAINT chk_unit_status
        CHECK (status IN ('VACANT', 'OCCUPIED', 'MAINTENANCE'))
);

CREATE TABLE tenants (
    tenant_id NUMBER PRIMARY KEY,
    full_name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    phone VARCHAR2(15),
    city VARCHAR2(50),
    created_at DATE DEFAULT SYSDATE,
    CONSTRAINT uq_tenant_email UNIQUE (email)
);

CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    full_name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    job_title VARCHAR2(50) NOT NULL,
    hire_date DATE DEFAULT SYSDATE,
    salary NUMBER(10,2),
    CONSTRAINT uq_employee_email UNIQUE (email),
    CONSTRAINT chk_employee_salary CHECK (salary >= 0)
);

CREATE TABLE leases (
    lease_id NUMBER PRIMARY KEY,
    unit_id NUMBER NOT NULL,
    tenant_id NUMBER NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    monthly_rent NUMBER(10,2) NOT NULL,
    lease_status VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,
    CONSTRAINT fk_leases_unit
        FOREIGN KEY (unit_id) REFERENCES units(unit_id),
    CONSTRAINT fk_leases_tenant
        FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    CONSTRAINT chk_lease_dates CHECK (end_date > start_date),
    CONSTRAINT chk_lease_rent CHECK (monthly_rent >= 0),
    CONSTRAINT chk_lease_status
        CHECK (lease_status IN ('ACTIVE', 'EXPIRED', 'TERMINATED'))
);

CREATE TABLE rent_invoices (
    invoice_id NUMBER PRIMARY KEY,
    lease_id NUMBER NOT NULL,
    invoice_month DATE NOT NULL,
    amount_due NUMBER(10,2) NOT NULL,
    due_date DATE NOT NULL,
    invoice_status VARCHAR2(20) DEFAULT 'UNPAID' NOT NULL,
    CONSTRAINT fk_invoice_lease
        FOREIGN KEY (lease_id) REFERENCES leases(lease_id),
    CONSTRAINT uq_lease_invoice_month
        UNIQUE (lease_id, invoice_month),
    CONSTRAINT chk_invoice_amount CHECK (amount_due >= 0),
    CONSTRAINT chk_invoice_status
        CHECK (invoice_status IN ('UNPAID', 'PARTIAL', 'PAID'))
);

CREATE TABLE payments (
    payment_id NUMBER PRIMARY KEY,
    invoice_id NUMBER NOT NULL,
    payment_date DATE DEFAULT SYSDATE NOT NULL,
    amount_paid NUMBER(10,2) NOT NULL,
    payment_method VARCHAR2(20) NOT NULL,
    reference_number VARCHAR2(50),
    CONSTRAINT fk_payment_invoice
        FOREIGN KEY (invoice_id) REFERENCES rent_invoices(invoice_id),
    CONSTRAINT uq_payment_reference UNIQUE (reference_number),
    CONSTRAINT chk_payment_amount CHECK (amount_paid > 0),
    CONSTRAINT chk_payment_method
        CHECK (payment_method IN ('CASH', 'UPI', 'BANK_TRANSFER', 'CARD'))
);

CREATE TABLE maintenance_requests (
    request_id NUMBER PRIMARY KEY,
    unit_id NUMBER NOT NULL,
    tenant_id NUMBER NOT NULL,
    assigned_employee_id NUMBER,
    request_date DATE DEFAULT SYSDATE NOT NULL,
    description VARCHAR2(500) NOT NULL,
    priority VARCHAR2(10) DEFAULT 'MEDIUM' NOT NULL,
    request_status VARCHAR2(20) DEFAULT 'OPEN' NOT NULL,
    estimated_cost NUMBER(10,2),
    actual_cost NUMBER(10,2),
    CONSTRAINT fk_maintenance_unit
        FOREIGN KEY (unit_id) REFERENCES units(unit_id),
    CONSTRAINT fk_maintenance_tenant
        FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    CONSTRAINT fk_maintenance_employee
        FOREIGN KEY (assigned_employee_id)
        REFERENCES employees(employee_id),
    CONSTRAINT chk_maintenance_priority
        CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH')),
    CONSTRAINT chk_maintenance_status
        CHECK (request_status IN ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CANCELLED')),
    CONSTRAINT chk_maintenance_estimated_cost
        CHECK (estimated_cost >= 0),
    CONSTRAINT chk_maintenance_actual_cost
        CHECK (actual_cost >= 0)
);

CREATE TABLE expenses (
    expense_id NUMBER PRIMARY KEY,
    property_id NUMBER NOT NULL,
    recorded_by NUMBER NOT NULL,
    expense_date DATE DEFAULT SYSDATE NOT NULL,
    category VARCHAR2(30) NOT NULL,
    amount NUMBER(10,2) NOT NULL,
    description VARCHAR2(500),
    CONSTRAINT fk_expense_property
        FOREIGN KEY (property_id) REFERENCES properties(property_id),
    CONSTRAINT fk_expense_employee
        FOREIGN KEY (recorded_by) REFERENCES employees(employee_id),
    CONSTRAINT chk_expense_amount CHECK (amount > 0)
);

CREATE TABLE audit_log (
    audit_id NUMBER PRIMARY KEY,
    table_name VARCHAR2(50) NOT NULL,
    operation VARCHAR2(10) NOT NULL,
    record_id NUMBER,
    changed_by VARCHAR2(128) DEFAULT USER,
    changed_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    details VARCHAR2(4000),
    CONSTRAINT chk_audit_operation
        CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE'))
);
