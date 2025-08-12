# Police MDT System - GTA IV Style

A comprehensive Mobile Data Terminal (MDT) system for police officers in emergency vehicles, inspired by GTA IV's police computer system.

## Features

### 🚔 Vehicle Requirements
- Must be in an emergency vehicle (configurable)
- Vehicle must be stationary (< 2 MPH by default)
- Must be the driver
- Only police officers can access

### 📋 Main Menu Options
1. **🔍 Search Citizen** - Search for citizens by name and manage their profiles
2. **⚠️ View Current Crimes** - See active crimes reported in the city
3. **📋 Search Police Records** - Search complete police records for any citizen
4. **🚨 Call Backup** - Request backup with location and reason

### 👤 Citizen Management
- **Dual Search Methods**: Search by name or State ID number
- **Complete Citizen Profiles**: View name, State ID, DOB, sex, height  
- **State ID Integration**: Full integration with ESX state_id system
- Add notes to citizen profiles
- Add violations to citizen records
- View complete history of notes and violations

### 📊 Records System
- Comprehensive police records tracking
- All violations are automatically added to records
- **Dual Search**: Search records by citizen name or State ID
- View complete interaction history
- State ID-based record lookup

### 🚨 Backup System
- Call backup with current location
- Automatic location detection (street + area)
- Notifications sent to all online police officers
- Both notification popup and chat message

## Installation

1. **Database Setup**
   - Import `police_mdt.sql` into your database
   - Tables will also be auto-created on first run

2. **Configuration**
   - Edit `config_mdt.lua` to customize settings
   - Configure police job names, keybinds, and messages

3. **Usage**
   - Press `F5` (configurable) while in an emergency vehicle to open MDT
   - Ensure vehicle is stationary and you're the driver

## Database Tables

- `police_mdt_notes` - Officer notes on citizens
- `police_mdt_violations` - Violations assigned to citizens  
- `police_mdt_crimes` - Current active crimes
- `police_mdt_records` - Comprehensive police records

## Configuration Options

### Police Jobs
```lua
Config.PoliceMDT.PoliceJobs = {
    'police',
    'sheriff', 
    'leo'
}
```

### Vehicle Settings
```lua
Config.PoliceMDT.MaxSpeed = 2.0 -- Max speed to access MDT
Config.PoliceMDT.EmergencyVehiclesOnly = true
```

### Keybind
```lua
Config.PoliceMDT.OpenKey = 'F5'
```

## Commands

- `/mdt` - Open MDT (alternative to keybind)

## Integration with Other Scripts

### State ID System Integration
The MDT system is fully integrated with your existing ESX state_id system:
- Uses existing `state_id_counter` table for ID generation
- Reads `state_id` column from `users` table
- Compatible with ESX state ID exports
- Officers can search citizens by their State ID numbers

### Adding Crimes Programmatically
```lua
-- From any server-side script
exports['esx-smallresources']:AddCrime('Vehicle Theft', 'Legion Square', 'Red sedan stolen', 'Citizen Report')
```

### State ID Exports Usage
```lua
-- Get State ID by player identifier
local stateId = exports.es_extended:getPlayerStateId(identifier)

-- Get State ID by player source
local stateId = exports.es_extended:getPlayerStateIdBySource(source)
```

### Integration Examples
- Dispatch systems can add crimes to the MDT
- Court systems can add violations
- Arrest scripts can create records
- State ID system works with identity/character creation scripts

## Future Features (Planned)

- **Most Wanted List** - Track wanted individuals
- **Vehicle Database** - Search vehicle records and registrations
- **Evidence Management** - Track evidence for cases
- **Case Management** - Link related crimes and incidents
- **Photo Attachments** - Add photos to citizen profiles
- **Advanced Search** - Filter by date, officer, crime type
- **Statistics Dashboard** - Crime trends and officer activity

## Troubleshooting

### MDT Won't Open
- Ensure you're a police officer (job name in config)
- Must be in emergency vehicle (class 18)
- Vehicle must be stationary (< 2 MPH)
- Must be the driver

### Database Issues
- Check that MySQL/oxmysql is working
- Verify database tables were created
- Check server console for errors

### No Citizens Found
- Ensure ESX users table has proper firstname/lastname data
- Check that search includes partial matches

## Support

This system integrates with:
- ESX Framework
- oxmysql
- ox_lib (for UI components)

Compatible with ESX Legacy and modern ESX versions.

## Credits

Inspired by GTA IV's police computer system with modern FiveM enhancements.