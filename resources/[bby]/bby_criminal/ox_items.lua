-- Add this to your ox_inventory/data/items.lua or create a separate file

return {
    ['crowbar'] = {
        label = 'Crowbar',
        weight = 500,
        stack = true,
        close = true,
        description = 'A heavy duty crowbar, useful for breaking things'
    },
    ['lockpick'] = {
        label = 'Lockpick',
        weight = 50,
        stack = true,
        close = true,
        description = 'A set of lockpicking tools'
    },
    ['envelope'] = {
        label = 'Envelope',
        weight = 10,
        stack = true,
        close = true,
        description = 'A sealed envelope, might contain something valuable'
    }
}