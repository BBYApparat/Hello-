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
        consume = 1,
        client = {
            status = { thirst = -5 }, -- Small excitement boost
            anim = { dict = 'mp_arresting', clip = 'a_uncuff' },
            prop = { model = 'prop_cs_envelope_01', pos = vec3(0.02, 0.02, -0.02), rot = vec3(0.0, 0.0, 0.0) },
            usetime = 2500
        },
        description = 'A sealed envelope from a postbox. Open it to see what\'s inside!'
    }
}