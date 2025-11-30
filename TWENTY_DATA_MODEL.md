# Twenty CRM Default Data Model

> Reference guide for the standard objects and relationships in Twenty CRM

## Overview

Twenty CRM uses a flexible data model with both **standard objects** (pre-built) and support for **custom objects**. All objects share common base fields and can be extended with custom fields.

---

## Base Fields (All Objects)

Every object includes these system-managed fields:

| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Primary key (auto-generated) |
| `createdAt` | DateTime | Record creation timestamp |
| `updatedAt` | DateTime | Last modification timestamp |
| `deletedAt` | DateTime | Soft delete timestamp (null if active) |
| `createdBy` | Actor | Who created the record |
| `position` | Number | Ordering position in lists/kanban |

---

## Core CRM Objects

### 1. 👤 Person (Contact)

A person/contact in the CRM - typically a customer, lead, or business contact.

**Fields:**

| Field | Type | Description |
|-------|------|-------------|
| `name` | FullName | First name + Last name |
| `emails` | Emails | List of email addresses (with primary) |
| `phones` | Phones | List of phone numbers (with primary) |
| `jobTitle` | Text | Professional title |
| `city` | Text | Location city |
| `linkedinLink` | Links | LinkedIn profile URL |
| `xLink` | Links | X/Twitter profile URL |
| `avatarUrl` | Text | Profile image URL (system-managed) |

**Key Relationships:**

| Relation | Target | Description |
|----------|--------|-------------|
| `company` | Company | The person's employer |
| `pointOfContactForOpportunities` | Opportunity[] | Deals where they're the main contact |
| `noteTargets` | NoteTarget[] | Notes linked to this person |
| `taskTargets` | TaskTarget[] | Tasks linked to this person |
| `calendarEventParticipants` | CalendarEventParticipant[] | Calendar events |
| `messageParticipants` | MessageParticipant[] | Email threads |

---

### 2. 🏢 Company

An organization/business entity in the CRM.

**Fields:**

| Field | Type | Description |
|-------|------|-------------|
| `name` | Text | Company name |
| `domainName` | Links | Company website (also used for logo) |
| `address` | Address | Full address (street, city, state, postal, country, lat/lng) |
| `employees` | Number | Employee count |
| `linkedinLink` | Links | LinkedIn company page |
| `xLink` | Links | X/Twitter account |
| `annualRecurringRevenue` | Currency | ARR (amount + currency code) |
| `idealCustomerProfile` | Boolean | Is this company an ideal customer? |

**Key Relationships:**

| Relation | Target | Description |
|----------|--------|-------------|
| `people` | Person[] | Contacts at this company |
| `accountOwner` | WorkspaceMember | Team member managing this account |
| `opportunities` | Opportunity[] | Sales deals with this company |
| `noteTargets` | NoteTarget[] | Notes linked to company |
| `taskTargets` | TaskTarget[] | Tasks linked to company |

---

### 3. 💰 Opportunity

A sales opportunity/deal in the pipeline.

**Fields:**

| Field | Type | Description |
|-------|------|-------------|
| `name` | Text | Opportunity/deal name |
| `amount` | Currency | Deal value (amount + currency) |
| `closeDate` | DateTime | Expected close date |
| `stage` | Select | Pipeline stage |

**Stage Options:**
| Value | Label | Color |
|-------|-------|-------|
| `NEW` | New | Red |
| `SCREENING` | Screening | Purple |
| `MEETING` | Meeting | Sky |
| `PROPOSAL` | Proposal | Turquoise |
| `CUSTOMER` | Customer | Yellow |

**Key Relationships:**

| Relation | Target | Description |
|----------|--------|-------------|
| `pointOfContact` | Person | Primary contact for this deal |
| `company` | Company | Associated company |
| `noteTargets` | NoteTarget[] | Linked notes |
| `taskTargets` | TaskTarget[] | Linked tasks |

---

### 4. 📝 Note

A note that can be linked to multiple records (people, companies, opportunities).

**Fields:**

| Field | Type | Description |
|-------|------|-------------|
| `title` | Text | Note title |
| `body` | RichText | Note content (rich text with formatting) |

**Key Relationships:**

| Relation | Target | Description |
|----------|--------|-------------|
| `noteTargets` | NoteTarget[] | Links to related records |
| `attachments` | Attachment[] | Attached files |

---

### 5. ✅ Task

A task/to-do item that can be assigned and linked to records.

**Fields:**

| Field | Type | Description |
|-------|------|-------------|
| `title` | Text | Task title |
| `body` | RichText | Task description |
| `dueAt` | DateTime | Due date |
| `status` | Select | Task status |

**Status Options:**
| Value | Label | Color |
|-------|-------|-------|
| `TODO` | To Do | Sky |
| `IN_PROGRESS` | In Progress | Purple |
| `DONE` | Done | Green |

