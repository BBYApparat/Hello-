-- Existing code for cigarettes
AddEventHandler('ox_inventory:usedItem', function(playerId, name, slotId, metadata)
    if name == "cigsredwood" then Core.AddItem(playerId, "cigarette", 1) end
    
    if name == "cigarette" then
        local myLighter = exports.ox_inventory:Search(playerId, "slots", "lighter")
        
        if #myLighter > 1 then myLighter = myLighter[math.random(1, #myLighter)] else myLighter = myLighter[1] end
        
        if myLighter and myLighter.metadata.gas > 0 then
            myLighter.metadata.gas = myLighter.metadata.gas - 0.5
            exports.ox_inventory:SetMetadata(playerId, myLighter.slot, myLighter.metadata)
            exports.ox_inventory:SetDurability(playerId, myLighter.slot, myLighter.metadata.gas)
            -- exports.ox_inventory:RemoveItem(playerId, name, 1, nil, slotId)
            -- TriggerClientEvent("n_snippets:animations:startSmoking", playerId)
        else
            Core.Notify(playerId, "You need fire to light your cig lawl", "error", 3500)
        end
    end
    
    -- New code for pokemon packet
    if name == "pokemon_packet" then
        local cardsPerPack = 5
        local hasSpace = exports.ox_inventory:CanCarryItem(playerId, 'pokemon_card', cardsPerPack)
        
        if not hasSpace then
            Core.Notify(playerId, "You need space for 5 cards to open this pack", "error", 3500)
            return
        end
        
        -- Generate cards
        local rarityFound = {}
        for i = 1, cardsPerPack do
            local cardData = GetRandomCard()
            
            -- Track the rarity for notification
            rarityFound[cardData.rarity] = (rarityFound[cardData.rarity] or 0) + 1
            
            -- Add card to inventory
            exports.ox_inventory:AddItem(playerId, 'pokemon_card', 1, cardData)
        end
        
        -- Create notification message showing what rarities were found
        local message = "You opened a pack and found:"
        for rarity, count in pairs(rarityFound) do
            message = message .. "\n" .. count .. " " .. rarity
        end
        
        Core.Notify(playerId, message, "success", 5000)
    end
    
    -- Inspect a Pokemon card
    if name == "pokemon_card" and metadata then
        local message = ("You examine your %s card\nType: %s | Rarity: %s\nHP: %s | ATK: %s | DEF: %s"):format(
            metadata.label,
            metadata.type or "Unknown",
            metadata.rarity or "Common",
            metadata.hp or "??",
            metadata.attack or "??",
            metadata.defense or "??"
        )
        
        Core.Notify(playerId, message, "success", 5000)
        TriggerClientEvent('n_snippets:animations:inspectCard', playerId)

    end
end)

-- Define Pokemon card data
local pokemonCards = {
    -- Common Pokemon (60% chance)
    common = {
        {
            label = 'Pikachu',
            description = 'A Mouse Pokémon. It can generate electricity from the electric pouches in its cheeks.',
            type = 'Electric',
            rarity = 'Common',
            hp = 35,
            attack = 55,
            defense = 40
        },
        {
            label = 'Bulbasaur',
            description = 'A Grass/Poison type Pokémon. It carries a seed on its back since birth.',
            type = 'Grass',
            rarity = 'Common',
            hp = 45,
            attack = 49,
            defense = 49
        },
        {
            label = 'Charmander',
            description = 'A Fire type Pokémon. The flame on its tail shows its life force.',
            type = 'Fire',
            rarity = 'Common',
            hp = 39,
            attack = 52,
            defense = 43
        },
        {
            label = 'Squirtle',
            description = 'A Water type Pokémon. It shelters itself in its shell, then strikes when opportunity knocks.',
            type = 'Water',
            rarity = 'Common',
            hp = 44,
            attack = 48,
            defense = 65
        }
    },
    
    -- Uncommon Pokemon (25% chance)
    uncommon = {
        {
            label = 'Wartortle',
            description = 'It is recognized as a symbol of longevity. If its shell has algae on it, that Wartortle is very old.',
            type = 'Water',
            rarity = 'Uncommon',
            hp = 59,
            attack = 63,
            defense = 80
        },
        {
            label = 'Ivysaur',
            description = 'When the bulb on its back grows large, it appears to lose the ability to stand on its hind legs.',
            type = 'Grass',
            rarity = 'Uncommon',
            hp = 60,
            attack = 62,
            defense = 63
        },
        {
            label = 'Charmeleon',
            description = 'It has a barbaric nature. In battle, it whips its fiery tail around and slashes away with sharp claws.',
            type = 'Fire',
            rarity = 'Uncommon',
            hp = 58,
            attack = 64,
            defense = 58
        }
    },
    
    -- Rare Pokemon (10% chance)
    rare = {
        {
            label = 'Blastoise',
            description = 'It crushes its foe under its heavy body to cause fainting. In a pinch, it will withdraw inside its shell.',
            type = 'Water',
            rarity = 'Rare',
            hp = 79,
            attack = 83,
            defense = 100
        },
        {
            label = 'Venusaur',
            description = 'Its plant blooms when it is absorbing solar energy. It stays on the move to seek sunlight.',
            type = 'Grass',
            rarity = 'Rare',
            hp = 80,
            attack = 82,
            defense = 83
        }
    },
    
    -- Legendary Pokemon (5% chance)
    legendary = {
        {
            label = 'Charizard',
            description = 'It is said that Charizard\'s fire burns hotter if it has experienced harsh battles.',
            type = 'Fire',
            rarity = 'Legendary',
            hp = 78,
            attack = 84,
            defense = 78,
            image = 'charizard'
        },
        {
            label = 'Mewtwo',
            description = 'A Pokémon created by recombining Mew\'s genes. It\'s said to have the most savage heart among Pokémon.',
            type = 'Psychic',
            rarity = 'Legendary',
            hp = 106,
            attack = 110,
            defense = 90,
            image = 'mewtwo'
        }
    }
}

-- Random card generation function
function GetRandomCard()
    local chance = math.random(1, 100)
    local rarityTier
    
    if chance <= 5 then
        rarityTier = 'legendary'  -- 5% chance
    elseif chance <= 15 then
        rarityTier = 'rare'       -- 10% chance
    elseif chance <= 40 then
        rarityTier = 'uncommon'   -- 25% chance
    else
        rarityTier = 'common'     -- 60% chance
    end
    
    local tierCards = pokemonCards[rarityTier]
    local selectedCard = tierCards[math.random(1, #tierCards)]
    
    -- Make a deep copy of the card to avoid modifying the template
    local cardCopy = {}
    for k, v in pairs(selectedCard) do
        cardCopy[k] = v
    end
    
    -- Assign a unique serial number
    cardCopy.serial = string.format("%04d", math.random(1, 9999))
    
    -- Add slight randomization to stats
    local statVariation = math.random(-3, 3)
    cardCopy.hp = math.max(cardCopy.hp + statVariation, 1)
    cardCopy.attack = math.max(cardCopy.attack + statVariation, 1)
    cardCopy.defense = math.max(cardCopy.defense + statVariation, 1)
    
    return cardCopy
end

-- Existing hook for lighters
local hookId = exports.ox_inventory:registerHook('createItem', function(payload)
    if payload.item == 'lighter' then
        payload.metadata.gas = 100
    elseif payload.item == 'pokemon_card' and payload.metadata and payload.metadata.label then
        -- This allows the system to recognize cards with pre-defined metadata
        return payload.metadata
    end
    return payload.metadata
end, {
    itemFilter = {
        lighter = true,
        pokemon_card = true
    }
})