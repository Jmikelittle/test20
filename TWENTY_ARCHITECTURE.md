# Twenty Technical Architecture

> A guide to understanding how Twenty CRM connects its database, application logic, and frontend

## Overview

Twenty is a modern, full-stack CRM built with a **monorepo architecture**. It uses industry-standard technologies organized into distinct layers that communicate through GraphQL.

```
┌─────────────────────────────────────────────────────────────────┐
│                         FRONTEND                                 │
│                      (twenty-front)                              │
│          React + TypeScript + Apollo Client + Recoil             │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ GraphQL (queries, mutations, subscriptions)
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      BACKEND API                                 │
│                     (twenty-server)                              │
│              NestJS + GraphQL Yoga + TypeORM                     │
├─────────────────────────────────────────────────────────────────┤
│                    BACKGROUND WORKER                             │
│                 BullMQ Jobs + Redis Queue                        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ TypeORM / SQL
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                        DATABASE                                  │
│                      PostgreSQL 16                               │
│              + Redis (caching/sessions/queues)                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## Tech Stack Summary

| Layer | Technology | Purpose |
|-------|------------|---------|
| **Frontend** | React 18, TypeScript | UI components |
| **State Management** | Recoil | Global state |
| **API Client** | Apollo Client | GraphQL queries/cache |
| **Styling** | Emotion | CSS-in-JS |
| **Build Tool** | Vite | Fast dev server & bundling |
| **Backend** | NestJS | Node.js framework |
| **API** | GraphQL Yoga | GraphQL server |
| **ORM** | TypeORM | Database abstraction |
| **Database** | PostgreSQL 16 | Primary data store |
| **Cache/Queue** | Redis | Sessions, caching, job queues |
| **Background Jobs** | BullMQ | Async task processing |
| **Monorepo** | Nx | Workspace management |
| **Package Manager** | Yarn 4 | Dependency management |

---

## Package Structure

```
packages/
├── twenty-front/          # React frontend application
├── twenty-server/         # NestJS backend API + Worker
├── twenty-ui/             # Shared UI components library
├── twenty-shared/         # Common types and utilities
├── twenty-emails/         # Email templates (React Email)
├── twenty-docker/         # Docker configuration
└── twenty-e2e-testing/    # Playwright E2E tests
```

---

## Layer 1: Database (PostgreSQL + Redis)

### PostgreSQL
The primary database stores all CRM data using a **multi-tenant architecture**.

**Key Concepts:**
- **Core Schema**: Stores workspace configurations, users, billing
- **Workspace Schemas**: Each workspace gets isolated data (`workspace_<id>`)
- **Migrations**: TypeORM migrations handle schema changes

**Location:** `packages/twenty-server/src/database/`

```
PostgreSQL
├── core schema
│   ├── workspaces
│   ├── users
│   └── billing
└── workspace_xxx schema (per tenant)
    ├── person
    ├── company
    ├── opportunity
    └── ... (all CRM objects)
