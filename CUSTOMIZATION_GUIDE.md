# Twenty CRM Customization Guide for Gardening Project

## Quick Start Checklist

After running the setup script and accessing Twenty at http://localhost:3001:

### 1. Initial Login & Workspace Setup
- [ ] Login with `tim@apple.dev` / `tim@apple.dev`
- [ ] Go to Settings → Workspace → General
- [ ] Change workspace name to "Community Gardening Project" / "Projet de jardinage communautaire"
- [ ] Set default language (English or French)
- [ ] Update logo and branding if desired

### 1.1. Language Configuration
- [ ] Go to Settings → Profile → Appearance → Language
- [ ] Select "Français (French)" or keep "English" 
- [ ] Interface will update immediately
- [ ] All field labels and UI text will display in chosen language

### 2. Create Custom Objects

#### A. Extend People for Homeowners
1. Go to Settings → Objects → People
2. Add custom fields:
   - `Property Address` (Text)
   - `Property Size (sq ft)` (Number)
   - `Current Grass Type` (Select: Kentucky Bluegrass, Tall Fescue, Bermuda, etc.)
   - `Sun Conditions` (Select: Full Sun, Partial Sun, Shade, Mixed)
   - `Soil Type` (Select: Clay, Loam, Sandy, Clay-Loam, Sandy-Loam)
   - `Budget Range` (Select: $200-500, $500-1000, $1000-2000, $2000+)
   - `Timeline Preference` (Select: Spring 2025, Summer 2025, Fall 2025, Flexible)
   - `Project Status` (Select: Requested, Evaluated, Approved, In Progress, Complete)

#### B. Create Volunteers Object
1. Settings → Objects → Create New Object
2. Name: "Volunteers"
3. Add fields:
   - `Name` (Text) - Required
   - `Email` (Email) - Required
   - `Phone` (Phone)
   - `Role` (Select: Evaluator, Worker, Both)
   - `Expertise Level` (Select: Beginner, Intermediate, Advanced, Expert)
   - `Availability` (Text)
   - `Service Area` (Select: North, South, Central, East, West Springfield)
   - `Skills` (Multi-select: Master Gardener, Plant ID, Soil Testing, Landscaping, etc.)
   - `Volunteer Since` (Date)
   - `Hours Logged` (Number)
   - `Transportation` (Select: Own Vehicle, Bicycle, Public Transit)

#### C. Create Service Requests Object
1. Settings → Objects → Create New Object
2. Name: "Service Requests"
3. Add fields:
   - `Homeowner` (Relation to People)
   - `Request Date` (Date)
   - `Property Address` (Text)
   - `Assessment Status` (Select: Pending, Scheduled, Complete)
   - `Assigned Evaluator` (Relation to Volunteers)
   - `Evaluation Notes` (Long Text)
   - `Recommended Plants` (Long Text)
   - `Estimated Hours` (Number)
   - `Priority Level` (Select: Low, Medium, High, Urgent)
   - `Project Status` (Select: Requested, Evaluated, Approved, In Progress, Complete)
   - `Assigned Workers` (Multi-relation to Volunteers)
   - `Completion Date` (Date)

#### D. Create Native Plants Object
1. Settings → Objects → Create New Object
2. Name: "Native Plants"
3. Add fields:
   - `Common Name` (Text) - Required
   - `Scientific Name` (Text)
   - `Plant Type` (Select: Perennial, Annual, Shrub, Tree, Grass)
   - `Sun Requirements` (Select: Full Sun, Partial Sun, Shade, Flexible)
   - `Water Needs` (Select: Low, Medium, High)
   - `Soil Type` (Multi-select: Clay, Loam, Sandy, Well-drained, Moist)
   - `Bloom Time` (Text)
   - `Mature Height` (Text)
   - `Native Region` (Text)
   - `Care Level` (Select: Easy, Moderate, Difficult)
   - `Wildlife Value` (Select: Low, Medium, High, Very High)
   - `Special Features` (Multi-select: Drought Tolerant, Pollinator Friendly, Edible, etc.)

### 3. Configure Views

