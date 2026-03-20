local addonName, ns = ...
local Rules = ns.Rules

-- Check if an item should be sold at a vendor
function Rules:ShouldSell(item)
    if not item then return false end

    local db = ns.db

    -- Keep list always wins
    if db.keepList[item.itemID] then
        return false
    end

    -- Explicit sell list
    if db.sellList[item.itemID] then
        return true
    end

    -- Items with no vendor value cannot be sold
    if item.hasNoValue or (item.sellPrice and item.sellPrice == 0) then
        return false
    end

    -- Protect non-soulbound equipment if enabled
    if db.protectUnbound and item.classID then
        local isEquipment = (item.classID == 2) or (item.classID == 4)
        if isEquipment and not item.isBound then
            return false
        end
    end

    -- Quality-based rules
    if db.sellPoor and item.quality == 0 then
        return true
    end
    if db.sellCommon and item.quality == 1 then
        return true
    end
    if db.sellUncommon and item.quality == 2 then
        return true
    end

    -- Item level threshold for equipment
    if db.sellBelowIlvl > 0 and item.itemLevel and item.classID then
        local isEquipment = (item.classID == 2) or (item.classID == 4) -- Weapon or Armor
        if isEquipment and item.itemLevel < db.sellBelowIlvl then
            return true
        end
    end

    -- Expansion-based filter
    if item.expacID and db.sellExpansions and db.sellExpansions[item.expacID] then
        return true
    end

    return false
end

-- Check if an item should be marked for disenchanting
function Rules:ShouldMarkDE(item)
    if not item then return false end

    local db = ns.db

    -- Keep list always wins
    if db.keepList[item.itemID] then
        return false
    end

    -- Must be equipment (Weapon=2 or Armor=4)
    if not item.classID then return false end
    if item.classID ~= 2 and item.classID ~= 4 then
        return false
    end

    -- Quality must be in the configured range
    if not item.quality then return false end
    if item.quality < db.deMinQuality or item.quality > db.deMaxQuality then
        return false
    end

    -- Item level threshold
    if db.deBelowIlvl > 0 and item.itemLevel then
        if item.itemLevel >= db.deBelowIlvl then
            return false
        end
    end

    return true
end

-- Check if an item is a one-time learnable that could be used to free space
-- Covers: recipes, companion pets, mounts, toys, transmog ensembles, etc.
function Rules:ShouldMarkUse(item)
    if not item then return false end

    local db = ns.db
    if not db.markLearnables then return false end

    -- Keep list always wins
    if db.keepList[item.itemID] then
        return false
    end

    if not item.classID then return false end

    -- Recipe (classID 9): plans, patterns, schematics, formulas, etc.
    if item.classID == 9 then
        return true
    end

    -- Miscellaneous (classID 15) learnable subcategories
    if item.classID == 15 then
        -- subclassID 2 = Companion Pet, 5 = Mount
        if item.subclassID == 2 or item.subclassID == 5 then
            return true
        end
    end

    -- Check for toys via C_ToyBox (items that teach a toy)
    if item.itemID and C_ToyBox and C_ToyBox.GetToyInfo then
        local toyItemID = C_ToyBox.GetToyInfo(item.itemID)
        if toyItemID then
            -- Only mark if not already collected
            if not PlayerHasToy or not PlayerHasToy(item.itemID) then
                return true
            end
        end
    end

    return false
end

-- List management
function Rules:AddToKeepList(itemID, itemName)
    ns.db.keepList[itemID] = itemName or true
    -- Remove from sell list if present
    ns.db.sellList[itemID] = nil
end

function Rules:RemoveFromKeepList(itemID)
    ns.db.keepList[itemID] = nil
end

function Rules:AddToSellList(itemID, itemName)
    ns.db.sellList[itemID] = itemName or true
    -- Remove from keep list if present
    ns.db.keepList[itemID] = nil
end

function Rules:RemoveFromSellList(itemID)
    ns.db.sellList[itemID] = nil
end
