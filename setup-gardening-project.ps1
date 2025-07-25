# Twenty CRM Setup Script for Volunteer Gardening Project
# Run this script from the twenty directory

Write-Host "🌱 Setting up Twenty CRM for Volunteer Gardening Project..." -ForegroundColor Green

# Check if running as administrator for corepack
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    Write-Host "⚠️  Warning: Not running as Administrator. You may need to enable corepack manually." -ForegroundColor Yellow
    Write-Host "   Run 'corepack enable' in an Administrator PowerShell window" -ForegroundColor Yellow
} else {
    Write-Host "✅ Running as Administrator - enabling corepack..." -ForegroundColor Green
    try {
        corepack enable
        Write-Host "✅ Corepack enabled successfully" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to enable corepack: $_" -ForegroundColor Red
    }
}

# Check if Docker is running
Write-Host "🐳 Checking Docker status..." -ForegroundColor Cyan
try {
    docker ps | Out-Null
    Write-Host "✅ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running. Please start Docker Desktop and try again." -ForegroundColor Red
    Write-Host "   You can start it from the Start menu or system tray" -ForegroundColor Yellow
    exit 1
}

# Check if we're in the right directory
if (-not (Test-Path "package.json")) {
    Write-Host "❌ Please run this script from the twenty directory" -ForegroundColor Red
    exit 1
}

Write-Host "📋 Creating environment files..." -ForegroundColor Cyan
if (-not (Test-Path "./packages/twenty-front/.env")) {
    Copy-Item "./packages/twenty-front/.env.example" "./packages/twenty-front/.env"
    Write-Host "✅ Created front-end .env file" -ForegroundColor Green
} else {
    Write-Host "ℹ️  Front-end .env file already exists" -ForegroundColor Yellow
}

if (-not (Test-Path "./packages/twenty-server/.env")) {
    Copy-Item "./packages/twenty-server/.env.example" "./packages/twenty-server/.env"
    Write-Host "✅ Created server .env file" -ForegroundColor Green
} else {
    Write-Host "ℹ️  Server .env file already exists" -ForegroundColor Yellow
}

Write-Host "🗄️  Starting PostgreSQL container..." -ForegroundColor Cyan
try {
    make postgres-on-docker
    Write-Host "✅ PostgreSQL container started" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to start PostgreSQL: $_" -ForegroundColor Red
}

Write-Host "📦 Starting Redis container..." -ForegroundColor Cyan
try {
    make redis-on-docker
    Write-Host "✅ Redis container started" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to start Redis: $_" -ForegroundColor Red
}

Write-Host "📦 Installing dependencies (this may take a while)..." -ForegroundColor Cyan
try {
    yarn install
    Write-Host "✅ Dependencies installed successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to install dependencies: $_" -ForegroundColor Red
    Write-Host "   Try running 'yarn install' manually" -ForegroundColor Yellow
}

Write-Host "🗄️  Setting up database..." -ForegroundColor Cyan
try {
    npx nx database:reset twenty-server
    Write-Host "✅ Database setup complete" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to setup database: $_" -ForegroundColor Red
    Write-Host "   Try running 'npx nx database:reset twenty-server' manually" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎉 Setup Complete! Next steps:" -ForegroundColor Green
Write-Host "1. Start the services: npx nx start" -ForegroundColor White
Write-Host "2. Open http://localhost:3001 in your browser" -ForegroundColor White
Write-Host "3. Login with: tim@apple.dev / tim@apple.dev" -ForegroundColor White
Write-Host "4. Import sample data from gardening-project-data folder" -ForegroundColor White
Write-Host ""
Write-Host "📚 See GARDENING_PROJECT_SETUP.md for detailed configuration guide" -ForegroundColor Cyan

# Ask if user wants to start services now
$startNow = Read-Host "Would you like to start Twenty services now? (y/N)"
if ($startNow -eq "y" -or $startNow -eq "Y") {
    Write-Host "🚀 Starting Twenty services..." -ForegroundColor Green
    npx nx start
}
