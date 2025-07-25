#!/usr/bin/env pwsh
# Setup Fork-Based Workflow for Gardening Project

Write-Host "🔧 Setting up Fork-Based Workflow for Gardening Project" -ForegroundColor Green
Write-Host "=" * 60

# Function to check if directory exists and is not empty
function Test-DirectoryNotEmpty {
    param($Path)
    return (Test-Path $Path) -and ((Get-ChildItem $Path -Force | Measure-Object).Count -gt 0)
}

# Step 1: Restructure existing directories if needed
Write-Host "`n📁 Step 1: Restructuring directories..." -ForegroundColor Yellow

if (Test-DirectoryNotEmpty "twenty" -and !(Test-Path "twenty-reference")) {
    Write-Host "Moving existing 'twenty' to 'twenty-reference' (stock reference)..." -ForegroundColor Cyan
    
    try {
        Rename-Item "twenty" "twenty-reference"
        Write-Host "✅ Successfully moved twenty → twenty-reference" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to rename directory: $_" -ForegroundColor Red
        exit 1
    }
} elseif (Test-Path "twenty-reference") {
    Write-Host "✅ Stock reference already exists at 'twenty-reference'" -ForegroundColor Green
} else {
    Write-Host "⚠️  No existing Twenty installation found" -ForegroundColor Yellow
}

# Step 2: Fork instructions
Write-Host "`n🍴 Step 2: Creating your fork..." -ForegroundColor Yellow
Write-Host "To create your own fork of Twenty CRM:" -ForegroundColor Cyan
Write-Host "1. Open: https://github.com/twentyhq/twenty" -ForegroundColor White
Write-Host "2. Click the 'Fork' button in the top right" -ForegroundColor White
Write-Host "3. Select your account (Jmikelittle) as the destination" -ForegroundColor White
Write-Host "4. Keep the repository name as 'twenty'" -ForegroundColor White
Write-Host "5. Click 'Create fork'" -ForegroundColor White

# Step 3: Check if fork already exists
Write-Host "`n📥 Step 3: Checking for existing fork..." -ForegroundColor Yellow

if (Test-DirectoryNotEmpty "twenty-gardening") {
    Write-Host "✅ Fork already cloned at 'twenty-gardening'" -ForegroundColor Green
} else {
    Write-Host "Attempting to clone your fork..." -ForegroundColor Cyan
    
    try {
        # Try to clone the fork
        git clone https://github.com/Jmikelittle/twenty.git twenty-gardening
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Successfully cloned your fork to 'twenty-gardening'" -ForegroundColor Green
        } else {
            throw "Git clone failed"
        }
    } catch {
        Write-Host "⚠️  Could not clone fork automatically. Please run manually:" -ForegroundColor Yellow
        Write-Host "git clone https://github.com/Jmikelittle/twenty.git twenty-gardening" -ForegroundColor White
        Write-Host "`nThen re-run this script." -ForegroundColor Gray
        Read-Host "Press Enter to continue with manual setup"
    }
}

# Step 4: Create fork-based docker-compose
Write-Host "`n🐳 Step 4: Creating fork-based Docker configuration..." -ForegroundColor Yellow

$dockerComposeContent = @"
version: '3.8'

