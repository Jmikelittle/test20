-- Check the KeyValuePair_type_enum values
SELECT enumlabel FROM pg_enum WHERE enumtypid = (
    SELECT oid FROM pg_type WHERE typname = 'KeyValuePair_type_enum'
);

-- Check the KeyValuePair table structure
\d core."keyValuePair";
