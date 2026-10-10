# EstateCore — Database Design

## 1. Project Overview

EstateCore is an Oracle SQL and PL/SQL-based property management database designed to manage properties, rental units, tenants, leases, rent invoices, payments, maintenance requests, employees, expenses, and audit records.

The database demonstrates relational database design, data integrity, SQL reporting, stored procedures, functions, packages, triggers, sequences, and transaction handling.

## 2. Database Tables

The database consists of 10 core tables.

| Table | Purpose |
|---|---|
| `PROPERTIES` | Stores property details such as name, city, and property type. |
| `UNITS` | Stores individual rental units, monthly rent, and occupancy status. |
| `TENANTS` | Stores tenant contact information. |
| `LEASES` | Records rental agreements between tenants and units. |
| `RENT_INVOICES` | Stores rent bills, invoice months, due dates, and payment statuses. |
| `PAYMENTS` | Records payments made against rent invoices. |
| `EMPLOYEES` | Stores employee details, job titles, and salaries. |
| `MAINTENANCE_REQUESTS` | Tracks maintenance issues, priorities, assigned employees, and costs. |
| `EXPENSES` | Records property-related expenses. |
| `AUDIT_LOG` | Stores audit records of tracked database changes. |

## 3. Entity Relationships

The database uses primary keys and foreign keys to maintain relationships between entities.

- **Properties → Units:** One property can contain multiple units.
- **Units → Leases:** A unit can have multiple lease records over time, subject to the active-lease restriction.
- **Tenants → Leases:** A tenant can have multiple lease records over time.
- **Leases → Rent Invoices:** A lease can have multiple rent invoices, with a unique invoice month per lease.
- **Rent Invoices → Payments:** One invoice can have multiple payment records, allowing partial payments.
- **Units → Maintenance Requests:** A unit can have multiple maintenance requests.
- **Tenants → Maintenance Requests:** A tenant can submit multiple maintenance requests.
- **Employees → Maintenance Requests:** An employee can be assigned multiple maintenance requests.
- **Properties → Expenses:** A property can have multiple expense records.
- **Employees → Expenses:** An employee can record multiple expenses.

The `AUDIT_LOG` table stores audit information separately from the main business records.

## 4. Primary Keys and Foreign Keys

Primary keys uniquely identify records in each table. Foreign keys maintain referential integrity by ensuring that related records reference existing parent records.

Examples:

- `UNITS.property_id` references `PROPERTIES.property_id`.
- `LEASES.unit_id` references `UNITS.unit_id`.
- `LEASES.tenant_id` references `TENANTS.tenant_id`.
- `RENT_INVOICES.lease_id` references `LEASES.lease_id`.
- `PAYMENTS.invoice_id` references `RENT_INVOICES.invoice_id`.

These constraints prevent invalid references between related tables.

## 5. Data Integrity Constraints

EstateCore uses several types of constraints to improve data quality.

- **PRIMARY KEY:** Uniquely identifies each record.
- **FOREIGN KEY:** Maintains relationships between tables.
- **NOT NULL:** Requires essential fields to contain values.
- **UNIQUE:** Prevents duplicate values in fields such as tenant email and employee email.
- **CHECK:** Restricts values to valid ranges or permitted categories.
- **DEFAULT:** Supplies default values for selected fields, such as creation dates and statuses.

Additional business rules include:

- Rent amounts and expense amounts must satisfy their defined non-negative or positive limits.
- Unit status must be `VACANT`, `OCCUPIED`, or `MAINTENANCE`.
- Invoice status must be `UNPAID`, `PARTIAL`, or `PAID`.
- Payment methods are restricted to supported values.
- A function-based unique index prevents more than one active lease for the same unit.

## 6. Indexing Strategy

Indexes are used to improve the performance of frequently executed queries and joins.

EstateCore includes indexes on selected columns used for:

- Finding units by property.
- Retrieving leases by unit and status.
- Finding leases associated with a tenant.
- Retrieving payments for an invoice.
- Filtering maintenance requests by unit and status.
- Searching expenses by property and date.

A unique constraint on `(lease_id, invoice_month)` prevents duplicate invoices for the same lease and month and supports lookups using those columns.

Indexes improve retrieval performance but require additional storage and maintenance during data modifications.

## 7. Rent Invoice and Payment Logic

Each rent invoice contains an amount due and a payment status.

The outstanding balance is calculated as:

`Outstanding Balance = Amount Due - Total Payments`

The database prevents the calculated balance from becoming negative in its balance-reporting functions.

Invoice statuses are determined as follows:

- `UNPAID`: No payment has been received.
- `PARTIAL`: Some payment has been received, but the invoice is not fully paid.
- `PAID`: Total payments meet or exceed the invoice amount.

The payment procedure validates the payment amount, locks the target invoice row during processing, checks the remaining balance, records the payment, and updates the invoice status.

## 8. PL/SQL Components

EstateCore uses Oracle PL/SQL to implement database business logic.

### Stored Procedures

- `UPDATE_INVOICE_STATUS`: Recalculates an invoice's payment status.
- `REFRESH_ALL_INVOICE_STATUSES`: Processes all invoices to refresh their statuses.
- `RECORD_PAYMENT`: Validates and records a payment, then updates the invoice status.

### Package

`ESTATECORE_PKG` groups reusable functions:

- `GET_INVOICE_BALANCE`: Calculates the remaining balance for an invoice.
- `GET_PROPERTY_OUTSTANDING`: Calculates outstanding rent for a property.

### Sequence and Trigger

- `AUDIT_LOG_SEQ` generates audit identifiers.
- `TRG_INVOICE_STATUS_AUDIT` records invoice status changes in the audit log.

## 9. Reporting and Business Queries

The reporting queries demonstrate how relational data can be combined to produce useful business information, including:

- Rent collection summaries.
- Outstanding rent by property.
- Property occupancy rates.
- Maintenance request status and cost reports.
- Property-wise expenses.
- Property financial performance.
- Invoice balances and audit history.

These reports use joins, aggregate functions, conditional expressions, subqueries, and common table expressions where supported by the installed Oracle version.

## 10. Transaction Handling

Transactions are important when recording payments because payment insertion and invoice-status updates must remain consistent.

EstateCore uses transaction control through Oracle's `COMMIT` and `ROLLBACK` mechanisms. Row-level locking in the payment procedure helps prevent concurrent payment requests from independently processing the same invoice balance.

Test transactions should be rolled back when the goal is to preserve the original sample data.

## 11. Design Considerations

The schema separates properties, units, tenants, leases, invoices, payments, employees, maintenance requests, and expenses into distinct tables. This reduces unnecessary duplication and makes relationships explicit.

The design also supports partial rent payments, historical lease records, maintenance tracking, and auditing of invoice status changes.

## 12. Technology Stack

- **Database:** Oracle Database
- **Query Language:** SQL
- **Procedural Language:** PL/SQL
- **Database Client:** Oracle SQL*Plus
- **Version Control:** Git and GitHub

## 13. Conclusion

EstateCore demonstrates the practical application of relational database design, integrity constraints, indexing, SQL reporting, PL/SQL procedures, packages, triggers, sequences, and transaction handling in a property management scenario.