services:
  # Database - PostgreSQL 16
  db:
    image: postgres:16-alpine
    restart: always
    environment:
      POSTGRES_DB: default
      POSTGRES_USER: twenty
      POSTGRES_PASSWORD: twenty
      POSTGRES_INITDB_ARGS: "--encoding=UTF-8 --lc-collate=C --lc-ctype=C"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U twenty -d default"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Redis Cache
  redis:
    image: redis:7-alpine
    restart: always
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data
    ports:
      - "6379:6379"
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 3

  # Twenty Server (Your Fork)
  server:
    build:
      context: ./twenty-gardening
      dockerfile: packages/twenty-docker/prod/twenty-server/Dockerfile
      target: runner
    restart: always
    environment:
      # Database
      - PG_DATABASE_URL=postgres://twenty:twenty@db:5432/default
      - REDIS_URL=redis://redis:6379
      
      # Server URLs
      - FRONT_BASE_URL=http://localhost:3001
      - SERVER_URL=http://localhost:3000
      
      # Authentication
      - ACCESS_TOKEN_SECRET=replace_me_with_a_random_string_access
      - LOGIN_TOKEN_SECRET=replace_me_with_a_random_string_login
      - REFRESH_TOKEN_SECRET=replace_me_with_a_random_string_refresh
      - FILE_TOKEN_SECRET=replace_me_with_a_random_string_file
      
      # Storage
      - STORAGE_TYPE=local
      - STORAGE_LOCAL_PATH=/app/docker-data/storage
      
      # Email (disabled for local development)
      - EMAIL_DRIVER=console
      
      # Optional: Enable debug mode
      - DEBUG_MODE=true
      
      # Gardening Project Specific
      - PROJECT_NAME=Volunteer Gardening CRM
      - PROJECT_DESCRIPTION=Connecting homeowners with volunteers for native plant conversions
      
    ports:
      - "3000:3000"
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    volumes:
      - storage_data:/app/docker-data/storage
      # Mount your custom code for development
      - ./twenty-gardening/packages/twenty-server/src:/app/packages/twenty-server/src:cached
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/healthz"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Twenty Frontend (Your Fork)
  frontend:
    build:
      context: ./twenty-gardening
      dockerfile: packages/twenty-docker/prod/twenty-front/Dockerfile
      target: runner
    restart: always
    environment:
      - REACT_APP_SERVER_BASE_URL=http://localhost:3000
      - REACT_APP_BASE_URL=http://localhost:3001
      - GENERATE_SOURCEMAP=false
    ports:
      - "3001:3000"
    depends_on:
      - server
    volumes:
      # Mount your custom frontend code for development
      - ./twenty-gardening/packages/twenty-front/src:/app/packages/twenty-front/src:cached
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Twenty Worker (Background jobs)
  worker:
    build:
      context: ./twenty-gardening
      dockerfile: packages/twenty-docker/prod/twenty-server/Dockerfile
      target: runner
    restart: always
    command: ["yarn", "worker:prod"]
    environment:
      # Same environment as server
      - PG_DATABASE_URL=postgres://twenty:twenty@db:5432/default
      - REDIS_URL=redis://redis:6379
      - FRONT_BASE_URL=http://localhost:3001
      - SERVER_URL=http://localhost:3000
      - ACCESS_TOKEN_SECRET=replace_me_with_a_random_string_access
      - LOGIN_TOKEN_SECRET=replace_me_with_a_random_string_login
      - REFRESH_TOKEN_SECRET=replace_me_with_a_random_string_refresh
      - FILE_TOKEN_SECRET=replace_me_with_a_random_string_file
      - STORAGE_TYPE=local
      - STORAGE_LOCAL_PATH=/app/docker-data/storage
      - EMAIL_DRIVER=console
      - DEBUG_MODE=true
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    volumes:
      - storage_data:/app/docker-data/storage
      - ./twenty-gardening/packages/twenty-server/src:/app/packages/twenty-server/src:cached

volumes:
  postgres_data:
    driver: local
  redis_data:
    driver: local
  storage_data:
    driver: local

networks:
  default:
    name: gardening-project-network
"@

try {
    $dockerComposeContent | Out-File -FilePath "docker-compose-fork.yml" -Encoding UTF8
    Write-Host "✅ Created docker-compose-fork.yml" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to create docker-compose-fork.yml: $_" -ForegroundColor Red
}

# Step 5: Update startup script
Write-Host "`n🚀 Step 5: Creating updated startup script..." -ForegroundColor Yellow

# The startup script will be updated in the next step

# Step 6: Create development guide
Write-Host "`n📚 Step 6: Creating development workflow guide..." -ForegroundColor Yellow

$workflowGuide = @"
# Fork-Based Development Workflow Guide

## 🏗️ Project Architecture

```
test20/                                    # Your main project repository
├── twenty-reference/                      # Stock Twenty CRM (read-only reference)
│   └── # Original Twenty CRM source code for reference
├── twenty-gardening/                      # Your fork (where modifications go)
│   ├── packages/twenty-server/src/        # Backend customizations
│   ├── packages/twenty-front/src/         # Frontend customizations
│   └── # Your gardening-specific changes
├── docker-compose-fork.yml               # Docker setup using your fork
├── docker-compose.yml                    # Original Docker setup (reference)
├── gardening-project-data/               # Your sample data
├── start-gardening-project.ps1           # Updated startup script
└── setup-fork-workflow.ps1              # This setup script
```

## 🔄 Development Workflow

### Making Changes

1. **Navigate to your fork**:
   ```powershell
   cd twenty-gardening
   ```

2. **Create a feature branch**:
   ```powershell
   git checkout -b feature/native-plant-database
   ```

3. **Make your changes**:
   - Backend: 'packages/twenty-server/src/'
   - Frontend: 'packages/twenty-front/src/'
   - Database: 'packages/twenty-server/src/database/'

4. **Test your changes**:
   ```powershell
   cd ..  # Back to test20 directory
   .\start-gardening-project.ps1
   ```

5. **Commit and push**:
   ```powershell
   cd twenty-gardening
   git add .
   git commit -m "Add native plant database schema"
   git push origin feature/native-plant-database
   ```

### Keeping Up with Upstream

1. **Add upstream remote** (one-time setup):
   ```powershell
   cd twenty-gardening
   git remote add upstream https://github.com/twentyhq/twenty.git
   ```

2. **Update your fork with latest Twenty changes**:
   ```powershell
   git fetch upstream
   git checkout main
   git merge upstream/main
   git push origin main
   ```

3. **Update reference installation**:
   ```powershell
   cd ../twenty-reference
   git pull origin main
   ```

## 🎯 Customization Areas

### Backend Customizations ('twenty-gardening/packages/twenty-server/src/')

- **Custom Objects**: 
  - 'engine/core-modules/' - Add gardening-specific data models
  - Examples: Plants, Projects, ServiceAreas, VolunteerSkills

