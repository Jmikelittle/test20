# Twenty CRM Error Logging & Troubleshooting Guide

## 🔍 Real-Time Error Monitoring

### Start Log Monitor
```powershell
.\monitor-logs.ps1
```
This script will show all errors, SQL queries, and important events in color-coded output.

### Manual Log Checking
```powershell
# View recent errors
docker logs gardening-project-twenty-server-1 --tail 50

# Follow logs in real-time
docker logs -f gardening-project-twenty-server-1
```

## 🛠️ Common Errors & Solutions

### 1. Database Schema Mismatch Errors

**Error**: `relation "20202020_1c25_4d02_bf25_6ae..." does not exist`

**Solution**: Update the dataSource table to use correct schema mapping
```sql
UPDATE metadata."dataSource" 
SET schema = 'workspace_1wgvd1injqtife6y4rvfbu3h5' 
WHERE "workspaceId" = '20202020-1c25-4d02-bf25-6aeccf7ea419';
```

### 2. Enum Value Errors

**Error**: `invalid input value for enum core."KeyValuePair_type_enum":"USER_VAR"`

**Root Cause**: Version mismatch between application (v0.33.1) expecting "USER_VAR" and database having "USER_VARIABLE"

**Solution**: Add compatibility enum value
```sql
ALTER TYPE core."keyValuePair_type_enum" ADD VALUE 'USER_VAR';
```

**Current enum values**:
- USER_VARIABLE (original)
- FEATURE_FLAG
- CONFIG_VARIABLE  
- USER_VAR (added for v0.33.1 compatibility)

### 3. Activity JSON Parse Errors

**Error**: `SyntaxError: Unexpected token A in JSON at position 0` in `ActivityQueryResultGetterHandler`

**Root Cause**: The activity handler is trying to parse malformed JSON data, likely related to `createdBy` field construction from database records.

**Current Status**: Appears to be related to task records where `createdByName` contains "Tim A" and the application is constructing JSON incorrectly.

**Temporary Solution**: 
1. Update problematic records
2. Consider disabling activity processing if needed
3. Check for malformed JSON in task and activity related fields

**Query to identify issues**:
```sql
-- Check task createdBy construction
SELECT id, title, "createdByName", "createdByContext" 
FROM workspace_schema.task 
WHERE "createdByName" LIKE '%A%';
```

### 4. Missing Column Errors

**Error**: `column favorite.workspaceMemberId does not exist`

**Root Cause**: Database schema mismatch - application expects columns that don't exist in the current schema version.

**Solution**: Add missing columns to tables
```sql
-- Example fix (adjust table name as needed)
ALTER TABLE workspace_schema.favorite ADD COLUMN "workspaceMemberId" uuid;
```

**Error**: `An instance of EnvironmentVariables has failed the validation: property FRONT_BASE_URL has failed the following constraints: isUrl`

**Solution**: Add missing environment variables to docker-compose.yml
```yaml
environment:
  FRONTEND_URL: http://localhost:3000
  FRONT_BASE_URL: http://localhost:3000
```

### 4. Authentication Errors

**Error**: User login fails after password entry

**Common causes**:
- Missing workspace assignment
- Incorrect password hash
- Missing user variables

**Solutions applied**:
```sql
-- Set default workspace
UPDATE core."user" SET "defaultWorkspaceId" = '20202020-1c25-4d02-bf25-6aeccf7ea419' WHERE email = 'tim@apple.dev';

-- Update password hash
UPDATE core."user" SET "passwordHash" = '$2b$10$example_hash' WHERE email = 'tim@apple.dev';
```

## 🔧 Database Diagnostic Queries

### Check Workspace Configuration
```sql
SELECT * FROM core.workspace;
SELECT * FROM metadata."dataSource";
```

### Check User Setup
```sql
SELECT id, email, "defaultWorkspaceId", "emailVerified" FROM core."user";
```

### Check Enum Values
```sql
SELECT enumlabel FROM pg_enum WHERE enumtypid = (
    SELECT oid FROM pg_type WHERE typname = 'keyValuePair_type_enum'
) ORDER BY enumsortorder;
```

### Check Schema Mapping
```sql
SELECT "workspaceId", schema FROM metadata."dataSource";
```

## 📊 Monitoring Setup

### Enabled Debug Logging
Current docker-compose configuration includes:
```yaml
LOG_LEVEL: debug
DEBUG: true
```

### Container Health Status
```powershell
docker ps
docker-compose ps
```

### Database Connection Test
```powershell
docker exec -it gardening-project-twenty-db-1 psql -U postgres -d default -c "SELECT 1;"
```

## 🎯 Test User Credentials

**Email**: tim@apple.dev  
**Password**: password123  
**Workspace**: Apple (20202020-1c25-4d02-bf25-6aeccf7ea419)

## 📝 Version Compatibility Notes

This setup uses **Twenty CRM v0.33.1** which has specific requirements:
- Database schema must include v0.33.1 compatible enum values
- Environment variables must include FRONT_BASE_URL
- DataSource schema mapping must be correctly configured

The fixes applied ensure compatibility between the v0.33.1 application code and the initialized database schema.
