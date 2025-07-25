#!/usr/bin/env pwsh
# Gardening Project - Twenty CRM Startup Script

Write-Host "🌱 Starting Volunteer Gardening Project - Twenty CRM" -ForegroundColor Green
Write-Host "=" * 50

# Check if Docker is running
Write-Host "Checking Docker status..." -ForegroundColor Yellow
try {
    docker version | Out-Null
    Write-Host "✅ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running. Please start Docker Desktop first." -ForegroundColor Red
    exit 1
}

# Check if docker-compose.yml exists
if (-not (Test-Path "docker-compose.yml")) {
    Write-Host "❌ docker-compose.yml not found in current directory" -ForegroundColor Red
    exit 1
}

# Stop any existing containers
Write-Host "Stopping any existing containers..." -ForegroundColor Yellow
docker-compose down --remove-orphans

# Start the gardening project
Write-Host "Starting Gardening Project CRM containers..." -ForegroundColor Yellow
docker-compose up -d

# Wait for services to be healthy
Write-Host "Waiting for services to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Check service status
Write-Host "Checking service status..." -ForegroundColor Yellow
docker-compose ps

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

Write-Host "`n📊 To monitor logs:" -ForegroundColor Cyan
Write-Host "   docker-compose logs -f" -ForegroundColor White

Write-Host "`n🛑 To stop the project:" -ForegroundColor Cyan
Write-Host "   docker-compose down" -ForegroundColor White

Write-Host "`n⏳ Please wait 1-2 minutes for full startup, then visit http://localhost:3001" -ForegroundColor Yellow
