
SET ECHO ON
SET FEEDBACK ON
SET SERVEROUTPUT ON
SET PAGESIZE 100
SET LINESIZE 200

SPOOL estatecore_setup.log

WHENEVER SQLERROR EXIT SQL.SQLCODE

PROMPT ========================================
PROMPT ESTATECORE DATABASE SETUP
PROMPT ========================================

PROMPT STEP 1: CREATE TABLES
@sql/01_create_tables.sql

PROMPT STEP 2: INSERT SAMPLE DATA
@sql/02_insert_sample_data.sql

PROMPT STEP 3: CREATE INDEXES
@sql/03_indexes_constraints.sql

PROMPT STEP 4: CREATE INVOICE PROCEDURES
@sql/04_invoice_procedures.sql

PROMPT STEP 5: CREATE AUDIT TRIGGER
@sql/05_audit_trigger.sql

PROMPT STEP 6: CREATE PAYMENT PROCEDURE
@sql/06_payment_procedures.sql

PROMPT STEP 7: CREATE PACKAGE
@sql/07_estatecore_package.sql

PROMPT STEP 8: RUN REPORTS
@sql/08_reporting_queries.sql

PROMPT ========================================
PROMPT ESTATECORE SETUP FINISHED
PROMPT ========================================

SPOOL OFF
EXIT
