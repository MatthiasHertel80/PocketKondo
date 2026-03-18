local addonName, ns = ...

-- Addon namespace setup
ns.name = addonName
ns.version = "1.1.0"

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
    protectUnbound = true,     -- protect non-soulbound equipment from being sold
    confirmBeforeSell = false, -- show confirm dialog before selling
    sellExpansions = {},       -- { [expacID] = true } sell items from these expansions
    keepList = {},             -- { [itemID] = itemName }
    sellList = {},             -- { [itemID] = itemName }
    deMarkEnabled = true,
    deMinQuality = 2,          -- Uncommon
    deMaxQuality = 2,          -- Uncommon
    deBelowIlvl = 0,           -- 0 = disabled
}

-- Initialize saved variables with defaults
function ns:InitDB()
    if not PocketKondoDB then
        PocketKondoDB = {}
    end
    for key, value in pairs(self.defaults) do
        if PocketKondoDB[key] == nil then
            if type(value) == "table" then
                PocketKondoDB[key] = {}
                for k, v in pairs(value) do
                    PocketKondoDB[key][k] = v
                end
            else
                PocketKondoDB[key] = value
            end
        end
    end
    self.db = PocketKondoDB
end

-- Chat output with addon prefix (pink for that Kondo aesthetic)
function ns:Print(msg)
    local prefix = "|cFFFF69B4PocketKondo:|r "
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

    -- Use GetItemInfoInstant for classID (always available, no cache needed)
    local itemID_instant, itemType_instant, itemSubType_instant, equipLoc_instant, icon_instant, classID_instant, subclassID_instant = C_Item.GetItemInfoInstant(info.itemID)
    if itemID_instant then
        details.classID = classID_instant
        details.subclassID = subclassID_instant
        details.equipLoc = equipLoc_instant
    end

    -- Use GetItemInfo for name, sell price and other cached data
    local itemName, _, _, itemLevel, _, itemType, itemSubType, _, equipLoc, _, sellPrice, classID, subclassID, _, expacID = C_Item.GetItemInfo(info.itemID)
    if itemName then
        details.name = itemName
        details.itemType = itemType
        details.itemSubType = itemSubType
        details.sellPrice = sellPrice or 0
        details.expacID = expacID
        -- Fallback: override with GetItemInfo values if GetItemInfoInstant missed them
        details.classID = details.classID or classID
        details.subclassID = details.subclassID or subclassID
        details.equipLoc = details.equipLoc or equipLoc
    end

    -- Get reliable item level via ItemLocation (works for upgraded/modified gear)
    local itemLocation = ItemLocation:CreateFromBagAndSlot(bag, slot)
    if itemLocation and C_Item.DoesItemExist(itemLocation) then
        local currentIlvl = C_Item.GetCurrentItemLevel(itemLocation)
        details.itemLevel = currentIlvl or itemLevel
    else
        details.itemLevel = itemLevel
    end

    -- Check soulbound status via C_TooltipInfo
    details.isBound = false
    local isEquipment = details.classID and (details.classID == 2 or details.classID == 4)
    if isEquipment then
        local tooltipData = C_TooltipInfo.GetBagItem(bag, slot)
        if tooltipData and tooltipData.lines then
            for i = 2, math.min(#tooltipData.lines, 6) do
                local lineText = tooltipData.lines[i] and tooltipData.lines[i].leftText
                if lineText then
                    if lineText == ITEM_SOULBOUND or lineText == ITEM_ACCOUNTBOUND or lineText == ITEM_BNETACCOUNTBOUND then
                        details.isBound = true
                        break
                    end
                end
            end
        end
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
        ns:InitMinimapButton()
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
