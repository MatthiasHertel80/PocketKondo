local addonName, ns = ...
local UI = ns.UI
local L

local function GetL()
    if not L then L = ns.L end
    return L
end

-- Expansion IDs and their locale keys
local EXPANSION_ORDER = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }
local EXPANSION_KEYS = {
    [0] = "EXP_CLASSIC", [1] = "EXP_BC", [2] = "EXP_WRATH", [3] = "EXP_CATA",
    [4] = "EXP_MOP", [5] = "EXP_WOD", [6] = "EXP_LEGION", [7] = "EXP_BFA",
    [8] = "EXP_SL", [9] = "EXP_DF", [10] = "EXP_TWW", [11] = "EXP_MIDNIGHT",
}

-- ========================================
-- Slash Commands
-- ========================================

function UI:RegisterSlashCommands()
    SLASH_POCKETKONDO1 = "/pocketkondo"
    SLASH_POCKETKONDO2 = "/pk"
    SlashCmdList["POCKETKONDO"] = function(msg)
        UI:HandleSlashCommand(strtrim(msg or ""))
    end
end

local function ParseItemLink(msg)
    local itemLink = msg:match("|c.-|H(item:%d+.-)|h.-|h|r")
    if itemLink then
        local fullLink = msg:match("(|c.-|h.-|h|r)")
        local itemID = tonumber(itemLink:match("item:(%d+)"))
        local itemName = msg:match("|h%[(.-)%]|h")
        return itemID, itemName, fullLink
    end
    return nil
end

function UI:HandleSlashCommand(msg)
    local L = GetL()
    local cmd, rest = msg:match("^(%S+)%s*(.*)")
    cmd = cmd and cmd:lower() or ""

    if cmd == "" then
        self:OpenSettings()
    elseif cmd == "status" then
        self:PrintStatus()
    elseif cmd == "sell" then
        ns.db.autoSellEnabled = not ns.db.autoSellEnabled
        ns:Print(ns.db.autoSellEnabled and L.AUTOSELL_TOGGLED_ON or L.AUTOSELL_TOGGLED_OFF)
    elseif cmd == "de" then
        ns.db.deMarkEnabled = not ns.db.deMarkEnabled
        ns:Print(ns.db.deMarkEnabled and L.DE_ENABLED or L.DE_DISABLED)
        if ns.db.deMarkEnabled then
            ns.Disenchant:UpdateOverlays()
        else
            ns.Disenchant:ClearAllOverlays()
        end
    elseif cmd == "keep" then
        local itemID, itemName, fullLink = ParseItemLink(rest)
        if itemID then
            ns.Rules:AddToKeepList(itemID, itemName)
            ns:Print(string.format(L.ITEM_ADDED_KEEP, fullLink or itemName))
        else
            ns:Print(L.ITEM_NOT_FOUND)
        end
    elseif cmd == "sell-add" then
        local itemID, itemName, fullLink = ParseItemLink(rest)
        if itemID then
            ns.Rules:AddToSellList(itemID, itemName)
            ns:Print(string.format(L.ITEM_ADDED_SELL, fullLink or itemName))
        else
            ns:Print(L.ITEM_NOT_FOUND)
        end
    elseif cmd == "keep-remove" then
        local itemID, itemName, fullLink = ParseItemLink(rest)
        if itemID then
            ns.Rules:RemoveFromKeepList(itemID)
            ns:Print(string.format(L.ITEM_REMOVED_KEEP, fullLink or itemName))
        else
            ns:Print(L.ITEM_NOT_FOUND)
        end
    elseif cmd == "sell-remove" then
        local itemID, itemName, fullLink = ParseItemLink(rest)
        if itemID then
            ns.Rules:RemoveFromSellList(itemID)
            ns:Print(string.format(L.ITEM_REMOVED_SELL, fullLink or itemName))
        else
            ns:Print(L.ITEM_NOT_FOUND)
        end
    elseif cmd == "list" then
        self:PrintLists()
    elseif cmd == "help" then
        self:PrintHelp()
    else
        self:PrintHelp()
    end
end

function UI:PrintStatus()
    local L = GetL()
    local db = ns.db
    local bool = function(v) return v and L.YES or L.NO end

    ns:Print(L.STATUS_HEADER)
    ns:Print(db.autoSellEnabled and L.AUTOSELL_ENABLED or L.AUTOSELL_DISABLED)
    ns:Print(L.SELL_POOR .. bool(db.sellPoor))
    ns:Print(L.SELL_COMMON .. bool(db.sellCommon))
    ns:Print(L.SELL_UNCOMMON .. bool(db.sellUncommon))
    ns:Print(L.SELL_BELOW_ILVL .. (db.sellBelowIlvl > 0 and tostring(db.sellBelowIlvl) or L.DISABLED))
    ns:Print(db.deMarkEnabled and L.DE_ENABLED or L.DE_DISABLED)
    ns:Print(string.format(L.DE_QUALITY_RANGE, ns:GetQualityName(db.deMinQuality), ns:GetQualityName(db.deMaxQuality)))
end

function UI:PrintLists()
    local L = GetL()
    local db = ns.db

    ns:Print(L.KEEP_LIST .. ":")
    local keepCount = 0
    for id, name in pairs(db.keepList) do
        keepCount = keepCount + 1
        ns:Print("  " .. tostring(name) .. " (ID: " .. id .. ")")
    end
    if keepCount == 0 then ns:Print(L.LIST_EMPTY) end

    ns:Print(L.SELL_LIST .. ":")
    local sellCount = 0
    for id, name in pairs(db.sellList) do
        sellCount = sellCount + 1
        ns:Print("  " .. tostring(name) .. " (ID: " .. id .. ")")
    end
    if sellCount == 0 then ns:Print(L.LIST_EMPTY) end
