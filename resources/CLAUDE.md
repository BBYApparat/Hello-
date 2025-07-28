# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a comprehensive FiveM server resource collection for GTA V roleplay servers. The repository contains a full ecosystem of ESX-based resources including framework components, job systems, police/EMS tools, inventory systems, and custom plugins.

## Framework Architecture

### Core Framework
- **Primary Framework**: ESX Legacy with ox_lib integration
- **Database**: MySQL via oxmysql
- **Inventory System**: ox_inventory (slot-based with metadata support)
- **Resource Structure**: Organized into categorized folders ([esx], [plugins], [bby], [paid])

### Key Dependencies
- `oxmysql` - Database connector (MySQL)
- `ox_lib` - Core utility library used across 36+ resources
- `es_extended` - ESX Legacy framework
- `ox_inventory` - Advanced inventory system
- `ox_target` - Interaction system

## Development Commands

### Frontend Resources (React/TypeScript)
For resources with web UIs (like bub-mdt):
```bash
cd [resource]/web/
npm install     # or pnpm install (bub-mdt uses pnpm)
npm run dev     # Development server
npm run build   # Production build (outputs to web/build/)
```

### Frontend Resources (Vue.js)
For Vue-based resources (like al_mdt):
```bash
cd [resource]/ui/
npm install
npm run serve   # Development server
npm run build   # Production build
```

### Frontend Resources (Svelte/TypeScript)
For dispatch systems (like ps-dispatch):
```bash
cd [resource]/ui/
npm install
npm run dev     # Development server on localhost:5173
npm run build   # Builds to ../html/
```

### FiveM Resource Development
1. Place resources in appropriate categorized folders
2. Add to server.cfg with `ensure [resource-name]`
3. Restart FiveM server to reload changes
4. Use `refresh` and `start [resource]` for development

## Folder Structure & Categories

### [esx] - Core ESX Framework Components
- `es_extended` - Main ESX framework
- `esx_*` - Standard ESX resources (identity, billing, society, etc.)
- `ox_*` - Overextended ecosystem resources
- Framework essentials and standard ESX modules

### [plugins] - Utility & Enhancement Plugins
- `bub-mdt` - Police MDT system (React + TypeScript)
- `wk_wars2x` - Police radar system with plate reader
- `ox_inventory` - Advanced inventory system
- `illenium-appearance` - Character appearance system
- Various utility plugins and enhancements

### [bby] - Custom Server Resources
- `ps-dispatch` - Police/EMS dispatch system (Svelte + TypeScript) - Compatible with QBCore, includes preset alert exports
- `al_mdt` - Alternative MDT system (Vue.js 3 + Bootstrap 5)
- `ars_policejob` - Enhanced police job system with ESX integration
- `bby_heists`, `bby_motels`, `bby_rental` - Custom job and activity systems
- Various server-specific resources for farming, territories, and roleplay activities

### [paid] - Premium/Commercial Resources
- `rep-weed` - Advanced weed growing system
- `snipe-menu` - Admin menu system
- `ts-vehicleshop` - Vehicle dealership system
- `lb-phone` - Advanced smartphone system
- Premium features and commercial resources

### [assets] - Game Assets & Props
- Custom MLOs and housing assets (Interior_housing_lusino3)
- Food & restaurant props (bzzz_pizzapack, bzzz_icecream, bzzz_kebab)
- Digital displays and vending machines (bzzz_digital_bells, bzzz_vending)
- Custom character skins and peds (cj, envi-shells)
- Asset packages provide .ydr, .ytyp, and .ytd files for game integration

## Key System Configurations

### ESX Configuration
- Framework locale: `Config.Locale = GetConvar("esx:locale", "en")`
- ox_inventory integration: Auto-detected via resource state
- Starting money: Bank = 50,000
- Max inventory weight: 24 (without backpack)

### Job System
- Police jobs: `police`, `sheriff`, `leo`
- EMS jobs: `ambulance`, `fire`, `ems`
- Duty system integrated across multiple resources
- Job permissions configured per resource

### Database Schema
- Core ESX tables: `users`, `jobs`, `owned_vehicles`, `properties`
- Extended tables: Various resource-specific tables
- MySQL integration via oxmysql

## Architecture Patterns

### Resource Manifest Structure
Standard FiveM fxmanifest.lua structure:
- `fx_version 'cerulean'` and `lua54 'yes'` for modern Lua
- Dependency declarations (oxmysql, ox_lib common)
- Client/server script organization
- UI page definitions for NUI resources