**Key Relationships:**

| Relation | Target | Description |
|----------|--------|-------------|
| `assignee` | WorkspaceMember | Who the task is assigned to |
| `taskTargets` | TaskTarget[] | Links to related records |
| `attachments` | Attachment[] | Attached files |

---

## Supporting Objects

### 📎 Attachment

Files attached to any record.

| Field | Type | Description |
|-------|------|-------------|
| `name` | Text | File name |
| `fullPath` | Text | Storage path |
| `fileCategory` | Select | ARCHIVE, AUDIO, IMAGE, PRESENTATION, SPREADSHEET, TEXT_DOCUMENT, VIDEO, OTHER |

### ⭐ Favorite

Bookmarked records for quick access in the sidebar.

### 📊 Timeline Activity

Aggregated activity history shown on record pages.

### 👥 Workspace Member

A user/team member in the workspace.

| Field | Type | Description |
|-------|------|-------------|
| `name` | FullName | Member's name |
| `email` | Text | Email address |
| `avatarUrl` | Text | Profile image |
| `colorScheme` | Text | UI theme preference |
| `locale` | Text | Language preference |
| `timeZone` | Text | Timezone setting |

---

## Communication Objects

### 📧 Message & MessageThread

Email messages synced from connected accounts (Gmail, Microsoft).

| Field | Type | Description |
|-------|------|-------------|
| `subject` | Text | Email subject |
| `text` | Text | Email body |
| `receivedAt` | DateTime | When received |

### 📅 Calendar Event

Calendar events synced from connected accounts.

| Field | Type | Description |
|-------|------|-------------|
| `title` | Text | Event title |
| `startsAt` / `endsAt` | DateTime | Event timing |
| `location` | Text | Event location |
| `description` | Text | Event details |
| `isFullDay` | Boolean | All-day event |
| `conferenceLink` | Links | Video call URL |

### 🔗 Connected Account

External account connections (Google, Microsoft, etc.) for email/calendar sync.

---

## Workflow & Automation Objects

### ⚡ Workflow

Automated workflows with triggers and actions.

| Field | Type | Description |
|-------|------|-------------|
| `name` | Text | Workflow name |
| `statuses` | MultiSelect | DRAFT, ACTIVE, DEACTIVATED |

### Workflow Version / Run

Versions of workflows and their execution history.

---

## Junction Tables (Polymorphic Links)

Twenty uses junction tables to link Notes and Tasks to multiple object types:

### NoteTarget
Links a Note to any of: Person, Company, Opportunity, or Custom Objects

### TaskTarget
Links a Task to any of: Person, Company, Opportunity, or Custom Objects

---

## Field Type Reference

| Type | Description | Example |
|------|-------------|---------|
| `TEXT` | Plain text string | "John Smith" |
| `FULL_NAME` | Composite: firstName + lastName | { firstName: "John", lastName: "Smith" } |
| `EMAILS` | Array of emails with primary flag | [{ email: "john@example.com", primary: true }] |
| `PHONES` | Array of phones with primary flag | [{ phone: "+1234567890", primary: true }] |
| `LINKS` | URL with label | { url: "https://...", label: "Website" } |
| `ADDRESS` | Full address composite | { street, city, state, postalCode, country, lat, lng } |
| `CURRENCY` | Amount + currency code | { amountMicros: 50000000000, currencyCode: "USD" } |
| `DATE_TIME` | Date and time | "2025-12-31T23:59:59Z" |
| `DATE` | Date only | "2025-12-31" |
| `BOOLEAN` | True/false | true |
| `NUMBER` | Integer or decimal | 42 |
| `SELECT` | Single option from list | "NEW" |
| `MULTI_SELECT` | Multiple options | ["DRAFT", "ACTIVE"] |
| `RICH_TEXT` | Formatted text content | (HTML/Markdown) |
| `POSITION` | Ordering number | 1.5 |

---

## Relationship Diagram

```
┌─────────────────┐       ┌─────────────────┐
│  WorkspaceMember │       │    Favorite     │
│  (Team Member)   │◄──────┤  (Bookmarks)    │
└────────┬────────┘       └─────────────────┘
         │ accountOwner            │
         │ assignee                │ links to any object
         ▼                         ▼
┌─────────────────┐       ┌─────────────────┐
│     Company     │◄──────┤   Opportunity   │
│  (Organization) │       │  (Sales Deal)   │
└────────┬────────┘       └────────┬────────┘
         │ company                 │ pointOfContact
         ▼                         ▼
┌─────────────────┐       ┌─────────────────┐
│     Person      │◄──────┤                 │
│    (Contact)    │       │                 │
└────────┬────────┘       └─────────────────┘
         │
         │ messageParticipants / calendarEventParticipants
         ▼
┌─────────────────┐       ┌─────────────────┐
│    Message      │       │  CalendarEvent  │
│  (Email Sync)   │       │ (Calendar Sync) │
└─────────────────┘       └─────────────────┘

         ┌─────────────────────────────────┐
         │      NoteTarget / TaskTarget    │
         │    (Polymorphic Junction)       │
         └─────────────────────────────────┘
                    │
         ┌──────────┼──────────┐
         ▼          ▼          ▼
┌────────────┐ ┌────────┐ ┌─────────────┐
│    Note    │ │  Task  │ │ Attachment  │
└────────────┘ └────────┘ └─────────────┘
```

