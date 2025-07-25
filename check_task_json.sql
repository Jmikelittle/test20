-- Check for malformed JSON in task createdByContext
SELECT id, title, "createdByContext"::text 
FROM "workspace_1wgvd1injqtife6y4rvfbu3h5".task 
WHERE "createdByContext"::text LIKE 'A%' 
   OR ("createdByContext"::text IS NOT NULL AND "createdByContext"::text NOT LIKE '{%')
LIMIT 5;
