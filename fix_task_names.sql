-- Update task createdByName to avoid JSON parsing conflicts
UPDATE "workspace_1wgvd1injqtife6y4rvfbu3h5".task 
SET "createdByName" = 'Tim Apple' 
WHERE "createdByName" = 'Tim A';
