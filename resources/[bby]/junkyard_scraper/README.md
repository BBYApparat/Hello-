# Junkyard Scraper System

A comprehensive junkyard scraping system for ESX servers with ox_inventory integration.

## Features

- **Progressive Scrapping**: 3-stage scrapping system (1/3, 2/3, 3/3)
- **Zone-based System**: Only works within the defined junkyard area
- **ox_target Integration**: Interactive object targeting system
- **Animations & Progress Bars**: Realistic scrapping experience using ox_lib
- **Inventory Integration**: Full ox_inventory compatibility with item checks
- **Multiple Object Support**: Works with various junkyard object models

## Configuration

### Junkyard Location
- **Bot Position**: `vector3(2367.917, 3156.318, 48.209)`
- **Zone Boundaries**: Polygon area defined by 6 points around the junkyard

### Supported Object Models
- 10106915
- 591265130  
- -915224107
- 322493792
- -273279397

### Rewards per Stage
- **Stage 1/3**: Scrap (1-3), Plastic (1-2)
- **Stage 2/3**: Scrap Electronics (1-2), Rubber (1-3) 
- **Stage 3/3**: Copper Nugget (1-2), Iron Nugget (1-2), Glass (1-3)

## Usage

1. Enter the junkyard area (you'll get a notification)
2. Use ox_target to interact with scrapable objects
3. Complete the 10-second progress bar for each stage
4. Collect rewards after each successful stage
5. Objects become fully scraped after 3 stages

## Dependencies

- ESX Legacy
- ox_lib
- ox_target  
- ox_inventory
- oxmysql

## Installation

1. Place resource in `[bby]` folder
2. Ensure the resource loads after dependencies
3. Restart server or `ensure junkyard_scraper`

## Debug Mode

Set `Config.Debug = true` to enable console logging for troubleshooting.

## Notes

- Players must be within the junkyard zone to scrap objects
- Objects track progress individually via NetworkId
- Full inventory protection - won't give items if player can't carry them
- Animation cancellation support with proper cleanup