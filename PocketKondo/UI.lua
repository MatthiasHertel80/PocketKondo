local addonName, ns = ...
local UI = ns.UI
local L

local function GetL()
    if not L then L = ns.L end
    return L
end

-- Register slash commands
function UI:RegisterSlashCommands()
    SLASH_POCKETKONDO1 = "/pocketkondo"
    SLASH_POCKETKONDO2 = "/pk"
    SlashCmdList["POCKETKONDO"] = function(msg)
        UI:HandleSlashCommand(strtrim(msg or ""))
    end
end

-- Parse item link from chat input
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
        self:ToggleOptionsPanel()
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
-- Settings Panel (standalone frame)
-- ========================================

local optionsFrame = nil

function UI:ToggleOptionsPanel()
    if optionsFrame and optionsFrame:IsShown() then
        optionsFrame:Hide()
        return
    end

    if not optionsFrame then
        self:CreateOptionsPanel()
    end

    self:RefreshOptionsPanel()
    optionsFrame:Show()
end

function UI:CreateOptionsPanel()
    local L = GetL()

    -- Midnight-compatible: BackdropTemplate + ApplyBackdrop (SetBackdrop removed in 9.0)
    optionsFrame = CreateFrame("Frame", "PocketKondoOptionsFrame", UIParent, "BackdropTemplate")
    optionsFrame:SetSize(400, 550)
    optionsFrame:SetPoint("CENTER")
    optionsFrame:SetMovable(true)
    optionsFrame:EnableMouse(true)
    optionsFrame:RegisterForDrag("LeftButton")
    optionsFrame:SetScript("OnDragStart", optionsFrame.StartMoving)
    optionsFrame:SetScript("OnDragStop", optionsFrame.StopMovingOrSizing)
    optionsFrame:SetFrameStrata("DIALOG")

    optionsFrame.backdropInfo = {
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    }
    optionsFrame:ApplyBackdrop()

    -- Title
    local title = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    title:SetPoint("TOP", 0, -20)
    title:SetText(L.SETTINGS_TITLE)

    -- Close button
    local closeBtn = CreateFrame("Button", nil, optionsFrame, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", -5, -5)

    -- Content area
    local yOffset = -50
    local xLeft = 20

    -- === Auto-Sell Section ===
    local sellHeader = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    sellHeader:SetPoint("TOPLEFT", xLeft, yOffset)
    sellHeader:SetText("|cFFFFD100" .. L.SECTION_AUTOSELL .. "|r")
    yOffset = yOffset - 25

    optionsFrame.cbAutoSell = self:CreateCheckbox(optionsFrame, xLeft, yOffset, L.ENABLE_AUTOSELL, "autoSellEnabled")
    yOffset = yOffset - 25
    optionsFrame.cbSellPoor = self:CreateCheckbox(optionsFrame, xLeft + 20, yOffset, L.SELL_POOR_LABEL, "sellPoor")
    yOffset = yOffset - 25
    optionsFrame.cbSellCommon = self:CreateCheckbox(optionsFrame, xLeft + 20, yOffset, L.SELL_COMMON_LABEL, "sellCommon")
    yOffset = yOffset - 25
    optionsFrame.cbSellUncommon = self:CreateCheckbox(optionsFrame, xLeft + 20, yOffset, L.SELL_UNCOMMON_LABEL, "sellUncommon")
    yOffset = yOffset - 35

    optionsFrame.sliderSellIlvl = self:CreateSlider(optionsFrame, xLeft + 20, yOffset, L.SELL_BELOW_ILVL_LABEL, "sellBelowIlvl", 0, 500, 5)
    yOffset = yOffset - 45
    optionsFrame.cbProtectUnbound = self:CreateCheckbox(optionsFrame, xLeft + 20, yOffset, L.PROTECT_UNBOUND_LABEL, "protectUnbound")
    yOffset = yOffset - 30

    -- === Disenchant Section ===
    local deHeader = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    deHeader:SetPoint("TOPLEFT", xLeft, yOffset)
    deHeader:SetText("|cFFFFD100" .. L.SECTION_DISENCHANT .. "|r")
    yOffset = yOffset - 25

    optionsFrame.cbDE = self:CreateCheckbox(optionsFrame, xLeft, yOffset, L.ENABLE_DE, "deMarkEnabled")
    yOffset = yOffset - 35

    optionsFrame.sliderDEMin = self:CreateSlider(optionsFrame, xLeft + 20, yOffset, L.DE_MIN_QUALITY_LABEL, "deMinQuality", 2, 4, 1)
    yOffset = yOffset - 45
    optionsFrame.sliderDEMax = self:CreateSlider(optionsFrame, xLeft + 20, yOffset, L.DE_MAX_QUALITY_LABEL, "deMaxQuality", 2, 4, 1)
    yOffset = yOffset - 45
    optionsFrame.sliderDEIlvl = self:CreateSlider(optionsFrame, xLeft + 20, yOffset, L.DE_BELOW_ILVL_LABEL, "deBelowIlvl", 0, 500, 5)
    yOffset = yOffset - 50

    -- === Lists Section ===
    local listHeader = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    listHeader:SetPoint("TOPLEFT", xLeft, yOffset)
    listHeader:SetText("|cFFFFD100" .. L.SECTION_LISTS .. "|r")
    yOffset = yOffset - 20

    optionsFrame.keepCountText = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    optionsFrame.keepCountText:SetPoint("TOPLEFT", xLeft + 10, yOffset)
    yOffset = yOffset - 15

    optionsFrame.sellCountText = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    optionsFrame.sellCountText:SetPoint("TOPLEFT", xLeft + 10, yOffset)
    yOffset = yOffset - 20

    local helpText = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    helpText:SetPoint("TOPLEFT", xLeft + 10, yOffset)
    helpText:SetWidth(340)
    helpText:SetJustifyH("LEFT")
    helpText:SetText(L.LIST_HELP)

    -- ESC to close
    table.insert(UISpecialFrames, "PocketKondoOptionsFrame")
end

function UI:RefreshOptionsPanel()
    if not optionsFrame then return end

    local L = GetL()
    local db = ns.db

    optionsFrame.cbAutoSell:SetChecked(db.autoSellEnabled)
    optionsFrame.cbSellPoor:SetChecked(db.sellPoor)
    optionsFrame.cbSellCommon:SetChecked(db.sellCommon)
    optionsFrame.cbSellUncommon:SetChecked(db.sellUncommon)
    optionsFrame.sliderSellIlvl:SetValue(db.sellBelowIlvl)
    optionsFrame.cbProtectUnbound:SetChecked(db.protectUnbound)
    optionsFrame.cbDE:SetChecked(db.deMarkEnabled)
    optionsFrame.sliderDEMin:SetValue(db.deMinQuality)
    optionsFrame.sliderDEMax:SetValue(db.deMaxQuality)
    optionsFrame.sliderDEIlvl:SetValue(db.deBelowIlvl)

    local keepCount = 0
    for _ in pairs(db.keepList) do keepCount = keepCount + 1 end
    local sellCount = 0
    for _ in pairs(db.sellList) do sellCount = sellCount + 1 end

    optionsFrame.keepCountText:SetText(string.format(L.KEEP_LIST_COUNT, keepCount))
    optionsFrame.sellCountText:SetText(string.format(L.SELL_LIST_COUNT, sellCount))
end

-- ========================================
-- UI Element Helpers
-- ========================================

function UI:CreateCheckbox(parent, x, y, label, dbKey)
    local cb = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
    cb:SetPoint("TOPLEFT", x, y)
    cb.Text:SetText(label)
    cb.Text:SetFontObject("GameFontHighlight")

    cb:SetScript("OnClick", function(self)
        ns.db[dbKey] = self:GetChecked()
        if dbKey == "deMarkEnabled" then
            if ns.db.deMarkEnabled then
                ns.Disenchant:UpdateOverlays()
            else
                ns.Disenchant:ClearAllOverlays()
            end
        end
    end)

    return cb
end

function UI:CreateSlider(parent, x, y, label, dbKey, min, max, step)
    local container = CreateFrame("Frame", nil, parent)
    container:SetSize(320, 40)
    container:SetPoint("TOPLEFT", x, y)

    local text = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("TOPLEFT", 0, 0)
    text:SetText(label)

    local slider = CreateFrame("Slider", nil, container, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", 0, -18)
    slider:SetSize(280, 17)
    slider:SetMinMaxValues(min, max)
    slider:SetValueStep(step)
    slider:SetObeyStepOnDrag(true)

    slider.Low:SetText(tostring(min))
    slider.High:SetText(tostring(max))

    local valueText = container:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    valueText:SetPoint("TOP", slider, "BOTTOM", 0, -2)

    slider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value / step + 0.5) * step
        ns.db[dbKey] = value
        if dbKey == "deMinQuality" or dbKey == "deMaxQuality" then
            valueText:SetText(ns:GetQualityName(value))
        else
            valueText:SetText(tostring(value))
        end
    end)

    container.SetValue = function(self, v)
        slider:SetValue(v)
    end
    container.GetValue = function(self)
        return slider:GetValue()
    end

    return container
end