#### Homeowner Pipeline (Kanban)
1. Go to Service Requests object
2. Create new view: "Pipeline"
3. Set as Kanban view
4. Group by: Project Status
5. Columns: Requested → Evaluated → Approved → In Progress → Complete

#### Volunteer Schedule (Calendar)
1. Create new view in Service Requests
2. Set as Calendar view
3. Date field: Completion Date or custom Schedule Date

#### Geographic View (Table)
1. Create new view in Service Requests
2. Filter by Service Area
3. Add map integration if available

### 4. Import Sample Data

Use the CSV files in `gardening-project-data/` (available in both English and French):

**English Files:**
1. **Import Homeowners**: 
   - Go to People object
   - Use CSV import feature
   - Map fields from `sample_homeowners.csv`

2. **Import Volunteers**:
   - Go to Volunteers object
   - Import from `sample_volunteers.csv`

3. **Import Plants Database**:
   - Go to Native Plants object
   - Import from `native_plants_database.csv`

**French Files (Fichiers français):**
1. **Import Homeowners**: 
   - Use `proprietaires_echantillon.csv`
   - Field mappings will be in French

2. **Import Volunteers**:
   - Use `benevoles_echantillon.csv`
   - French field names and values

3. **Import Plants Database**:
   - Use `base_donnees_plantes_indigenes.csv`
   - French plant names and descriptions

### 5. Set Up Automation Workflows

#### New Request Workflow
1. Settings → Workflows → Create New
2. Trigger: When Service Request is created
3. Actions:
   - Send email notification to admin
   - Auto-assign to evaluator based on geographic area
   - Set initial status to "Requested"

#### Evaluation Complete Workflow
1. Trigger: When Assessment Status changes to "Complete"
2. Actions:
   - Send notification to homeowner
   - Update Project Status to "Evaluated"
   - Create task for worker assignment

### 6. Configure User Roles & Permissions

#### Admin Role
- Full access to all objects and settings
- Can manage volunteers and assign work
- Access to reporting and analytics

#### Evaluator Role
- Can view and edit Service Requests
- Can access Native Plants database
- Can update evaluation status and notes

#### Worker Role
- Can view assigned Service Requests
- Can update work progress and completion
- Can access basic plant information

#### Homeowner Role (if giving access)
- Can view their own Service Request status
- Read-only access to their project details

### 7. Customize Dashboard

Create widgets for:
- Recent service requests
- Volunteer availability calendar
- Completion metrics
- Seasonal project planning
- Popular plant recommendations

### 8. Mobile Optimization

- Test interface on mobile devices
- Ensure volunteers can easily update status in the field
- Consider offline capabilities for remote locations

### 9. Reporting Setup

Create reports for:
- Volunteer hours tracking
- Project completion rates
- Popular plant choices
- Geographic coverage analysis
- Seasonal workload planning

### 10. Training Materials

Create guides for:
- Homeowners: How to submit requests
- Evaluators: Assessment procedures
- Workers: Using mobile interface
- Admins: Managing the system

## Advanced Customizations

### Custom Fields Examples

**For Homeowners:**
- `HOA Approval Required` (Checkbox)
- `Pet Considerations` (Text)
- `Accessibility Needs` (Text)
- `Previous Landscaping Experience` (Select)

**For Service Requests:**
- `Weather Dependencies` (Multi-select)
- `Material Costs` (Currency)
- `Photos` (File uploads)
- `Before/After Images` (File uploads)

**For Plants:**
- `Seed Sources` (Text)
- `Planting Instructions` (Long Text)
- `Companion Plants` (Multi-relation to other plants)
- `Seasonal Care Notes` (Long Text)

### Integration Possibilities

- **Weather API**: Auto-scheduling based on conditions
- **Google Maps**: Route optimization for volunteers
- **Calendar**: Sync with volunteers' personal calendars
- **Email**: Automated status updates
- **SMS**: Quick notifications for urgent requests

### Scaling Considerations

- Start with one neighborhood/zip code
- Add more service areas as volunteer base grows
- Consider seasonal volunteer recruitment drives
- Plan for winter/indoor activities to maintain engagement
- Track success metrics to demonstrate community impact

This customization approach will create a comprehensive CRM system tailored specifically for managing your volunteer gardening community project!