```

### Redis
Used for:
- **Session storage**: User login sessions
- **Caching**: Metadata, frequently accessed data
- **Job queues**: BullMQ background job queues
- **Pub/Sub**: Real-time subscriptions

---

## Layer 2: Backend (NestJS + GraphQL)

### Architecture

The backend is built with **NestJS**, a progressive Node.js framework using TypeScript.

**Location:** `packages/twenty-server/src/`

```
src/
├── main.ts                    # Application entry point
├── app.module.ts              # Root module (imports all modules)
├── engine/                    # Core engine (framework-level code)
│   ├── api/                   # API layer (GraphQL, REST, MCP)
│   │   ├── graphql/           # GraphQL resolvers & config
│   │   └── rest/              # REST API endpoints
│   ├── core-modules/          # Authentication, billing, config
│   ├── metadata-modules/      # Object & field definitions
│   ├── twenty-orm/            # Custom ORM layer for workspaces
│   └── workspace-manager/     # Workspace lifecycle management
├── modules/                   # Business logic modules
│   ├── person/                # Person (contact) logic
│   ├── company/               # Company logic
│   ├── opportunity/           # Opportunity/deals logic
│   ├── messaging/             # Email sync
│   ├── calendar/              # Calendar sync
│   └── workflow/              # Workflow automation
└── database/                  # Database configuration & migrations
```

### How Data Flows: Database → API

1. **Entity Definition** (TypeORM)
   ```typescript
   // Defines the database table structure
   @WorkspaceEntity({ standardId: 'person' })
   export class PersonWorkspaceEntity {
     @WorkspaceField({ type: FieldMetadataType.FULL_NAME })
     name: FullNameMetadata;
     
     @WorkspaceRelation({ type: RelationMetadataType.MANY_TO_ONE })
     company: CompanyWorkspaceEntity;
   }
   ```

2. **Resolver** (GraphQL endpoint)
   ```typescript
   @Resolver(() => PersonWorkspaceEntity)
   export class PersonResolver {
     @Query(() => [PersonWorkspaceEntity])
     async people() {
       return this.personService.findAll();
     }
     
     @Mutation(() => PersonWorkspaceEntity)
     async createPerson(@Args('data') data: CreatePersonInput) {
       return this.personService.create(data);
     }
   }
   ```

3. **Service** (Business logic)
   ```typescript
   @Injectable()
   export class PersonService {
     constructor(
       @InjectRepository(PersonWorkspaceEntity)
       private personRepository: Repository<PersonWorkspaceEntity>
     ) {}
     
     async findAll() {
       return this.personRepository.find();
     }
   }
   ```

### GraphQL API

Twenty exposes **two GraphQL endpoints**:

| Endpoint | Purpose |
|----------|---------|
| `/graphql` | Main CRM data API (people, companies, etc.) |
| `/metadata` | Schema/object metadata management |

**GraphQL Playground:** http://localhost:3000/graphql

---

## Layer 3: Frontend (React + Apollo)

### Architecture

The frontend is a **React SPA** using TypeScript, built with Vite.

**Location:** `packages/twenty-front/src/`

```
src/
├── index.tsx                  # Application entry point
├── pages/                     # Route-based page components
├── modules/                   # Feature modules
│   ├── ui/                    # UI components
│   ├── activities/            # Notes, tasks, timeline
│   ├── object-record/         # Generic record CRUD
│   ├── settings/              # Settings pages
│   └── workflow/              # Workflow builder
├── hooks/                     # Custom React hooks
├── generated/                 # Auto-generated GraphQL types
└── locales/                   # Translations (Lingui)
```

### How Data Flows: API → UI

1. **GraphQL Query Definition**
   ```typescript
   // Defines what data to fetch
   const GET_PEOPLE = gql`
     query GetPeople {
       people {
         id
         name { firstName lastName }
         company { name }
       }
     }
   `;
   ```

2. **Apollo Hook** (Data fetching)
   ```typescript
   function PeopleList() {
     const { data, loading } = useQuery(GET_PEOPLE);
     
     if (loading) return <Loader />;
     return <Table data={data.people} />;
   }
   ```

3. **Recoil State** (Global state)
   ```typescript
   // Shared state across components
   const currentWorkspaceState = atom({
     key: 'currentWorkspace',
     default: null,
   });
   ```

### State Management

| Tool | Use Case |
|------|----------|
| **Apollo Cache** | Server data (GraphQL responses) |
| **Recoil** | Client-only state (UI state, selections) |
| **React State** | Component-local state |

---

## Background Worker

Twenty has a separate **worker process** for handling async jobs:

```
yarn worker:prod
```

**Uses:**
- **BullMQ** for job queues (backed by Redis)
- Email sync (Gmail, Microsoft)
- Calendar sync
- Workflow execution
- Data migrations

**Location:** `packages/twenty-server/src/queue-worker/`

---

## How Docker Is Used

Docker provides a consistent, reproducible environment for running Twenty.

### Docker Compose Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    docker-compose.yml                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │   server    │  │   worker    │  │     db      │              │
│  │             │  │             │  │             │              │
│  │ Port: 3000  │  │  (no port)  │  │ Port: 5432  │              │
│  │             │  │             │  │  (internal) │              │
│  │ twentycrm/  │  │ twentycrm/  │  │ postgres:16 │              │
│  │ twenty      │  │ twenty      │  │             │              │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘              │
│         │                │                │                      │
│         │                │                │                      │
│         └────────────────┴────────────────┘                      │
│                          │                                       │
│                          ▼                                       │
│                   ┌─────────────┐                                │
│                   │    redis    │                                │
│                   │             │                                │
│                   │ Port: 6379  │                                │
│                   │  (internal) │                                │
│                   └─────────────┘                                │
│                                                                  │
│  Volumes:                                                        │
│  - db-data (PostgreSQL data)                                     │
│  - server-local-data (file uploads)                              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Services Explained

| Service | Image | Purpose | Port |
|---------|-------|---------|------|
| **server** | `twentycrm/twenty` | Backend API + serves frontend | 3000 |
| **worker** | `twentycrm/twenty` | Background job processor | - |
| **db** | `postgres:16` | PostgreSQL database | 5432 (internal) |
| **redis** | `redis` | Cache, sessions, job queues | 6379 (internal) |

### The Dockerfile (Multi-Stage Build)

Location: `packages/twenty-docker/twenty/Dockerfile`

```dockerfile
# Stage 1: Install dependencies
FROM node:24-alpine AS common-deps
# Install yarn dependencies

