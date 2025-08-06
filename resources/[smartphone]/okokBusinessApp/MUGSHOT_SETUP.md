# okokBusinessApp - MugShotBase64 Integration

This guide shows how to set up the MugShotBase64 integration for displaying real player faces in the business directory.

## Features

- **Real Player Faces**: Shows actual player mugshots instead of initials
- **Fast Caching**: Images cached in database for instant loading
- **Automatic Updates**: Mugshots auto-update when players change jobs
- **Fallback Support**: Shows initials if mugshot unavailable
- **Low Performance Impact**: 0.00ms idle, 0.01ms when generating

## Requirements

1. **MugShotBase64 Resource** - Download from: https://github.com/BaziForYou/MugShotBase64
2. **MySQL Database** - For caching mugshots
3. **ESX Framework** - Already required by okokBusinessApp

## Installation

### Step 1: Install MugShotBase64

1. Download MugShotBase64 from GitHub
2. Extract to your resources folder
3. Add to server.cfg **BEFORE** okokBusinessApp:
   ```
   start MugShotBase64
   start okokBusinessApp
   ```

### Step 2: Database Setup

Run this SQL query in your database:

```sql
CREATE TABLE IF NOT EXISTS `player_mugshots` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `server_id` int(11) NOT NULL,
    `mugshot` LONGTEXT NOT NULL,
    `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `server_id` (`server_id`),
    INDEX `idx_server_id` (`server_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

Or use the provided file: `sql/player_mugshots.sql`

### Step 3: Configuration

The mugshot system is automatically enabled when MugShotBase64 is detected. No additional configuration needed.

## How It Works

1. **First Load**: When a player appears in business directory for first time, their mugshot is generated
2. **Caching**: Mugshot stored in database as base64 string
3. **Future Loads**: Cached mugshot loaded instantly from database
4. **Auto Updates**: Mugshots refresh when players change jobs (for businesses in the directory)

## Commands

- `/refreshmugshot` - Manually refresh your own mugshot (useful for testing)

## Troubleshooting

### No Mugshots Appearing

1. Check if MugShotBase64 is running: `/status MugShotBase64`
2. Check console for errors
3. Ensure database table exists
4. Try `/refreshmugshot` command

### Performance Issues

- Mugshots are cached, so only first generation impacts performance
- Database stores images as LONGTEXT (efficient for base64)
- Consider cleaning old mugshots periodically:
  ```sql
  DELETE FROM player_mugshots WHERE updated_at < DATE_SUB(NOW(), INTERVAL 7 DAY);
  ```

### Fallback System

If MugShotBase64 is not available:
- Employee cards show first letter of name
- No errors or crashes occur
- System gracefully degrades

## Technical Details

### MugShotBase64 Export Used
```lua
exports["MugShotBase64"]:GetMugShotBase64(PlayerPedId(), true)
```

### Database Schema
- `server_id`: Player's server ID (unique)
- `mugshot`: Base64 encoded PNG image
- `created_at/updated_at`: Timestamps for cache management

### Client Events
- `okokBusinessApp:requestMugshot` - Request mugshot generation
- `okokBusinessApp:storeMugshot` - Store generated mugshot

## Credits

- **MugShotBase64**: BaziForYou (https://github.com/BaziForYou/MugShotBase64)
- **Integration**: Added to okokBusinessApp for enhanced user experience