-- Run as SYSDBA / privileged user
-- Creates a read-only user for Oracle MCP server access
-- Default schema is set to STUDENT via logon trigger

-- 1. Create the read-only user
CREATE USER mcp_user IDENTIFIED BY mcp_user
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA 0 ON users;

-- 2. Grant only the ability to connect (no CREATE TABLE, no DDL)
GRANT CREATE SESSION TO mcp_user;

-- 3. Grant SELECT on every table owned by STUDENT
GRANT SELECT ON STUDENT.productlines  TO mcp_user;
GRANT SELECT ON STUDENT.products      TO mcp_user;
GRANT SELECT ON STUDENT.offices       TO mcp_user;
GRANT SELECT ON STUDENT.employees     TO mcp_user;
GRANT SELECT ON STUDENT.customers     TO mcp_user;
GRANT SELECT ON STUDENT.payments      TO mcp_user;
GRANT SELECT ON STUDENT.orders        TO mcp_user;
GRANT SELECT ON STUDENT.orderdetails  TO mcp_user;

CREATE OR REPLACE TRIGGER set_current_schema_mcp_user
AFTER LOGON ON mcp_user.SCHEMA
BEGIN
  EXECUTE IMMEDIATE 'ALTER SESSION SET CURRENT_SCHEMA = STUDENT';
END;
/

COMMIT;
