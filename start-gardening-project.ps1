#!/usr/bin/env pwsh
# Gardening Project - Twenty CRM Startup Script (Fork-Based)

Write-Host "🌱 Starting Volunteer Gardening Project - Twenty CRM" -ForegroundColor Green
Write-Host "=" * 50

# Check current setup and determine which Docker Compose file to use
Write-Host "Detecting project setup..." -ForegroundColor Yellow

if ((Test-Path "twenty-gardening") -and (Get-ChildItem "twenty-gardening" -Force -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
    Write-Host "✅ Using fork-based setup (twenty-gardening/)" -ForegroundColor Green
    $composeFile = "docker-compose-fork.yml"
    $setupType = "fork"
} elseif ((Test-Path "twenty") -and (Get-ChildItem "twenty" -Force -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
    Write-Host "⚠️  Using reference setup (twenty/) - consider upgrading to fork" -ForegroundColor Yellow
    $composeFile = "docker-compose.yml"
    $setupType = "reference"
} else {
    Write-Host "❌ No Twenty CRM source found." -ForegroundColor Red
    Write-Host "   Run: .\setup-fork-workflow.ps1 to set up fork-based development" -ForegroundColor Gray
    exit 1
}

# Check if Docker is running
Write-Host "Checking Docker status..." -ForegroundColor Yellow
try {
    docker version | Out-Null
    Write-Host "✅ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running. Please start Docker Desktop first." -ForegroundColor Red
    exit 1
}

# Check if docker-compose file exists
if (-not (Test-Path $composeFile)) {
    Write-Host "❌ $composeFile not found in current directory" -ForegroundColor Red
    if ($setupType -eq "fork") {
        Write-Host "   Run: .\setup-fork-workflow.ps1 to create the fork-based configuration" -ForegroundColor Gray
    }
    exit 1
}

# Stop any existing containers
Write-Host "Stopping any existing containers..." -ForegroundColor Yellow
docker-compose -f $composeFile down --remove-orphans

# Start the gardening project
Write-Host "Starting Gardening Project CRM containers..." -ForegroundColor Yellow
docker-compose -f $composeFile up -d

# Wait for services to be healthy
Write-Host "Waiting for services to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# Check service status
Write-Host "Checking service status..." -ForegroundColor Yellow
docker-compose -f $composeFile ps

Write-Host "`n🎉 Gardening Project CRM is starting up!" -ForegroundColor Green
Write-Host "📋 Access Information:" -ForegroundColor Cyan
Write-Host "   Frontend:  http://localhost:3001" -ForegroundColor White
Write-Host "   Backend:   http://localhost:3000" -ForegroundColor White
Write-Host "   GraphQL:   http://localhost:3000/graphql" -ForegroundColor White
Write-Host "   REST API:  http://localhost:3000/rest" -ForegroundColor White
Write-Host "`n🔑 Default Login:" -ForegroundColor Cyan
Write-Host "   Email:     tim@apple.dev" -ForegroundColor White
Write-Host "   Password:  Applecar2025" -ForegroundColor White
Write-Host "   (Default dev environment credentials)" -ForegroundColor Gray

Write-Host "`n� Architecture:" -ForegroundColor Cyan
if ($setupType -eq "fork") {
    Write-Host "   Stock:     twenty-reference/ (reference only)" -ForegroundColor Gray
    Write-Host "   Custom:    twenty-gardening/ (your modifications)" -ForegroundColor Green
    Write-Host "   Docker:    $composeFile (fork-based)" -ForegroundColor Green
} else {
    Write-Host "   Current:   twenty/ (mixed stock + custom)" -ForegroundColor Yellow
    Write-Host "   Docker:    $composeFile (reference setup)" -ForegroundColor Yellow
    Write-Host "   Consider:  Run .\setup-fork-workflow.ps1 for cleaner structure" -ForegroundColor Gray
}

Write-Host "`n�📊 To monitor logs:" -ForegroundColor Cyan
Write-Host "   docker-compose -f $composeFile logs -f" -ForegroundColor White

Write-Host "`n🛑 To stop the project:" -ForegroundColor Cyan
Write-Host "   docker-compose -f $composeFile down" -ForegroundColor White

Write-Host "`n⏳ Please wait 1-2 minutes for full startup, then visit http://localhost:3001" -ForegroundColor Yellow
