# 🐄 Cow Milking Script for FiveM

A realistic cow milking script using ox_target interactions and ps-minigames skill checks. Players can milk cows to obtain raw milk with different cooldowns for each cow.

## ✨ Features

- **9 Cows** with individual cooldown timers (12-28 minutes)
- **ox_target Integration** - Clean interaction system
- **ps-minigames Skill Checks** - Multiple skill checks required
- **Random Milk Amounts** - Get 1-3 raw milk per successful milking
- **Realistic Animations** - Kneeling animation while milking
- **Individual Cooldowns** - Each cow has different recovery times
- **ox_inventory Integration** - Full inventory compatibility
- **Health Benefits** - Drinking milk restores health
- **Admin Commands** - Reset cooldowns and debug features

## 📋 Dependencies

- **es_extended** (ESX Legacy)
- **ox_lib**
- **ox_target**
- **ox_inventory**
- **ps-minigames**
- **oxmysql** (if using persistent cooldowns)

## 🚀 Installation

### 1. Download and Setup
```bash
# Place the script in your resources folder
resources/
└── cow-milking/
    ├── client/
    │   └── main.lua
    ├── server/
    │   └── main.lua
    ├── config.lua
    ├── fxmanifest.lua
    └── README.md
```

### 2. Add Item to ox_inventory
Add this to your `ox_inventory/data/items.lua`:
```lua
['milk_raw'] = {
    label = 'Raw Milk',
    weight = 500,
    stack = true,
    close = true,
    description = 'Fresh milk directly from a cow. Can be consumed for a small health boost.',
    client = {
        status = { hunger = 200000, thirst = 150000 },
        anim = 'drinking',
        prop = 'prop_food_bs_juice02',
        usetime = 2500
    }
}
```

### 3. Database Setup (Optional)
If you want persistent cooldowns across server restarts, run the SQL:
```sql
CREATE TABLE IF NOT EXISTS `cow_cooldowns` (
    `cow_id` INT NOT NULL PRIMARY KEY,
    `cooldown_time` INT NOT NULL DEFAULT 0
);
```

Then set `Config.PersistentCooldowns = true` in config.lua

### 4. Server Configuration
Add to your `server.cfg`:
```
ensure cow-milking
```

## ⚙️ Configuration

### Cow Locations
The script spawns 9 cows near Grapeseed by default. You can change locations in `config.lua`:
```lua
Config.CowLocations = {
    {
        coords = vector3(2447.12, 4740.89, 34.31),
        heading = 45.0
    },
    -- Add more locations...
}
```

### Cooldown Times
Each cow has individual cooldown times (in minutes):
```lua
Config.CowCooldowns = {
    [1] = 15, -- Cow #1 - 15 minutes
    [2] = 20, -- Cow #2 - 20 minutes  
    [3] = 12, -- Cow #3 - 12 minutes
    -- etc...
}
```

### Milk Settings
```lua
Config.MinMilk = 1 -- Minimum milk per success
Config.MaxMilk = 3 -- Maximum milk per success
Config.MilkItem = 'milk_raw' -- Item name
```

### Minigame Settings
The script uses ps-minigames with 5 skill checks of varying difficulty.

## 🎮 How to Use

1. **Find Cows** - Go to the farm area near Grapeseed
2. **Interact** - Use ox_target to interact with available cows
3. **Complete Minigame** - Successfully complete all 5 skill checks
4. **Receive Milk** - Get 1-3 raw milk on success
5. **Wait for Cooldown** - Each cow has different recovery times

## 🔧 Admin Commands

```lua
/respawn_cows     -- Respawn all cows (debug)
/check_cooldowns  -- Check remaining cooldowns (console)
```

## 🏃‍♂️ Performance

- **Optimized Spawning** - Cows spawn once and persist
- **Efficient Cooldowns** - Server-side cooldown management
- **Memory Safe** - Proper cleanup on resource stop
- **Target Integration** - No unnecessary loops or checks

## 🐛 Troubleshooting

### Cows Not Spawning
- Check console for errors
- Ensure ox_target is running
- Verify coordinates in config.lua

### Minigame Not Working
- Ensure ps-minigames is installed and updated
- Check for script errors in F8 console

### Items Not Appearing
- Verify ox_inventory item configuration
- Restart ox_inventory after adding items
- Check inventory weight limits

### Cooldowns Not Working
- Check server console for database errors
- Verify ESX player loading events
- Try disabling persistent cooldowns

## 📞 Support

- Check F8 console for errors
- Verify all dependencies are installed
- Ensure proper installation order
- Test with default configurations first

## 🔄 Updates

- v1.0.0 - Initial release with ox_target and ps-minigames integration

---

**Enjoy your realistic farming experience! 🐄🥛**