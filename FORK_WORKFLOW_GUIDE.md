# Fork-Based Development Workflow Guide

## 🏗️ Project Architecture

`
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
`

## 🔄 Development Workflow

### Making Changes

1. **Navigate to your fork**:
   `powershell
   cd twenty-gardening
   `

2. **Create a feature branch**:
   `powershell
   git checkout -b feature/native-plant-database
   `

3. **Make your changes**:
   - Backend: 'packages/twenty-server/src/'
   - Frontend: 'packages/twenty-front/src/'
   - Database: 'packages/twenty-server/src/database/'

4. **Test your changes**:
   `powershell
   cd ..  # Back to test20 directory
   .\start-gardening-project.ps1
   `

5. **Commit and push**:
   `powershell
   cd twenty-gardening
   git add .
   git commit -m "Add native plant database schema"
   git push origin feature/native-plant-database
   `

### Keeping Up with Upstream

1. **Add upstream remote** (one-time setup):
   `powershell
   cd twenty-gardening
   git remote add upstream https://github.com/twentyhq/twenty.git
   `

2. **Update your fork with latest Twenty changes**:
   `powershell
   git fetch upstream
   git checkout main
   git merge upstream/main
   git push origin main
   `

3. **Update reference installation**:
   `powershell
   cd ../twenty-reference
   git pull origin main
   `

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
`powershell
.\start-gardening-project.ps1
`

### View Logs
`powershell
docker-compose -f docker-compose-fork.yml logs -f server
docker-compose -f docker-compose-fork.yml logs -f frontend
`

### Database Access
`powershell
docker-compose -f docker-compose-fork.yml exec db psql -U twenty -d default
`

### Rebuild After Changes
`powershell
docker-compose -f docker-compose-fork.yml down
docker-compose -f docker-compose-fork.yml build --no-cache
docker-compose -f docker-compose-fork.yml up -d
`

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
3. Run: git clone https://github.com/Jmikelittle/twenty.git twenty-gardening

### Docker Build Issues
`powershell
# Clean rebuild
docker-compose -f docker-compose-fork.yml down -v
docker system prune -f
docker-compose -f docker-compose-fork.yml build --no-cache
`

### Database Reset
`powershell
# Reset database and start fresh
docker-compose -f docker-compose-fork.yml down -v
docker-compose -f docker-compose-fork.yml up -d
# Wait for initialization, then seed
docker-compose -f docker-compose-fork.yml exec server npm run database:seed:dev
`
