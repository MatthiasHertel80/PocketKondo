local addonName, ns = ...
local AutoSell = ns.AutoSell
local L

-- Lazy-load locale reference
local function GetL()
    if not L then L = ns.L end
    return L
end

AutoSell.sellQueue = {}
AutoSell.isSelling = false
AutoSell.cancelled = false

-- ========================================
-- Custom Confirm Dialog
-- ========================================
local confirmFrame = nil

local function CreateConfirmFrame()
    local L = GetL()

    local frame = CreateFrame("Frame", "PocketKondoConfirmFrame", UIParent, "BackdropTemplate")
    frame:SetSize(360, 300)
    frame:SetPoint("CENTER", 0, 100)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetFrameStrata("DIALOG")
    frame:SetFrameLevel(100)

    frame.backdropInfo = {
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    }
    frame:ApplyBackdrop()

    -- Title
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    title:SetPoint("TOP", 0, -18)
    title:SetText("|cFFFF69B4PocketKondo|r")
    frame.title = title

    -- Subtitle (item count + total gold)
    local subtitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    subtitle:SetPoint("TOP", title, "BOTTOM", 0, -6)
    frame.subtitle = subtitle

    -- Scroll frame for item list
    local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 18, -60)
    scrollFrame:SetPoint("BOTTOMRIGHT", -36, 50)

    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(280, 1) -- height grows dynamically
    scrollFrame:SetScrollChild(scrollChild)
    frame.scrollChild = scrollChild
    frame.itemLines = {}

    -- Total line
    local totalLine = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    totalLine:SetPoint("BOTTOMLEFT", 20, 52)
    frame.totalLine = totalLine

    -- Sell button
    local sellBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    sellBtn:SetSize(100, 24)
    sellBtn:SetPoint("BOTTOMRIGHT", -80, 16)
    sellBtn:SetText(L.CONFIRM_SELL_BTN)
    sellBtn:SetScript("OnClick", function()
        frame:Hide()
        ns.AutoSell:ProcessQueue()
    end)

    -- Cancel button
    local cancelBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    cancelBtn:SetSize(100, 24)
    cancelBtn:SetPoint("BOTTOMRIGHT", -180, 16)
    cancelBtn:SetText(CANCEL)
    cancelBtn:SetScript("OnClick", function()
        frame:Hide()
        wipe(ns.AutoSell.sellQueue)
    end)

    -- ESC to close
    table.insert(UISpecialFrames, "PocketKondoConfirmFrame")

    frame:Hide()
    return frame
end

function AutoSell:ShowConfirmDialog()
    local L = GetL()

    if not confirmFrame then
        confirmFrame = CreateConfirmFrame()
    end

    -- Clear old item lines
    for _, line in ipairs(confirmFrame.itemLines) do
        line:Hide()
    end
    wipe(confirmFrame.itemLines)

    local totalCopper = 0
    local itemCount = #self.sellQueue
    local yOffset = 0
    local lineHeight = 16

    for i = 1, itemCount do
        local entry = self.sellQueue[i]
        totalCopper = totalCopper + entry.price

        local line = confirmFrame.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        line:SetPoint("TOPLEFT", 4, -yOffset)
        line:SetWidth(270)
        line:SetJustifyH("LEFT")

        local priceStr = ns:FormatMoney(entry.price)
        line:SetText((entry.link or entry.name) .. "  |cFFFFD100" .. priceStr .. "|r")
        line:Show()

        table.insert(confirmFrame.itemLines, line)
        yOffset = yOffset + lineHeight
    end

    confirmFrame.scrollChild:SetHeight(math.max(yOffset, 1))

    -- Resize frame based on item count (min 200, max 400)
    local contentHeight = math.min(math.max(itemCount * lineHeight + 120, 200), 400)
    confirmFrame:SetSize(360, contentHeight)

    -- Update texts
    local totalStr = ns:FormatMoney(totalCopper)
    confirmFrame.subtitle:SetText(string.format(L.CONFIRM_SELL_HEADER, itemCount, totalStr))
    confirmFrame.totalLine:SetText("|cFFFFD100" .. L.CONFIRM_TOTAL .. ": " .. totalStr .. "|r")

    confirmFrame:Show()
end

-- ========================================
-- Sell Logic
-- ========================================

function AutoSell:OnMerchantShow()
    if not ns.db.autoSellEnabled then return end

    self.cancelled = false
    self:BuildSellQueue()

    if #self.sellQueue == 0 then
        return
    end

    if ns.db.confirmBeforeSell then
        self:ShowConfirmDialog()
    else
        self:ProcessQueue()
    end
end

function AutoSell:OnMerchantClosed()
    self.cancelled = true
    self.isSelling = false
    wipe(self.sellQueue)
    if confirmFrame then
        confirmFrame:Hide()
    end
end

function AutoSell:BuildSellQueue()
    wipe(self.sellQueue)

    for bag = 0, 4 do
        local numSlots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, numSlots do
            local item = ns:GetItemDetails(bag, slot)
            if item and ns.Rules:ShouldSell(item) then
                table.insert(self.sellQueue, {
                    bag = bag,
                    slot = slot,
                    link = item.itemLink,
                    price = (item.sellPrice or 0) * (item.stackCount or 1),
                    name = item.name,
                })
            end
        end
    end
end

function AutoSell:ProcessQueue()
    local L = GetL()
    self.isSelling = true
    local totalSold = 0
    local totalCopper = 0
    local index = 0

    local function SellNext()
        if self.cancelled then
            self.isSelling = false
            return
        end

        index = index + 1
        if index > #self.sellQueue then
            -- All done
            self.isSelling = false
            if totalSold > 0 then
                ns:Print(string.format(L.SOLD_SUMMARY, totalSold, ns:FormatMoney(totalCopper)))
            end
            wipe(self.sellQueue)
            return
        end

        local entry = self.sellQueue[index]
        C_Container.UseContainerItem(entry.bag, entry.slot)
        totalSold = totalSold + 1
        totalCopper = totalCopper + entry.price

        C_Timer.After(ns.db.sellDelay, SellNext)
    end

    SellNext()
end