# Stage 2: Build backend
FROM common-deps AS twenty-server-build
# Compile NestJS server with TypeScript

# Stage 3: Build frontend
FROM common-deps AS twenty-front-build
# Build React app with Vite

# Stage 4: Final runtime image
FROM node:24-alpine AS twenty
# Copy built artifacts from previous stages
# The frontend is served from: /app/packages/twenty-server/dist/front
```

**Key points:**
- Multi-stage build keeps the final image small
- Frontend is embedded IN the server image (served as static files)
- Same image used for both `server` and `worker` (different entrypoint commands)

### Entrypoint Script

Location: `packages/twenty-docker/twenty/entrypoint.sh`

```bash
#!/bin/sh

# 1. Run database migrations (if not disabled)
setup_and_migrate_db() {
    yarn database:migrate:prod
    yarn command:prod upgrade
}

# 2. Register background jobs
register_background_jobs() {
    yarn command:prod cron:register:all
}

# 3. Start the main process
exec "$@"  # Either 'yarn start:prod' or 'yarn worker:prod'
```

### Starting/Stopping Docker

```powershell
# Navigate to docker directory
cd packages/twenty-docker

# Start all services
docker compose up -d

# View logs
docker compose logs -f server

# Stop all services
docker compose down

# Stop and remove volumes (reset database)
docker compose down -v
```

### Environment Variables

Located in: `packages/twenty-docker/.env`

```env
TAG=latest                           # Docker image tag
SERVER_URL=http://localhost:3000     # Public URL
APP_SECRET=your_secret_here          # JWT signing secret
STORAGE_TYPE=local                   # File storage (local or S3)
SIGN_IN_PREFILLED=true               # Pre-fill demo credentials
```

---

## Request Flow: End-to-End Example

Here's what happens when you load the People list in Twenty:

```
1. Browser loads React app from http://localhost:3000
   └── Server serves static files from /dist/front

2. React app mounts, Apollo Client initializes
   └── Checks auth token in localStorage

3. PeopleList component renders
   └── Calls useQuery(GET_PEOPLE)

4. Apollo sends GraphQL request to /graphql
   └── POST { query: "{ people { id name ... } }" }

5. NestJS middleware validates JWT token
   └── Identifies user and workspace

6. GraphQL Yoga routes to PersonResolver
   └── @Query(() => [Person]) people()

7. PersonService queries database
   └── TypeORM: SELECT * FROM workspace_xxx.person

8. PostgreSQL returns rows
   └── Mapped to Person entities

9. Response sent back through layers
   └── GraphQL → HTTP → Apollo Cache → React render

10. UI displays the People table
```

---

## Development vs Production

| Aspect | Development | Production (Docker) |
|--------|-------------|---------------------|
| **Frontend** | Vite dev server (HMR) | Pre-built static files |
| **Backend** | ts-node (watch mode) | Compiled JavaScript |
| **Database** | Local PostgreSQL | Docker PostgreSQL |
| **Start Command** | `yarn start` | `docker compose up` |
| **Hot Reload** | Yes | No (rebuild required) |

---

## Key Files Reference

| File | Purpose |
|------|---------|
| `packages/twenty-server/src/main.ts` | Backend entry point |
| `packages/twenty-server/src/app.module.ts` | Root NestJS module |
| `packages/twenty-front/src/index.tsx` | Frontend entry point |
| `packages/twenty-docker/docker-compose.yml` | Docker orchestration |
| `packages/twenty-docker/twenty/Dockerfile` | Image build instructions |
| `packages/twenty-docker/twenty/entrypoint.sh` | Container startup script |
| `nx.json` | Monorepo configuration |
| `package.json` | Root dependencies |

---

## Useful Commands

```powershell
# Docker
docker compose up -d              # Start services
docker compose down               # Stop services
docker compose logs -f server     # View server logs
docker compose exec db psql -U postgres  # Connect to DB

# Development (without Docker)
yarn install                      # Install dependencies
yarn start                        # Start all services
npx nx start twenty-front         # Frontend only
npx nx start twenty-server        # Backend only

# Database
npx nx run twenty-server:database:reset  # Reset DB
npx nx run twenty-server:typeorm migration:run  # Run migrations

# GraphQL
# Visit http://localhost:3000/graphql for GraphQL Playground
```

---

*This document describes Twenty's architecture as of v0.33+*
