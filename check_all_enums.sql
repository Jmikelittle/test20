-- Check all enum types in the core schema
SELECT t.typname, e.enumlabel, e.enumsortorder
FROM pg_type t 
JOIN pg_enum e ON t.oid = e.enumtypid
WHERE t.typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'core')
ORDER BY t.typname, e.enumsortorder;
