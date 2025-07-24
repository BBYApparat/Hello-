# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the **Wraith ARS 2X** - a FiveM resource that provides a realistic police radar and plate reader system for GTA V servers. It's based on the real Stalker DSR 2X radar system and includes features like dual antenna speed tracking, automatic plate reading, and BOLO alerts.

## Project Structure

This is a FiveM Lua resource with the following architecture:

### Core Components
- **Client Scripts**: Handle player interaction, radar functionality, and UI communication
  - `cl_player.lua` - Player state management and vehicle validation
  - `cl_radar.lua` - Main radar logic and speed detection
  - `cl_plate_reader.lua` - License plate scanning functionality
  - `cl_sync.lua` - Client-server synchronization
  - `cl_utils.lua` - Utility functions and helpers

- **Server Scripts**: Handle data synchronization and exports
  - `sv_sync.lua` - Server-side synchronization logic
  - `sv_exports.lua` - Server exports for other resources
  - `sv_version_check.lua` - Automatic version checking

- **NUI Interface**: Web-based UI using HTML/CSS/JavaScript
  - `nui/radar.html` - Main radar display interface
  - `nui/radar.css` - Styling for the radar interface
  - `nui/radar.js` - JavaScript logic for UI interactions
  - `nui/images/` - Radar graphics and plate images
  - `nui/sounds/` - Audio files for radar alerts

### Configuration
- `config.lua` - Main configuration file with all customizable settings
- `fxmanifest.lua` - FiveM resource manifest defining dependencies and file loading order

## Development Commands

This is a FiveM resource, so development involves:

1. **Installation**: Place the resource folder in your FiveM server's resources directory
2. **Server Configuration**: Add `ensure wk_wars2x` to your server.cfg
3. **Testing**: Restart your FiveM server to load changes

No build process is required as Lua scripts are interpreted at runtime.

## Key Configuration Areas

- **Keybinds**: Default keys can be modified in `config.lua` under `CONFIG.keyDefaults`
- **Radar Settings**: Sensitivity, volume, and behavior options in `CONFIG.menuDefaults`
- **UI Scaling**: Display scale and safezone settings in `CONFIG.uiDefaults`
- **Feature Toggles**: Enable/disable passenger access, fast limit locking, etc.

## Integration Points

- **Sonoran CAD**: Set `CONFIG.use_sonorancad = true` for integration
- **Server Exports**: `TogglePlateLock()` function available for other resources
- **Player Validation**: Only works in emergency vehicles (class VC_EMERGENCY)

## Important Notes

- This resource requires players to be in the driver or passenger seat of an emergency vehicle
- The radar uses realistic detection algorithms based on vehicle size, speed, and distance
- Plate reader can be configured with BOLO alerts and custom integrations
- All audio and visual feedback is configurable through the operator menu