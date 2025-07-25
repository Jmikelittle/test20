-- Fix missing workspaceMemberId column in favorite table
ALTER TABLE "workspace_1wgvd1injqtife6y4rvfbu3h5".favorite 
ADD COLUMN IF NOT EXISTS "workspaceMemberId" uuid;
