# Volunteer Gardening Project - Twenty CRM Setup Guide

## Project Overview
This guide sets up Twenty CRM for a community volunteer gardening project to connect:
- **Homeowners** who want to replace grass with native flowers
- **Volunteer evaluators** who assess requests and properties  
- **Volunteer workers** who perform the actual gardening work
- **Plant database** with growing conditions and compatibility
- **Geographic areas** and address management

## Prerequisites Installation Status
✅ Node.js v22.17.1 - Installed
✅ Docker Desktop - Installed
✅ **Language Support** - French (fr-FR) and English (en) available
⏳ Yarn v4 - Needs corepack enable (requires admin)
⏳ PostgreSQL & Redis - Will use Docker containers

## Quick Setup Steps

### 1. Enable Yarn (Run as Administrator)
```powershell
# Open PowerShell as Administrator
corepack enable
yarn --version
```

### 2. Start Required Services
```powershell
cd twenty
# Start PostgreSQL and Redis with Docker
make postgres-on-docker
make redis-on-docker
```

### 3. Configure Environment
```powershell
# Copy environment files
cp ./packages/twenty-front/.env.example ./packages/twenty-front/.env
cp ./packages/twenty-server/.env.example ./packages/twenty-server/.env
```

### 4. Install Dependencies and Setup Database
```powershell
yarn
npx nx database:reset twenty-server
```

### 5. Start All Services
```powershell
# Option 1: Start all at once
npx nx start

# Option 2: Start individually
npx nx start twenty-server
npx nx worker twenty-server  
npx nx start twenty-front
```

### 6. Access Twenty CRM
- **Frontend**: http://localhost:3001
- **Default Login**: tim@apple.dev / tim@apple.dev
- **GraphQL API**: http://localhost:3000/graphql
- **REST API**: http://localhost:3000/rest

## Language Configuration (English/French)

Twenty CRM includes full internationalization support with French already available.

### Available Languages
- **English (en)** - Default/source language
- **French (fr-FR)** - Fully translated interface
- Plus 25+ other languages including Spanish, German, Italian, etc.

### Setting User Language
After logging in, users can set their language preference:
1. Go to **Settings** → **Profile** → **Appearance**
2. Select **Language** → **Français (French)** or **English**
3. The interface will immediately update to the selected language

### Default Workspace Language
Workspace admins can set the default language:
1. Go to **Settings** → **Workspace** → **General**
2. Set default language for new users
3. This affects new user onboarding and default language selection

### French Field Labels for Gardening Project
When customizing objects, you can provide field labels in both languages:

**English → French Translations for Key Fields:**
- Homeowners → Propriétaires
- Volunteers → Bénévoles  
- Service Requests → Demandes de service
- Property Address → Adresse de la propriété
- Garden Size → Taille du jardin
- Native Plants → Plantes indigènes
- Sun Conditions → Conditions d'ensoleillement
- Soil Type → Type de sol
- Budget Range → Gamme de budget
- Timeline → Échéancier
- Project Status → Statut du projet
- Evaluation → Évaluation
- Work Session → Session de travail

## Custom Data Models for Gardening Project

### Core Entities

#### 1. Homeowners (extends People)
```
- Name, Email, Phone
- Property Address
- Property Size (sq ft)
- Current Grass Type
- Sun/Shade Conditions
- Soil Type
- Preferred Native Plants
- Budget Range
- Timeline Preference
- Status (Requested, Evaluated, Approved, In Progress, Completed)
```

#### 2. Volunteers
```
- Name, Email, Phone  
- Role (Evaluator, Worker, Both)
- Expertise Level (Beginner, Intermediate, Expert)
- Available Days/Times
- Service Area (Geographic)
- Skills (Plant Knowledge, Landscaping, Soil Prep)
- Volunteer Hours Logged
```

