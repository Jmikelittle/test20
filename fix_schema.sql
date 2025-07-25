-- Update dataSource to use the correct schema name
UPDATE metadata."dataSource" 
SET schema = 'workspace_1wgvd1injqtife6y4rvfbu3h5' 
WHERE "workspaceId" = '20202020-1c25-4d02-bf25-6aeccf7ea419';
