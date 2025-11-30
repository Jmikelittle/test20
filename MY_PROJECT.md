# My Twenty CRM Fork

> **Personal documentation for this fork of [Twenty](https://github.com/twentyhq/twenty) - The #1 Open-Source CRM**

## 🎯 Purpose of This Fork

### Community Garden Management CRM - Ottawa, Canada

This CRM will be used to manage a **community gardening project** that connects volunteers with residents to create native plant gardens throughout Ottawa neighborhoods.

### Core Entities

#### 👥 Volunteers
Gardeners who help plan and plant gardens on residents' yards.
- Contact information
- Availability / schedule
- Skills and experience level
- Preferred garden types or plants
- Active/inactive status

#### 🏠 Residents
Property owners who want help creating gardens on their yards.
- Contact information
- Communication preferences
- Garden goals and preferences
- Any accessibility considerations

#### 📍 Properties
Physical locations where gardens are planted.
- Address and geolocation (for mapping/routing)
- Garden size (square footage or dimensions)
- Sunlight exposure (full sun, partial shade, full shade)
- Soil conditions
- Water access availability
- Current garden status (planned, in-progress, established)
- Associated resident (owner)
- Assigned volunteers

#### 🌱 Plants
Native plants suited to Ottawa's climate (Zone 4b/5a).
- Common and scientific name
- Sunlight requirements
- Water needs
- Maintenance level (low, medium, high)
- Bloom season
- Native/pollinator-friendly designation
- Recommended for specific property conditions

### Key Relationships
```
Volunteers (Workspace Members) ─── log in, manage gardens
       │
       │ accountOwner / assignee
       ▼
Properties (Company) ◄──────────── Residents (Person)
       │                              (property owners)
       │
       ├──► Garden Projects (Opportunity)
       │
       ├──► Plants (Custom Object)
       │    (what's planted)
       │
       └──► Tasks (assigned to Volunteers)
```

### Why Twenty?

- [x] Open-source and self-hosted (data ownership)
- [x] Modern tech stack (React, NestJS, PostgreSQL)
- [x] Customizable objects and fields
- [x] Workflow automation capabilities
- [x] Active community and development

---

## 🚀 Quick Start Guide

### Option 1: Docker Compose (Recommended for Quick Testing)

The easiest way to see Twenty running locally:

```powershell
# Navigate to docker directory
cd packages/twenty-docker

# Start all services (PostgreSQL, Redis, Server, Worker)
docker compose up -d

# Access the app at http://localhost:3000
```

**Requirements:**
- Docker Desktop installed and running
- At least 4GB RAM available for Docker

### Option 2: Local Development Setup

For full development with hot-reloading:

```powershell
# 1. Install dependencies
yarn install

# 2. Start PostgreSQL and Redis (via Docker or locally)
# You still need these services running

# 3. Start development environment
yarn start

# Frontend: http://localhost:3001
# Backend API: http://localhost:3000
```

**Requirements:**
- Node.js (check `.nvmrc` for version)
- Yarn 4+
- PostgreSQL 16
- Redis

---

## 📋 Evaluation Checklist

Use this to track your evaluation of the stock Twenty CRM:

### Core Features to Test
- [ ] User registration and login
- [ ] Creating and managing contacts (People)
- [ ] Creating and managing companies
- [ ] Opportunities/Deals tracking
- [ ] Notes and activities
- [ ] Email integration
- [ ] Calendar integration

### Customization Capabilities
- [ ] Creating custom objects
- [ ] Adding custom fields
- [ ] Creating custom views (table, kanban)
- [ ] Filters and sorting
- [ ] Workflow automation

### Technical Aspects
- [ ] Performance with sample data
- [ ] Mobile responsiveness
- [ ] API access (GraphQL playground)
- [ ] Data export capabilities

---

## 📝 Notes & Observations

<!-- Add your notes as you explore the CRM -->

### What I Like:


### What I'd Want to Change:


### Questions/Concerns:


---

## 🔧 Planned Customizations

### Conceptual Model: Garden as Product

| Business Concept | Your Project | Description |
|------------------|--------------|-------------|
| **Product/Service** | Garden Installation | The deliverable you provide to residents |
| **Product Catalog** | Plants | Available native plants for Ottawa |
| **Line Items** | Plant Usages | Which plants, how many, in each garden |

### Object Mapping Strategy

| Your Entity | Twenty Object | Role |
|-------------|---------------|------|
| **Volunteers** | Workspace Member | Team members who log in and do the work |
| **Residents** | Person | Property owner contacts |
| **Properties** | Company (renamed) | Physical garden locations |
| **Garden Projects** | Opportunity | **THE PRODUCT** - the garden being delivered |
| **Plants** | Custom Object | **CATALOG** - plant database |
| **Plant Usages** | Custom Object | **LINE ITEMS** - plants in each garden |

### Customizations Needed

| Object | Type | Custom Fields to Add |
|--------|------|----------------------|
| **Volunteers** | Workspace Member | Availability, Skills, Experience Level |
| **Residents** | Person (standard) | Garden Goals, Accessibility Notes, Communication Preferences |
| **Properties** | Company (renamed) | Garden Size, Sunlight Exposure, Soil Type, Water Access |
| **Garden Projects** | Opportunity (standard) | Adapt stages: Planning → Planting → Established |
| **Plants** | New Custom Object | Scientific Name, Sunlight Req, Water Needs, Maintenance Level, Bloom Season |
| **Plant Usages** | New Custom Object | Plant (link), Garden Project (link), Quantity, Location in Garden, Planting Date |

### Benefits of This Mapping

- ✅ **Volunteers can log in** and see their assigned properties/tasks
- ✅ **Garden Projects are the "product"** you deliver to residents
- ✅ **Plants are a catalog** of available species (like a product catalog)
- ✅ **Plant Usages track what's planted** in each garden (like order line items)
- ✅ **Tasks can be assigned** directly to Volunteers in the UI
- ✅ **Full traceability**: which plants went into which gardens

### Custom Fields Detail

**Property Fields:**
- `gardenSizeSqFt` (Number) - Garden area in square feet
- `sunlightExposure` (Select) - Full Sun / Partial Shade / Full Shade
- `soilType` (Select) - Clay / Loam / Sandy / Unknown
- `waterAccess` (Boolean) - Has outdoor water access
- `status` (Select) - Prospective / Planned / In Progress / Established / Inactive
- `coordinates` (Text) - Lat/Long for mapping

**Plant Fields:**
- `scientificName` (Text)
- `sunlightRequirement` (Select) - Full Sun / Partial Shade / Full Shade
- `waterNeeds` (Select) - Low / Medium / High
- `maintenanceLevel` (Select) - Low / Medium / High
- `bloomSeason` (Multi-Select) - Spring / Summer / Fall
- `isNative` (Boolean)
- `isPollinator` (Boolean)

### Workflow Ideas
- [ ] Auto-assign volunteers to new properties based on location/availability
- [ ] Send reminders for seasonal planting windows
- [ ] Track volunteer hours and contributions
- [ ] Generate planting recommendations based on property conditions

---

## 📚 Useful Links

- [Twenty Documentation](https://docs.twenty.com)
- [Self-Hosting Guide](https://docs.twenty.com/developers/self-hosting/docker-compose)
- [Local Development Setup](https://docs.twenty.com/developers/local-setup)
- [API Documentation](https://docs.twenty.com/developers/rest-api)
- [Discord Community](https://discord.gg/cx5n4Jzs57)

---

## 📅 Log

| Date | Activity | Outcome |
|------|----------|---------|
| <!-- Add date --> | Forked repository | Success |
| <!-- Add date --> | First local run | Pending |
| | | |

---

*Last updated: November 28, 2025*
