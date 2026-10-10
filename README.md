# EstateCore — Property Management Database

EstateCore is an Oracle SQL and PL/SQL database project designed to manage property units, tenants, leases, rent invoices, payments, maintenance requests, employees, and operating expenses.

The project demonstrates relational database design, business-rule enforcement, reusable PL/SQL logic, audit logging, and financial reporting.

## Features

- **Property and unit management:** Store property details, rental units, rent amounts, and occupancy statuses.
- **Tenant and lease management:** Maintain tenant records and lease agreements with integrity constraints.
- **Rent invoice management:** Track monthly rent invoices and payment statuses.
- **Payment processing:** Record payments and prevent payments from exceeding the outstanding invoice balance.
- **Maintenance tracking:** Manage maintenance requests, priorities, assignments, and costs.
- **Expense management:** Record property-related operating expenses.
- **Financial reporting:** Calculate outstanding rent, collection totals, property occupancy, and expenses.
- **PL/SQL automation:** Use stored procedures, functions, packages, and triggers.
- **Audit logging:** Record invoice-status changes for traceability.
- **Performance optimization:** Use indexes to support frequently executed queries.

## Technology Stack

- Oracle Database
- Oracle SQL
- PL/SQL
- Oracle SQL*Plus
- Git and GitHub

## Database Entities

| Table | Purpose |
|---|---|
| `PROPERTIES` | Stores property information |
| `UNITS` | Stores rental units and their statuses |
| `TENANTS` | Stores tenant information |
| `LEASES` | Stores lease agreements |
| `RENT_INVOICES` | Stores rent invoices and payment statuses |
| `PAYMENTS` | Stores payment transactions |
| `EMPLOYEES` | Stores employee information |
| `MAINTENANCE_REQUESTS` | Tracks maintenance activities |
| `EXPENSES` | Records property expenses |
| `AUDIT_LOG` | Stores audited changes |

## Key SQL and PL/SQL Concepts

- Primary keys, foreign keys, unique constraints, and check constraints
- Joins, subqueries, aggregate functions, `GROUP BY`, and `CASE`
- Common Table Expressions (CTEs)
- Stored procedures and user-defined functions
- Explicit cursor processing through cursor FOR loops
- Packages and package bodies
- Triggers and sequences
- Transaction control using `COMMIT`, `ROLLBACK`, and savepoints
- Indexes and function-based unique indexes
- Exception handling and application errors

## Business Rules

1. A unit must reference an existing property.
2. A lease must reference an existing unit and tenant.
3. Lease end dates must be later than start dates.
4. Invoice amounts and payment amounts must satisfy their validation constraints.
5. An invoice's status is derived from its total recorded payments.
6. A payment cannot exceed the remaining invoice balance when processed through the payment procedure.
7. A unit cannot have more than one active lease when the active-lease unique index is installed.
8. Invoice-status changes are recorded in the audit log.

## Example Reports

EstateCore supports reports for:

- Monthly rent collection
- Outstanding rent by property
- Invoice balances by tenant
- Property occupancy percentages
- Maintenance request status and costs
- Property expenses and net operating income

## Running the Project

1. Install or connect to an Oracle Database instance.
2. Open Oracle SQL*Plus and connect using a database schema where you have permission to create tables, procedures, triggers, indexes, and sequences.
3. Execute the SQL scripts in dependency order.
4. Enable PL/SQL output using `SET SERVEROUTPUT ON`.
5. Execute the reporting queries and test cases.
6. Review audit records and verify that business rules work as expected.

Run the scripts in this order:

1. `01_create_tables.sql`
2. `02_insert_sample_data.sql`
3. `03_indexes_constraints.sql`
4. `05_invoice_procedures.sql`
5. `07_audit_trigger.sql`
6. `06_payment_procedures.sql`
7. `08_estatecore_package.sql`
8. `04_reporting_queries.sql`
9. `09_test_cases.sql`

Execute `COMMIT` after the sample-data insertion script if its inserts have not already been committed. Test cases that deliberately trigger errors should be run individually.

## Project Status

The database schema, sample data, reporting queries, PL/SQL package, and validation features are being developed and tested in Oracle SQL*Plus.

## Future Enhancements

- Automated monthly invoice generation
- Lease-expiry notifications
- Monthly collection and expense summaries
- Additional validation and transaction-handling tests
- Integration with a Java Spring Boot REST API
- A web dashboard for property managers

## Author

Pratik Pramod Dahale

GitHub: [PratikPDahale](https://github.com/PratikPDahale)

LinkedIn: [Pratik Dahale](https://linkedin.com/in/pratik-dahale-b8084b2a7)
