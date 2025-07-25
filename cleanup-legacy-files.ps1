#!/usr/bin/env pwsh
# Cleanup Script - Remove Redundant Files After Fork Workflow Implementation

Write-Host "🧹 Cleaning up redundant files after fork-based workflow setup..." -ForegroundColor Green
Write-Host "=" * 60

# Function to safely remove file with backup
function Remove-FileWithBackup {
    param($FilePath, $Reason)
    
    if (Test-Path $FilePath) {
        Write-Host "🗑️  Removing: $FilePath" -ForegroundColor Yellow
        Write-Host "   Reason: $Reason" -ForegroundColor Gray
        
        try {
            Remove-Item $FilePath -Force
            Write-Host "   ✅ Removed successfully" -ForegroundColor Green
        } catch {
            Write-Host "   ❌ Failed to remove: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "⚪ Not found: $FilePath" -ForegroundColor Gray
    }
}

# Function to archive file content before deletion
function Archive-FileContent {
    param($FilePath, $ArchiveSection)
    
    if (Test-Path $FilePath) {
        Write-Host "📁 Archiving content from: $FilePath" -ForegroundColor Cyan
        
        $content = Get-Content $FilePath -Raw
        $archiveEntry = @"

## Archived from $FilePath

$content

"@
        
        Add-Content "ARCHIVED_CONTENT.md" $archiveEntry
        Write-Host "   ✅ Content archived to ARCHIVED_CONTENT.md" -ForegroundColor Green
    }
}

Write-Host "`n📋 Files to be cleaned up:" -ForegroundColor Cyan

# 1. Remove the old setup script
Write-Host "`n1. Legacy Setup Script" -ForegroundColor Yellow
Remove-FileWithBackup "setup-gardening-project.ps1" "Superseded by setup-fork-workflow.ps1 and Docker-based setup"

# 2. Archive and remove the old setup guide
Write-Host "`n2. Legacy Setup Documentation" -ForegroundColor Yellow
if (Test-Path "GARDENING_PROJECT_SETUP.md") {
    Write-Host "📄 GARDENING_PROJECT_SETUP.md contains useful information - archiving before removal" -ForegroundColor Cyan
    Archive-FileContent "GARDENING_PROJECT_SETUP.md" "Legacy Setup Guide"
    Remove-FileWithBackup "GARDENING_PROJECT_SETUP.md" "Content moved to FORK_WORKFLOW_GUIDE.md and archived"
}

# 3. Keep CUSTOMIZATION_GUIDE.md but update its purpose
Write-Host "`n3. Customization Guide" -ForegroundColor Yellow
if (Test-Path "CUSTOMIZATION_GUIDE.md") {
    Write-Host "📝 CUSTOMIZATION_GUIDE.md - keeping but will update to reference fork workflow" -ForegroundColor Green
    Write-Host "   This file contains valuable Twenty CRM customization instructions" -ForegroundColor Gray
}

# 4. Remove package-lock.json from root (not needed here)
Write-Host "`n4. Package Lock File" -ForegroundColor Yellow
Remove-FileWithBackup "package-lock.json" "Not needed at project root level - belongs in Twenty source directories"

# 5. Keep docker-compose.yml as reference but mark it
Write-Host "`n5. Original Docker Compose" -ForegroundColor Yellow
if (Test-Path "docker-compose.yml") {
    Write-Host "📦 docker-compose.yml - keeping as reference setup" -ForegroundColor Green
    Write-Host "   Will add comment to indicate it's for reference only" -ForegroundColor Gray
}

Write-Host "`n🔄 Updating remaining files..." -ForegroundColor Cyan

# Update .gitignore if needed
if (Test-Path ".gitignore") {
    Write-Host "📝 Updating .gitignore for fork-based workflow..." -ForegroundColor Yellow
    
    # Add fork-specific ignore patterns
    $gitignoreAdditions = @"

# Fork-based development
twenty-reference/
twenty-gardening/
ARCHIVED_CONTENT.md

# Development artifacts
*.log
.DS_Store
Thumbs.db
"@
    
    try {
        Add-Content ".gitignore" $gitignoreAdditions
        Write-Host "   ✅ Updated .gitignore with fork-based patterns" -ForegroundColor Green
    } catch {
        Write-Host "   ❌ Failed to update .gitignore: $_" -ForegroundColor Red
    }
}

Write-Host "`n📊 Cleanup Summary:" -ForegroundColor Cyan
Write-Host "=" * 40

Write-Host "🗂️  Remaining Structure:" -ForegroundColor Green
$remainingFiles = @(
    "README.md (✅ Updated with fork workflow)",
    "start-gardening-project.ps1 (✅ Updated for fork detection)",
    "setup-fork-workflow.ps1 (✅ New fork setup script)",
    "FORK_WORKFLOW_GUIDE.md (✅ Comprehensive development guide)",
    "CUSTOMIZATION_GUIDE.md (✅ Twenty CRM specific instructions)",
    "docker-compose-fork.yml (✅ Fork-based Docker setup)",
    "docker-compose.yml (📚 Reference setup - keep for comparison)",
    "gardening-project-data/ (✅ Sample data)",
    ".env (✅ Environment configuration)",
    ".gitignore (✅ Updated)"
)

foreach ($file in $remainingFiles) {
    Write-Host "   $file" -ForegroundColor White
}

if (Test-Path "ARCHIVED_CONTENT.md") {
    Write-Host "`n📁 Archived Content:" -ForegroundColor Cyan
    Write-Host "   ARCHIVED_CONTENT.md contains content from removed files" -ForegroundColor White
}

Write-Host "`n🎯 Next Steps:" -ForegroundColor Cyan
Write-Host "1. Review ARCHIVED_CONTENT.md for any useful information" -ForegroundColor White
Write-Host "2. Create your fork at: https://github.com/twentyhq/twenty" -ForegroundColor White
Write-Host "3. Clone your fork: git clone https://github.com/Jmikelittle/twenty.git twenty-gardening" -ForegroundColor White
Write-Host "4. Test the setup: .\start-gardening-project.ps1" -ForegroundColor White
Write-Host "5. Begin customization following FORK_WORKFLOW_GUIDE.md" -ForegroundColor White

Write-Host "`n✨ Cleanup complete! Your project structure is now optimized for fork-based development." -ForegroundColor Green
