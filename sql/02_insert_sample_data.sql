
SET ECHO ON
SET FEEDBACK ON

INSERT INTO properties VALUES
(101, 'Green Heights', 'Pune', 'RESIDENTIAL', DATE '2026-01-01');

INSERT INTO properties VALUES
(102, 'Sunrise Residency', 'Pune', 'RESIDENTIAL', DATE '2026-02-01');

INSERT INTO units VALUES (1, 101, 'A-101', 15000, 'OCCUPIED');
INSERT INTO units VALUES (2, 101, 'A-102', 18000, 'OCCUPIED');
INSERT INTO units VALUES (3, 102, 'B-101', 12000, 'OCCUPIED');

INSERT INTO tenants VALUES
(201, 'Rahul Sharma', 'rahul@gmail.com', '9876543210', 'Pune', DATE '2026-01-01');

INSERT INTO tenants VALUES
(202, 'Priya Patil', 'priya@gmail.com', '9876543211', 'Mumbai', DATE '2026-02-01');

INSERT INTO tenants VALUES
(203, 'Amit Deshmukh', 'amit@gmail.com', '9876543212', 'Pune', DATE '2026-03-01');

INSERT INTO employees VALUES
(501, 'Sanjay Kulkarni', 'sanjay@estatecore.com', 'Property Manager', DATE '2024-01-15', 45000);

INSERT INTO employees VALUES
(502, 'Neha Joshi', 'neha@estatecore.com', 'Maintenance Engineer', DATE '2024-06-10', 35000);

INSERT INTO employees VALUES
(503, 'Rohit Pawar', 'rohit@estatecore.com', 'Accountant', DATE '2025-02-01', 32000);

INSERT INTO leases VALUES
(301, 1, 201, DATE '2026-01-01', DATE '2026-12-31', 15000, 'ACTIVE');

INSERT INTO leases VALUES
(302, 2, 202, DATE '2026-04-01', DATE '2027-03-31', 18000, 'ACTIVE');

INSERT INTO leases VALUES
(303, 3, 203, DATE '2026-07-01', DATE '2027-06-30', 12000, 'ACTIVE');

INSERT INTO rent_invoices VALUES
(401, 301, DATE '2026-10-01', 15000, DATE '2026-10-05', 'UNPAID');

INSERT INTO rent_invoices VALUES
(402, 302, DATE '2026-10-01', 18000, DATE '2026-10-05', 'PAID');

INSERT INTO rent_invoices VALUES
(403, 303, DATE '2026-10-01', 12000, DATE '2026-10-05', 'PARTIAL');

INSERT INTO payments VALUES
(601, 402, DATE '2026-10-04', 18000, 'UPI', 'PAY-2026-001');

INSERT INTO payments VALUES
(602, 403, DATE '2026-10-06', 5000, 'BANK_TRANSFER', 'PAY-2026-002');

INSERT INTO payments VALUES
(603, 403, DATE '2026-10-08', 2000, 'UPI', 'PAY-2026-003');

INSERT INTO maintenance_requests VALUES
(701, 1, 201, 502, DATE '2026-10-02',
 'Water leakage in bathroom', 'HIGH', 'IN_PROGRESS', 3000, NULL);

INSERT INTO maintenance_requests VALUES
(702, 2, 202, 502, DATE '2026-10-03',
 'Electrical switch replacement', 'MEDIUM', 'RESOLVED', 1000, 850);

INSERT INTO maintenance_requests VALUES
(703, 3, 203, NULL, DATE '2026-10-07',
 'Air conditioner inspection', 'LOW', 'OPEN', 1500, NULL);

INSERT INTO expenses VALUES
(801, 101, 503, DATE '2026-10-05',
 'MAINTENANCE', 850, 'Electrical switch replacement');

INSERT INTO expenses VALUES
(802, 101, 503, DATE '2026-10-06',
 'CLEANING', 2000, 'Common area cleaning');

INSERT INTO expenses VALUES
(803, 102, 503, DATE '2026-10-07',
 'MAINTENANCE', 1200, 'Routine property maintenance');

COMMIT;