- **API Endpoints**:
  - 'engine/api/' - Create REST APIs for plant database
  - 'engine/core-modules/graphql/' - GraphQL resolvers for matching logic

- **Business Logic**:
  - 'engine/core-modules/' - Volunteer-homeowner matching algorithms
  - 'engine/workspace-manager/' - Project workflow automation

- **Database Schema**:
  - 'database/migrations/' - Add tables for gardening data
  - 'database/seeds/' - Pre-populate with local plant species

### Frontend Customizations ('twenty-gardening/packages/twenty-front/src/')

- **Views**:
  - 'modules/' - Custom pages for project management
  - Examples: PlantCatalog, VolunteerDashboard, ProjectTimeline

- **Components**:
  - 'ui/' - Reusable gardening-specific widgets
  - Examples: PlantSelector, SeasonCalendar, SkillMatcher

- **Styling**:
  - 'theme/' - Community branding and gardening themes
  - 'assets/' - Gardening icons, plant photos

## 🌟 Gardening Project Features to Implement

### Phase 1: Core Setup
- [ ] Native plant database schema
- [ ] Homeowner and volunteer profiles
- [ ] Service area management
- [ ] Basic project creation

### Phase 2: Matching Logic
- [ ] Skill-based volunteer matching
- [ ] Geographic service area matching
- [ ] Seasonal project scheduling
- [ ] Availability calendar integration

### Phase 3: Community Features
- [ ] Bilingual support (English/French)
- [ ] Educational resources integration
- [ ] Progress tracking and photos
- [ ] Community recognition system

## 🚀 Quick Commands

### Start Development
```powershell
.\start-gardening-project.ps1
```

### View Logs
```powershell
docker-compose -f docker-compose-fork.yml logs -f server
docker-compose -f docker-compose-fork.yml logs -f frontend
```

### Database Access
```powershell
docker-compose -f docker-compose-fork.yml exec db psql -U twenty -d default
```

### Rebuild After Changes
```powershell
docker-compose -f docker-compose-fork.yml down
docker-compose -f docker-compose-fork.yml build --no-cache
docker-compose -f docker-compose-fork.yml up -d
```

## 📋 Benefits of This Approach

1. **🔒 Isolation**: Your changes don't affect the reference installation
2. **🔄 Updates**: Easy to pull upstream improvements from Twenty
3. **🎯 Focus**: Clear separation of stock vs custom code
4. **🚀 Deployment**: Your fork can be deployed independently
5. **🤝 Contribution**: Easy to contribute improvements back to Twenty
6. **👥 Collaboration**: Team members can work on the same fork
7. **🔧 Development**: Hot-reload for faster development cycles

## 🆘 Troubleshooting

### Fork Not Found
If your fork doesn't exist yet:
1. Go to https://github.com/twentyhq/twenty
2. Click "Fork" button
3. Run: `git clone https://github.com/Jmikelittle/twenty.git twenty-gardening`

### Docker Build Issues
```powershell
# Clean rebuild
docker-compose -f docker-compose-fork.yml down -v
docker system prune -f
docker-compose -f docker-compose-fork.yml build --no-cache
```

### Database Reset
```powershell
# Reset database and start fresh
docker-compose -f docker-compose-fork.yml down -v
docker-compose -f docker-compose-fork.yml up -d
# Wait for initialization, then seed
docker-compose -f docker-compose-fork.yml exec server npm run database:seed:dev
```
"@

try {
    $workflowGuide | Out-File -FilePath "FORK_WORKFLOW_GUIDE.md" -Encoding UTF8
    Write-Host "✅ Created FORK_WORKFLOW_GUIDE.md" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to create workflow guide: $_" -ForegroundColor Red
}

# Step 7: Summary
Write-Host "`n🎉 Fork-based workflow setup complete!" -ForegroundColor Green
Write-Host "=" * 60

Write-Host "`n📁 Directory Structure:" -ForegroundColor Cyan
if (Test-Path "twenty-reference") {
    Write-Host "   ✅ twenty-reference/     (Stock Twenty CRM - reference)" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  twenty-reference/     (Not found - run git clone)" -ForegroundColor Yellow
}

if (Test-Path "twenty-gardening") {
    Write-Host "   ✅ twenty-gardening/     (Your fork - modifications)" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  twenty-gardening/     (Not found - create fork first)" -ForegroundColor Yellow
}

Write-Host "   ✅ docker-compose-fork.yml  (Fork-based Docker setup)" -ForegroundColor Green
Write-Host "   ✅ FORK_WORKFLOW_GUIDE.md   (Development guide)" -ForegroundColor Green

Write-Host "`n🔄 Next Steps:" -ForegroundColor Cyan
Write-Host "1. Update your startup script: .\update-startup-script.ps1" -ForegroundColor White
Write-Host "2. Test the new setup: .\start-gardening-project.ps1" -ForegroundColor White
Write-Host "3. Read the workflow guide: Get-Content FORK_WORKFLOW_GUIDE.md" -ForegroundColor White

Write-Host "`n🌱 Ready to develop your gardening project with proper fork workflow!" -ForegroundColor Green
