# ESX Mobile Data Terminal (MDT)

**Converted from Mythic Framework to ESX**

A comprehensive Mobile Data Terminal system for law enforcement, EMS, and government personnel with full database integration and modern UI.

## Features

✅ **Full MDT Interface** - Complete police computer system  
✅ **Callsign Management** - Assign and manage officer callsigns  
✅ **Report System** - Create, edit, and search incident reports  
✅ **People Search** - Search civilians and suspects  
✅ **Vehicle Search** - Search and flag vehicles  
✅ **Evidence Management** - Track and manage evidence  
✅ **Warrant System** - Issue and manage warrants  
✅ **Permission System** - Grade-based access control  
✅ **MySQL Database** - Full database integration  

## Installation

### 1. Copy Resource
```bash
# Place the esx_mdt folder in your [esx] resources directory
F:\SecondLife\GTASecondLife\ak47base\resources\[esx]\esx_mdt\
```

### 2. Add to server.cfg
```cfg
ensure esx_mdt
```

### 3. Database Setup
The resource will automatically create all necessary database tables on first run:
- `mdt_callsigns` - Officer callsigns
- `mdt_reports` - Incident reports  
- `mdt_people` - Person records
- `mdt_warrants` - Active warrants
- `mdt_evidence` - Evidence tracking
- `mdt_vehicles` - Vehicle flags/notes

### 4. Job Configuration
Edit `shared/shared.lua` to configure which jobs can access MDT:

```lua
Config.AllowedJobs = {
    'police',
    'ambulance', 
    'government'
}
```

## Commands

### Player Commands
```
/mdt                           # Open MDT (F5 keybind)
/tablet                        # Open business tablet
/setcallsign [id] [callsign]   # Assign callsign
/reclaimcallsign [callsign]    # Remove callsign
/clearblips                    # Clear emergency blips
```

### Admin Commands  
```
/addmdtsysadmin [id]          # Grant MDT system admin
/removemdtsysadmin [id]       # Remove MDT system admin
```

## Permissions

Permissions are automatically assigned based on job and grade:

### Police Ranks
- **Grade 0-1** (Cadet/Officer): Basic MDT access, create/view reports
- **Grade 5+** (Sergeant+): Edit reports, manage callsigns, hire/fire
- **Grade 10+** (Command): Full access, delete reports, system admin

### EMS Ranks
- **Grade 0-4**: Basic MDT access, medical reports
- **Grade 5+**: Manage callsigns, edit reports

## Configuration

### Job Permissions
Edit `shared/shared.lua` to modify permissions by job grade:

```lua
Config.Permissions = {
    police = {
        [0] = { -- Cadet
            mdt_access = true,
            view_reports = true,
            create_reports = true,
        },
        [5] = { -- Sergeant
            mdt_access = true,
            view_reports = true,
            create_reports = true,
            edit_reports = true,
            manage_callsigns = true,
        }
    }
}
```

### Department Setup
Configure police departments in `shared/shared.lua`:

```lua
Config.PoliceDepartments = {
    {
        id = 'lspd',
        name = 'Los Santos Police Department',
        shortName = 'LSPD'
    }
}
```

## Usage

### Opening MDT
- Press **F5** or use `/mdt` command
- Only available to police, EMS, and government jobs
- Permissions based on job grade

### Callsign Management
```bash
# Assign callsign to player ID 1
/setcallsign 1 Adam-12

# Remove callsign from system  
/reclaimcallsign Adam-12
```

### Creating Reports
1. Open MDT with F5
2. Go to "Create Report" 
3. Fill out incident details
4. Add suspects, evidence, location
5. Submit report

### Searching
- **People**: Search by first/last name
- **Vehicles**: Search by plate or model
- **Reports**: Filter by type, status, content

## API/Exports

### Client Exports
```lua
-- Check if MDT is open
local isOpen = exports['esx_mdt']:IsOpen()

-- Force close MDT
exports['esx_mdt']:CloseMDT()

-- Force open MDT  
exports['esx_mdt']:OpenMDT(playerData)
```

### Server Exports
```lua
-- Check MDT access
local hasAccess = exports['esx_mdt']:HasMDTAccess(xPlayer)

-- Check specific permission
local canEdit = exports['esx_mdt']:HasPermission(xPlayer, 'edit_reports')

-- Get ESX player object
local xPlayer = exports['esx_mdt']:GetESXPlayer(source)
```

## Troubleshooting

### Common Issues

**1. "You do not have access to MDT"**
- Check if your job is in `Config.AllowedJobs`
- Verify job grade has MDT permissions

**2. Commands not working**
- Ensure resource is started: `ensure esx_mdt`
- Check server console for errors
- Verify ESX is loaded before esx_mdt

**3. Database errors**
- Check MySQL connection
- Ensure oxmysql resource is running
- Check server logs for SQL errors

**4. UI not loading**
- Check `ui/dist/` folder exists with files
- Verify fxmanifest.lua includes UI files
- Check browser console (F12) for JavaScript errors

### Support

For issues or questions:
1. Check server console for error messages
2. Verify all dependencies are installed
3. Check database tables were created properly
4. Ensure proper job configuration

## Credits

- **Original Mythic Framework MDT** by Dr Nick & AuthenticRP team
- **ESX Conversion** by Claude Code Assistant
- **UI Components** - React-based interface maintained from original

## License

This resource is provided as-is for educational and server development purposes.