---

## Key Concepts

1. **Soft Deletes**: Records aren't permanently deleted - they get a `deletedAt` timestamp
2. **Actors**: The `createdBy` field tracks who/what created a record (user, system, API)
3. **Position**: Used for drag-and-drop ordering in lists and kanban boards
4. **Full-Text Search**: Most objects have a `searchVector` for fast searching
5. **Custom Objects**: You can create entirely new object types via Settings → Data Model
6. **Custom Fields**: Any standard object can be extended with additional fields

---

## Mapping to Your Community Garden Project

### Conceptual Model: Garden as Product

In a traditional CRM, businesses sell **products** to customers. In your garden CRM:

| Business Concept | Your Project | Description |
|------------------|--------------|-------------|
| **Product/Service** | Garden Installation | The deliverable you provide to residents |
| **Product Catalog** | Plants | Available native plants for Ottawa climate |
| **Line Items** | Plant Usages | Which plants, how many, in each garden |

### Object Mapping

| Twenty Default | Your Project | Notes |
|----------------|--------------|-------|
| **Workspace Member** | Volunteers | Team members who log in, get assigned tasks, manage gardens |
| **Person** | Residents | Property owners/contacts (external people in the CRM) |
| **Company** | Properties | Physical garden locations (rename to "Properties") |
| **Opportunity** | Garden Projects | **THE PRODUCT** - the garden being delivered |
| **Task** | Planting/Maintenance Tasks | Assigned to Volunteers (Workspace Members) |
| **Note** | Notes | Works as-is |
| *Custom Object* | **Plants** | **CATALOG** - native plant database |
| *Custom Object* | **Plant Usages** | **LINE ITEMS** - plants used in each garden project |

### Relationship Mapping

```
                                    Your Garden CRM:
                                    ─────────────────
                                    Volunteer (Workspace Member)
                                           │ accountOwner / assignee
                                           ▼
Plants (Catalog)                    Property (Company) ◄─── Resident (Person)
       │                                  │                    (property owner)
       │                                  │
       │                                  ▼
       │                           Garden Project (Opportunity)
       │                           = THE PRODUCT/SERVICE
       │                                  │
       └───────► Plant Usages ◄─────────┘
                 (line items: 3x Coneflower, 5x Black-eyed Susan...)
```

### Example Garden Project

```
Garden Project: "123 Maple Street - Pollinator Garden"
├── Property: 123 Maple Street
├── Resident: Jane Smith
├── Volunteer: John (accountOwner)
├── Stage: In Progress
├── Plant Usages (line items):
│       ├── 5x Purple Coneflower
│       ├── 3x Black-eyed Susan
│       ├── 4x Milkweed
│       └── 2x Wild Bergamot
└── Tasks:
        ├── Site assessment (Done)
        ├── Soil preparation (Done)
        ├── Planting day (In Progress)
        └── Follow-up watering (To Do)
```

### Why This Mapping Works

1. **Workspace Member → Volunteers** ✅
   - Volunteers can log into the CRM
   - Directly assignable to Tasks
   - Shows in assignment dropdowns
   - Can be set as "accountOwner" on Properties

2. **Person → Residents** ✅
   - Natural fit for external contacts/people
   - Already has: name, email, phone, address fields
   - Links to their Property (Company)

3. **Company → Properties** ✅
   - Rename "Company" to "Property" in the UI
   - Already has: name, address (with lat/lng!), accountOwner
   - `accountOwner` = assigned Volunteer
   - `people` relationship = Residents who own/live there

4. **Opportunity → Garden Project (THE PRODUCT)** ✅
   - The garden installation is what you "deliver"
   - Track lifecycle: Planning → Planting → Established
   - Links to Property, has assigned Volunteer

5. **Custom Object: Plants (CATALOG)** ✅
   - Native plant database for Ottawa
   - Sunlight/water requirements, maintenance level, bloom season
   - Reference data - doesn't change per project

6. **Custom Object: Plant Usages (LINE ITEMS)** ✅
   - Junction table: links Plants to Garden Projects
   - Tracks quantity, location in garden, planting date
   - Like order line items in a sales system

---

*This document describes Twenty CRM v0.33+. The data model may evolve in future versions.*
