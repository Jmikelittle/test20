INSERT INTO metadata."dataSource" (id, url, schema, type, label, "isRemote", "workspaceId", "createdAt", "updatedAt")
VALUES (
    '20202020-0000-4000-8000-000000000001', 
    'postgres://postgres:postgres@db:5432/default', 
    '20202020_1c25_4d02_bf25_6aeccf7ea419', 
    'postgres', 
    'Main Database', 
    false, 
    '20202020-1c25-4d02-bf25-6aeccf7ea419', 
    NOW(), 
    NOW()
);