#### 3. Service Requests
```
- Homeowner (Relation)
- Request Date
- Property Address
- Assessment Status
- Assigned Evaluator
- Evaluation Notes
- Recommended Plants
- Estimated Hours
- Priority Level
- Project Status
- Assigned Workers
- Completion Date
```

#### 4. Native Plants Database
```
- Plant Name (Common & Scientific)
- Plant Type (Perennial, Annual, Shrub, Tree)
- Sun Requirements (Full Sun, Partial, Shade)
- Water Needs (Low, Medium, High)
- Soil Type Preference
- Bloom Time
- Height/Spread
- Native Region
- Care Instructions
- Companion Plants
```

#### 5. Geographic Areas
```
- Area Name
- Boundary Coordinates
- Service Zone
- Climate Zone
- Soil Characteristics
- Native Plant Zone
- Volunteer Coverage
```

#### 6. Work Sessions
```
- Service Request (Relation)
- Volunteers Assigned
- Date/Time
- Hours Worked
- Work Completed
- Materials Used
- Photos
- Homeowner Satisfaction
- Notes
```

### Workflow Automation Ideas

1. **Request Intake**: Homeowner submits → Auto-assign to nearest evaluator
2. **Evaluation**: Evaluator completes assessment → Notify homeowner & assign workers
3. **Scheduling**: Workers confirm availability → Send calendar invites
4. **Completion**: Mark complete → Send satisfaction survey
5. **Follow-up**: Schedule 30/60/90 day check-ins

### Views and Dashboards

1. **Homeowner Pipeline**: Kanban view (Requested → Evaluated → Approved → In Progress → Complete)
2. **Volunteer Schedule**: Calendar view of assignments
3. **Geographic Map**: Service requests by location
4. **Plant Reference**: Searchable database with filters
5. **Volunteer Tracking**: Hours, assignments, performance
6. **Seasonal Planning**: Projects by season/timing

## Data Import Preparation

### Sample CSV Templates

#### homeowners.csv
```csv
name,email,phone,address,property_size,current_grass,sun_conditions,soil_type,budget_range,timeline
John Smith,john@email.com,555-0101,123 Oak St,500,Kentucky Bluegrass,Full Sun,Clay,500-1000,Spring 2025
```

#### volunteers.csv  
```csv
name,email,phone,role,expertise,availability,service_area,skills
Jane Doe,jane@email.com,555-0201,Both,Intermediate,Weekends,North Zone,Plant Knowledge;Soil Prep
```

#### native_plants.csv
```csv
name,scientific_name,type,sun_needs,water_needs,soil_type,bloom_time,height,native_region
Purple Coneflower,Echinacea purpurea,Perennial,Full Sun,Low,Well-drained,Summer,2-3 feet,Eastern US
```

## Next Steps After Setup

1. **Customize Objects**: Use Twenty's data model editor to create custom fields
2. **Import Data**: Start with sample plant database and volunteer list  
3. **Configure Workflows**: Set up automation rules for request handling
4. **Test Process**: Walk through complete homeowner journey
5. **Train Users**: Create guides for different user roles
6. **Scale Gradually**: Start with small area, expand based on success

## Troubleshooting Resources

- **Twenty Documentation**: https://twenty.com/developers
- **Local Setup Issues**: https://twenty.com/developers/section/self-hosting/troubleshooting
- **GitHub Issues**: https://github.com/twentyhq/twenty/issues
- **Discord Community**: https://discord.gg/cx5n4Jzs57

## Project Benefits with Twenty CRM

✅ **Open Source**: No vendor lock-in, full customization
✅ **Self-Hosted**: Keep community data private and secure  
✅ **Extensible**: Add custom fields and workflows as needed
✅ **Modern UX**: Easy for volunteers to learn and use
✅ **Geographic Support**: Handle location-based assignments
✅ **Automation**: Reduce manual coordination work
✅ **Reporting**: Track volunteer hours, project success metrics
✅ **Mobile Friendly**: Volunteers can use on phones/tablets

This CRM setup will help streamline your volunteer gardening program and make it easier to scale across your community!
