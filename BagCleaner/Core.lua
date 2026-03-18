local addonName, ns = ...

-- Addon namespace setup
ns.name = addonName
ns.version = "1.0.0"

-- Module tables
ns.Rules = {}
ns.AutoSell = {}
ns.Disenchant = {}
ns.UI = {}

-- Default configuration
ns.defaults = {
    autoSellEnabled = true,
    sellPoor = true,          -- grey items
    sellCommon = false,       -- white items
    sellUncommon = false,     -- green items
    sellBelowIlvl = 0,        -- 0 = disabled
    sellDelay = 0.2,           -- seconds between sells
    keepList = {},             -- { [itemID] = itemName }
    sellList = {},             -- { [itemID] = itemName }
    deMarkEnabled = true,
    deMinQuality = 2,          -- Uncommon
    deMaxQuality = 2,          -- Uncommon
    deBelowIlvl = 0,           -- 0 = disabled
}

-- Initialize saved variables with defaults
function ns:InitDB()
    if not BagCleanerDB then
        BagCleanerDB = {}
    end
    for key, value in pairs(self.defaults) do
        if BagCleanerDB[key] == nil then
            if type(value) == "table" then
                BagCleanerDB[key] = {}
                for k, v in pairs(value) do
                    BagCleanerDB[key][k] = v
                end
            else
                BagCleanerDB[key] = value
            end
        end
    end
    self.db = BagCleanerDB
end

-- Chat output with addon prefix
function ns:Print(msg)
    local prefix = "|cFF00CCFF" .. self.name .. ":|r "
    DEFAULT_CHAT_FRAME:AddMessage(prefix .. msg)
end

-- Get consolidated item details for a bag slot
function ns:GetItemDetails(bag, slot)
    local info = C_Container.GetContainerItemInfo(bag, slot)
    if not info then return nil end

    local details = {
        bag = bag,
        slot = slot,
        itemID = info.itemID,
        itemLink = info.hyperlink,
        stackCount = info.stackCount,
        quality = info.quality,
        isLocked = info.isLocked,
        hasNoValue = info.hasNoValue,
    }

    -- Get additional item info
    local itemName, _, _, itemLevel, _, itemType, itemSubType, _, equipLoc, _, sellPrice, classID, subclassID = C_Item.GetItemInfo(info.itemID)
    if itemName then
        details.name = itemName
        details.itemLevel = itemLevel
        details.itemType = itemType
        details.itemSubType = itemSubType
        details.equipLoc = equipLoc
        details.sellPrice = sellPrice or 0
        details.classID = classID
        details.subclassID = subclassID
    end

    return details
end

-- Format copper value to gold/silver/copper string
function ns:FormatMoney(copper)
    if not copper or copper == 0 then
        return "0"
    end
    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local cop = copper % 100

    local parts = {}
    if gold > 0 then table.insert(parts, gold .. "g") end
    if silver > 0 then table.insert(parts, silver .. "s") end
    if cop > 0 then table.insert(parts, cop .. "c") end

    return table.concat(parts, " ")
end

-- Main event frame
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("MERCHANT_SHOW")
frame:RegisterEvent("MERCHANT_CLOSED")
frame:RegisterEvent("BAG_UPDATE")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local name = ...
        if name == addonName then
            ns:InitDB()
            ns.UI:RegisterSlashCommands()
            self:UnregisterEvent("ADDON_LOADED")
        end
    elseif event == "PLAYER_LOGIN" then
        ns:Print(ns.L["LOADED"])
        ns.Disenchant:UpdateOverlays()
    elseif event == "MERCHANT_SHOW" then
        ns.AutoSell:OnMerchantShow()
    elseif event == "MERCHANT_CLOSED" then
        ns.AutoSell:OnMerchantClosed()
    elseif event == "BAG_UPDATE" then
        if ns.db and ns.db.deMarkEnabled then
            ns.Disenchant:UpdateOverlays()
        end
    end
end)
