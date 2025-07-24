# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PS Dispatch is a FiveM resource for GTA5 that provides police/EMS dispatch notifications and management. It's a Lua-based resource with a Svelte/TypeScript frontend UI component integrated with the QB-Core framework.

## Dependencies

- [qb-core](https://github.com/qbcore-framework/qb-core) - Main framework
- [ox_lib](https://github.com/overextended/ox_lib) - Required utility library  
- [ps-mdt](https://github.com/Project-Sloth/ps-mdt) - Optional but recommended integration
- ESX framework support with full compatibility fixes applied

## Development Commands

### UI Development (in ui/ directory)
- `npm run dev` - Start Vite development server on localhost:5173
- `npm run build` - Build production UI files to ../html/
- `npm run preview` - Preview built files
- `npm run check` - Run Svelte type checking

For development, uncomment line 11 in fxmanifest.lua to use localhost:5173 instead of built files.

### FiveM Resource
- Copy sounds folder to `interact-sound/client/html/sounds/` 
- Set language in server.cfg with `setr ox:locale en`
- Add resource to server.cfg

### Key Bindings
- **Backtick (`)** - Opens dispatch menu (Config.OpenDispatchMenu)
- **E** - Set waypoint to latest dispatch call (Config.RespondKeybind)
- **Y** - Alternative GPS waypoint key for latest dispatch call

### Commands
- `/dispatch` - Open dispatch menu
- `/cdp` - Clear all dispatch calls (LEO/Admin only)
- `/911 [message]` - Send emergency call to police
- `/911a [message]` - Send anonymous emergency call
- `/311 [message]` - Send non-emergency call
- `/311a [message]` - Send anonymous non-emergency call

## Architecture

### Core Structure
- **client/** - Client-side Lua scripts for FiveM
  - `main.lua` - Core client functionality, zones, UI toggling
  - `alerts.lua` - Alert definitions and dispatch data structure
  - `eventhandlers.lua` - Event handling
  - `utils.lua` - Utility functions
- **server/** - Server-side Lua scripts  
  - `main.lua` - Call management, server events, data persistence
- **shared/** - Shared configuration
  - `config.lua` - Main configuration file with alert types, blips, colors
- **ui/** - Svelte/TypeScript frontend
  - Built files output to `html/` directory via Vite
- **locales/** - Translation files (JSON format)

### Key Concepts

**Dispatch Data Structure** (see client/alerts.lua:1-41):
- Each alert contains: message, codeName, code, icon, priority, coords, vehicle data, alert config, jobs
- Priority 1 = red alerts, Priority 2 = normal color
- Alert config includes blip settings (radius, sprite, color, scale, length, sound, offset, flash)

**Call Management** (server/main.lua):
- Calls stored as array with max limit from Config.MaxCallList
- Each call gets unique ID, timestamp, units array, responses array
- Server events: notify, attach, detach for call lifecycle

**UI Integration**:
- Svelte app with TypeScript in ui/src/
- Built files must be in html/ directory for FiveM NUI
- Uses Tailwind CSS and DaisyUI for styling
- Store-based state management in src/store/

### Configuration System

**shared/config.lua** contains:
- ShortCalls mode toggle
- Job permissions (Config.Jobs) - includes ESX job names
- ESX duty system configuration (Config.JobsWithDuty)
- Default alerts settings
- Hunting/NoDispatch zones
- Weapon whitelist
- Blip configurations for each alert type
- Vehicle color mappings
- Keybind settings (backtick for menu, E/Y for waypoints)

### Alert System

**Adding New Alerts**:
1. Add function to client/alerts.lua following CustomAlert pattern
2. Add corresponding blip config in shared/config.lua under Config.Blips
3. Add locale entries for the alert message
4. Export the function: `exports('AlertName', AlertName)`

**Pre-built Alert Exports** (see README.md:54-90):
- 30+ predefined alerts for robberies, officer situations, vehicle crimes
- All follow same dispatch data structure
- Include vehicle data when applicable

### Zone System

**client/main.lua** handles:
- Hunting zones with optional blips
- No-dispatch zones (areas where alerts are suppressed)
- Uses PolyZone for zone detection
- Creates/removes zones dynamically

## Development Notes

- UI builds to html/ directory, not ui/dist/
- For UI development, use localhost:5173 mode in fxmanifest.lua
- Alert sounds must be in interact-sound resource
- Debug mode available in Config.Debug for testing
- Language support via ox_lib locale system
- Vehicle data extraction handled by utility functions

## ESX Compatibility Fixes Applied

**Critical Issues Fixed:**
1. **cache.ped/cache.vehicle Usage**: Replaced QB-Core specific cache system with ESX-compatible PlayerPedId() and vehicle detection functions
2. **Player Identification**: Fixed citizenid vs identifier compatibility for both QB-Core and ESX
3. **Job Detection**: Enhanced job validation to work with ESX job structure
4. **Server Callbacks**: Added ESX.RegisterServerCallback for item checking
5. **Duty System**: Implemented proper ESX duty system support with Config.JobsWithDuty

**Features Added:**
- `cdp` command to clear all dispatch calls (admin/LEO restricted)
- Backtick (`) key to open dispatch menu
- Y key for GPS waypoint functionality
- Enhanced ESX player data structure handling
- Proper ESX job types in Config.Jobs (police, sheriff, ambulance, fire, leo, ems)

**Files Modified:**
- client/main.lua: Fixed PlayerData structure, keybinds, job validation
- client/alerts.lua: Replaced all cache.ped with PlayerPedId()
- client/eventhandlers.lua: Fixed cache references for ESX compatibility
- server/main.lua: Added ESX callbacks, cdp command, identifier compatibility
- shared/config.lua: Updated keybinds, added ESX job configuration

**ESX Job Configuration:**
```lua
Config.Jobs = {"leo", "ems", "police", "sheriff", "ambulance", "fire"}
Config.JobsWithDuty = {
    ['police'] = true,
    ['sheriff'] = true, 
    ['ambulance'] = true,
    ['fire'] = true,
    ['leo'] = true,
    ['ems'] = true
}
```