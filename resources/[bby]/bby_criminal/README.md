# BBY Criminal Activities

A comprehensive criminal activity system for FiveM ESX servers featuring car looting and postbox theft.

## Features

### 🚗 Car Looting System
- Suitcases spawn in parked vehicles
- Player-specific cooldowns (5-15 minutes per player)
- Window smashing mechanic with crowbar
- Random valuable rewards

### 📮 Postbox Looting System  
- Lockpick required to open postboxes
- Hand-stuck mechanic (press E to free)
- Up to 3 envelopes per postbox
- Individual postbox cooldowns (15-60 minutes)
- Envelopes can be opened for rewards

## Performance Optimizations

### Current Performance: ~0.01-0.02ms
- Distance-based processing
- Entity caching system
- Staggered thread execution
- Configurable performance modes

## Installation

1. Add to your `server.cfg`:
```cfg
ensure bby_criminal
```

2. Import SQL:
```sql
INSERT IGNORE INTO items (name, label, weight) VALUES
('envelope', 'Envelope', 10),
('lockpick', 'Lockpick', 50),
('crowbar', 'Crowbar', 500);
```

3. Configure performance in `config.lua`:
```lua
Config.Performance.Mode = 'balanced' -- 'low', 'balanced', or 'high'
```

## Performance Settings

### Low-End Servers
```lua
Config.Performance.Mode = 'low'
Config.DisableInitialSpawn = true
Config.MaxSuitcasesTotal = 50
```

### High-End Servers
```lua
Config.Performance.Mode = 'high'
Config.MaxSuitcasesTotal = 150
```

## Commands

### Admin Commands
- `/givecrowbar` - Give yourself a crowbar
- `/givelockpick` - Give yourself a lockpick  
- `/giveenvelope [amount]` - Give envelopes

### Debug Commands (when Config.Debug = true)
- `/testsuitcase` - Spawn suitcase in nearest vehicle
- `/clearsuitcases` - Clear all suitcases
- `/checksuitcases` - Check suitcase status
- `/resetpostboxes` - Reset all postboxes
- `/checkpostboxes` - Check postbox status

## Troubleshooting

### High CPU Usage
1. Set `Config.Performance.Mode = 'low'`
2. Reduce `Config.MaxSuitcasesTotal`
3. Disable debug: `Config.Debug = false`

### Items Not Appearing
1. Check items exist in database
2. Verify ox_inventory is running
3. Use `/giveenvelope 1` to test

## Credits
Created by BBY for ESX Framework
Optimized for production servers