### UI Development Patterns
- **React + TypeScript**: Modern React with Vite, Zustand state management, Mantine UI (bub-mdt)
- **Svelte + TypeScript**: Svelte with Tailwind CSS (ps-dispatch)
- **Vue.js 3**: Component-based architecture with Vuex, Bootstrap 5, SCSS (al_mdt)
- Build outputs typically go to `html/` or `web/build/` directories
- Package managers: npm (standard), pnpm (bub-mdt)

### Framework Integration
- ESX Legacy as primary framework
- ox_lib for utilities and UI components
- oxmysql for database operations
- Consistent export patterns across resources

## Development Guidelines

### Resource Development
- Use ox_lib for UI components and utilities when available
- Follow ESX patterns for player data and job management
- Implement proper client-server communication via exports/events
- Use oxmysql for all database operations

### UI Development
- Frontend builds must output to correct directories for FiveM NUI
- Use localhost development mode during UI development
- Ensure TypeScript compliance where applicable
- Follow established build patterns per framework

### Database Integration
- All database operations via oxmysql
- Consistent table naming with resource prefixes
- Proper foreign key relationships with ESX core tables
- Migration scripts in sql/ directories where applicable

## Common Integration Points

### Police/LEO Systems
- **Multiple MDT systems**:
  - `bub-mdt` - Production-ready React MDT with vehicles, BOLOs, businesses, properties
  - `al_mdt` - Vue.js alternative MDT system
- **Dispatch systems**:
  - `ps-dispatch` - QBCore-compatible dispatch with preset alert exports
- **Radar & Plate Reader**:
  - `wk_wars2x` - Realistic police radar system (inspired by Stalker DSR 2X)
  - Front/rear antenna tracking, plate reader, BOLO integration
  - Default keybinds: F5 (remote), Numpad 8/5 (lock), Numpad 9/6 (plates)
- **Job management**: `ars_policejob` - Enhanced police job system

### Inventory & Items
- **ox_inventory** as primary inventory system with extensive item library
- **Comprehensive item catalog** in `[ox]/images/` with 500+ item images
- Categories include:
  - Weapons and attachments (WEAPON_*, at_*)
  - Drugs and consumables (cocaine, weed, morphine, etc.)
  - Food and drinks (pizza varieties, burgers, coffee, alcohol)
  - Vehicle parts and repair items (engine, brake, suspension components)
  - Medical supplies (bandage, medikit, defib, etc.)
  - Electronics and tools (laptop, phone, hacking devices)
  - Jewelry and valuables (diamonds, gold, watches)
- Metadata support for complex items and durability
- Integration with crafting, job systems, and businesses

### Vehicle Systems
- Vehicle shops and rentals
- Custom vehicle modifications
- Plate reader systems
- Garage and impound integration

## Resource Loading Order

Critical loading sequence for dependencies:
1. Core framework (es_extended, oxmysql, ox_lib)
2. ESX base resources (identity, society, etc.)
3. Inventory system (ox_inventory)
4. Job systems and enhancements
5. Custom resources and plugins

## Testing & Debugging

### FiveM Server Debugging
- Use FiveM server console for error monitoring
- Client-side debugging via F8 console in-game
- Resource-specific debug modes in config files
- Database query monitoring via oxmysql logs

### Frontend Development Debugging
- **React (bub-mdt)**: Use browser dev tools with React dev tools extension
- **Vue.js (al_mdt)**: Use Vue dev tools browser extension for debugging
- **Svelte (ps-dispatch)**: Browser dev tools with Svelte dev tools

### Common Commands
```bash
# FiveM server console
refresh           # Refresh resource list
restart [resource] # Restart specific resource
ensure [resource]  # Start resource

# Development workflow
npm run dev       # Start frontend dev server (watch mode)
npm run build     # Build for production
```

## Key Configuration Notes

### ESX Framework Settings
- Locale: Set via `setr esx:locale en` in server.cfg
- ox_inventory integration: Auto-detected via resource state
- Starting money: Bank = 50,000 (configurable in es_extended/config.lua)
- Custom account: `cosmo` currency added to framework

### Job Permissions
- Police jobs: `police`, `sheriff`, `trooper` (bub-mdt)
- LEO job types configured in qbcore/shared/jobs.lua for QBCore resources