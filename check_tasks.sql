-- Check task records for malformed createdBy data
SELECT id, "createdBy", title 
FROM "workspace_1wgvd1injqtife6y4rvfbu3h5".task 
WHERE "createdBy" IS NOT NULL
LIMIT 5;
