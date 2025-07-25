-- Check timelineActivity records for malformed JSON data
SELECT id, name, properties
FROM "workspace_1wgvd1injqtife6y4rvfbu3h5"."timelineActivity" 
WHERE properties IS NOT NULL
LIMIT 5;