end

function UI:PrintHelp()
    local L = GetL()
    ns:Print(L.HELP_HEADER)
    ns:Print(L.HELP_OPTIONS)
    ns:Print(L.HELP_STATUS)
    ns:Print(L.HELP_SELL)
    ns:Print(L.HELP_DE)
    ns:Print(L.HELP_KEEP)
    ns:Print(L.HELP_SELL_ADD)
    ns:Print(L.HELP_KEEP_REMOVE)
    ns:Print(L.HELP_SELL_REMOVE)
    ns:Print(L.HELP_LIST)
end

-- ========================================
-- Blizzard Settings API Integration
-- ========================================

local settingsCategory = nil

-- Helper: register a checkbox setting backed by ns.db
local function AddCheckbox(category, dbKey, name, tooltip, defaultVal)
    local setting = Settings.RegisterProxySetting(category, "PocketKondo_" .. dbKey, type(defaultVal), name,
        defaultVal,
        function() return ns.db[dbKey] end,
        function(value)
            ns.db[dbKey] = value
            -- Side effects
            if dbKey == "deMarkEnabled" then
                if value then
                    ns.Disenchant:UpdateOverlays()
                else
                    ns.Disenchant:ClearAllOverlays()
                end
            end
        end
    )
    Settings.CreateCheckbox(category, setting, tooltip)
    return setting
end

-- Helper: register a slider setting backed by ns.db
local function AddSlider(category, dbKey, name, tooltip, defaultVal, minVal, maxVal, step)
    local setting = Settings.RegisterProxySetting(category, "PocketKondo_" .. dbKey, type(defaultVal), name,
        defaultVal,
        function() return ns.db[dbKey] end,
        function(value)
            ns.db[dbKey] = value
        end
    )
    local options = Settings.CreateSliderOptions(minVal, maxVal, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
    Settings.CreateSlider(category, setting, options, tooltip)
    return setting
end

-- Helper: register a dropdown setting backed by ns.db
local function AddDropdown(category, dbKey, name, tooltip, defaultVal, optionsFunc)
    local setting = Settings.RegisterProxySetting(category, "PocketKondo_" .. dbKey, type(defaultVal), name,
        defaultVal,
        function() return ns.db[dbKey] end,
        function(value) ns.db[dbKey] = value end
    )
    Settings.CreateDropdown(category, setting, optionsFunc, tooltip)
    return setting
end

function UI:RegisterSettingsPanel()
    local L = GetL()

    local category = Settings.RegisterVerticalLayoutCategory("PocketKondo")

    -- ============ Auto-Sell Section ============
    local autoSellLayout = category:CreateLayout()

    AddCheckbox(category, "autoSellEnabled", L.ENABLE_AUTOSELL, L.TOOLTIP_AUTOSELL, true)
    AddCheckbox(category, "sellPoor", L.SELL_POOR_LABEL, L.TOOLTIP_SELL_POOR, true)
    AddCheckbox(category, "sellCommon", L.SELL_COMMON_LABEL, L.TOOLTIP_SELL_COMMON, false)
    AddCheckbox(category, "sellUncommon", L.SELL_UNCOMMON_LABEL, L.TOOLTIP_SELL_UNCOMMON, false)
    AddSlider(category, "sellBelowIlvl", L.SELL_BELOW_ILVL_LABEL, L.TOOLTIP_SELL_ILVL, 0, 0, 500, 5)
    AddCheckbox(category, "protectUnbound", L.PROTECT_UNBOUND_LABEL, L.TOOLTIP_PROTECT_UNBOUND, true)
    AddCheckbox(category, "confirmBeforeSell", L.CONFIRM_SELL_LABEL, L.TOOLTIP_CONFIRM_SELL, false)

    -- ============ Disenchant Section ============
    AddCheckbox(category, "deMarkEnabled", L.ENABLE_DE, L.TOOLTIP_DE, true)

    local function QualityOptions()
        local container = Settings.CreateControlTextContainer()
        container:Add(2, L.QUALITY_UNCOMMON)
        container:Add(3, L.QUALITY_RARE)
        container:Add(4, L.QUALITY_EPIC)
        return container:GetData()
    end

    AddDropdown(category, "deMinQuality", L.DE_MIN_QUALITY_LABEL, L.TOOLTIP_DE_MIN, 2, QualityOptions)
    AddDropdown(category, "deMaxQuality", L.DE_MAX_QUALITY_LABEL, L.TOOLTIP_DE_MAX, 2, QualityOptions)
    AddSlider(category, "deBelowIlvl", L.DE_BELOW_ILVL_LABEL, L.TOOLTIP_DE_ILVL, 0, 0, 500, 5)

    -- ============ Expansion Filter Section ============
    for _, expID in ipairs(EXPANSION_ORDER) do
        local locKey = EXPANSION_KEYS[expID]
        local dbKey = "sellExp_" .. expID

        local setting = Settings.RegisterProxySetting(category, "PocketKondo_sellExp_" .. expID, "boolean",
            L[locKey],
            false,
            function() return ns.db.sellExpansions[expID] or false end,
            function(value)
                if value then
                    ns.db.sellExpansions[expID] = true
                else
                    ns.db.sellExpansions[expID] = nil
                end
            end
        )
        Settings.CreateCheckbox(category, setting, string.format(L.TOOLTIP_EXPANSION, L[locKey]))
    end

    Settings.RegisterAddOnCategory(category)
    settingsCategory = category
end

function UI:OpenSettings()
    if settingsCategory then
        Settings.OpenToCategory(settingsCategory:GetID())
    end
end
