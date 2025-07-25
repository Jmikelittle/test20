-- Look for any properties that might start with 'A' or contain malformed JSON
SELECT id, name, properties::text
FROM "workspace_1wgvd1injqtife6y4rvfbu3h5"."timelineActivity" 
WHERE properties::text LIKE 'A%' OR properties::text NOT LIKE '{%'
LIMIT 10;
