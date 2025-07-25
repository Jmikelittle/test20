# Community Gardening Project - Twenty CRM Implementation

A comprehensive CRM setup for connecting volunteer gardeners with homeowners who want to replace their grass with native flowers.

## 🌱 Project Overview

This repository contains a complete implementation guide for using Twenty CRM to manage:
- **Homeowners** requesting native plant conversions
- **Volunteer evaluators** assessing properties and plant compatibility  
- **Volunteer workers** performing the gardening work
- **Native plants database** with growing conditions
- **Geographic service areas** and volunteer coordination

## 🏗️ Architecture

### Fork-Based Development Structure
```
test20/                                    # Main project repository
├── twenty-reference/                      # Stock Twenty CRM (reference only)
├── twenty-gardening/                      # Your fork (modifications)
├── docker-compose-fork.yml               # Fork-based Docker setup
├── docker-compose.yml                    # Original Docker setup
├── gardening-project-data/               # Sample data for testing
├── start-gardening-project.ps1           # Startup script
└── setup-fork-workflow.ps1              # Fork setup script
```

### Benefits of Fork-Based Approach
- **🔒 Isolation**: Your changes don't affect the reference installation
- **🔄 Updates**: Easy to pull upstream improvements from Twenty
- **🎯 Focus**: Clear separation of stock vs custom code
- **🚀 Deployment**: Your fork can be deployed independently
- **🤝 Contribution**: Easy to contribute improvements back to Twenty

## 🚀 Quick Start

### Option 1: Fork-Based Setup (Recommended)
```powershell
# 1. Set up fork-based workflow
.\setup-fork-workflow.ps1

# 2. Start the project
.\start-gardening-project.ps1

# Access at http://localhost:3001
# Login: tim@apple.dev / Applecar2025
```

### Option 2: Reference Setup (Current)
```powershell
# Start with existing setup
.\start-gardening-project.ps1

# Or manually with Docker Compose
docker-compose up -d

# Access at http://localhost:3001
# Login: tim@apple.dev / Applecar2025
```

### Option 3: Development Setup
1. **Setup Guide**: See [GARDENING_PROJECT_SETUP.md](GARDENING_PROJECT_SETUP.md)
2. **Customization**: Follow [CUSTOMIZATION_GUIDE.md](CUSTOMIZATION_GUIDE.md)
3. **Automation**: Run `setup-gardening-project.ps1` for automated setup
4. **Sample Data**: Import from `gardening-project-data/` folder

## 🌐 Bilingual Support

Complete English and French interface support:
- **English**: Default setup with full documentation
- **Français**: Interface traduite avec données d'exemple en français

## 📁 Repository Structure

```
test20/
├── GARDENING_PROJECT_SETUP.md     # Complete setup guide (EN/FR)
├── CUSTOMIZATION_GUIDE.md         # Step-by-step customization
├── docker-compose.yml             # Docker container configuration
├── .env                           # Environment variables
├── start-gardening-project.ps1    # Automated Docker startup
├── setup-gardening-project.ps1    # Development setup (alternative)
├── gardening-project-data/        # Sample CSV files (EN + FR)
│   ├── sample_homeowners.csv      # English sample data
│   ├── proprietaires_echantillon.csv  # French sample data
│   ├── sample_volunteers.csv
│   ├── benevoles_echantillon.csv
│   ├── native_plants_database.csv
│   └── base_donnees_plantes_indigenes.csv
└── twenty/                        # Twenty CRM source code (reference)
```

## ✨ Key Features

- **🏠 Homeowner Management**: Property details, preferences, timeline
- **👥 Volunteer Coordination**: Skills, availability, service areas  
- **🌿 Plant Database**: Native species, growing conditions, companion plants
- **📍 Geographic Zones**: Service area management and volunteer assignment
- **🔄 Workflow Automation**: Request processing, evaluation, assignment
- **📊 Reporting**: Volunteer hours, project metrics, success tracking

## 🛠 Technology Stack

- **Twenty CRM**: Open-source, self-hosted CRM platform
- **Node.js v22**: Runtime environment
- **PostgreSQL**: Database with geographic support
- **Docker**: Containerized services
- **React/TypeScript**: Modern web interface

## 🎯 Use Case Benefits

This setup demonstrates Twenty CRM's capabilities for:
- Complex multi-party coordination
- Geographic-based service delivery
- Volunteer management and scheduling
- Knowledge base integration (plant database)
- Automated workflow processing
- Bilingual community support

Perfect for community organizations, environmental groups, and volunteer coordination!
