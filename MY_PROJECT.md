# My Twenty CRM Fork

> **Personal documentation for this fork of [Twenty](https://github.com/twentyhq/twenty) - The #1 Open-Source CRM**

## 🎯 Purpose of This Fork

<!-- TODO: Fill in your intended use for this CRM -->

### What I Want to Use This Product For:

1. **[Add your primary use case here]**
   - Example: Managing contacts for my small business
   - Example: Tracking sales leads and customer relationships
   - Example: Learning about modern CRM architecture

2. **[Add secondary goals here]**
   - Example: Customizing workflows for my specific industry
   - Example: Integrating with my existing tools

### Why Twenty?

- [ ] Open-source and self-hosted (data ownership)
- [ ] Modern tech stack (React, NestJS, PostgreSQL)
- [ ] Customizable objects and fields
- [ ] Workflow automation capabilities
- [ ] Active community and development

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

<!-- Track customizations you want to make -->

| Priority | Customization | Status | Notes |
|----------|--------------|--------|-------|
| 1 | | Not Started | |
| 2 | | Not Started | |
| 3 | | Not Started | |

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
