local addonName, ns = ...
local Disenchant = ns.Disenchant

Disenchant.overlays = {}

-- Tooltip hook for disenchant marking
local function OnTooltipSetItem(tooltip)
    if not ns.db or not ns.db.deMarkEnabled then return end

    local _, itemLink = tooltip:GetItem()
    if not itemLink then return end

    local itemID = C_Item.GetItemInfoInstant(itemLink)
    if not itemID then return end

    -- Build a minimal item details table for rule check
    local itemName, _, quality, itemLevel, _, _, _, _, _, _, _, classID, subclassID = C_Item.GetItemInfo(itemID)
    if not itemName then return end

    local item = {
        itemID = itemID,
        quality = quality,
        itemLevel = itemLevel,
        classID = classID,
        subclassID = subclassID,
    }

    if ns.Rules:ShouldMarkDE(item) then
        tooltip:AddLine(" ")
        tooltip:AddLine(ns.L.DE_TOOLTIP, 1, 0.5, 0) -- orange
        tooltip:Show()
    end
end

-- Hook the tooltip on first load
local tooltipHooked = false
function Disenchant:HookTooltip()
    if tooltipHooked then return end
    tooltipHooked = true

    if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
            OnTooltipSetItem(tooltip)
        end)
    else
        GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
    end
end

-- Update bag slot overlays
function Disenchant:UpdateOverlays()
    self:HookTooltip()

    -- Clear all existing overlays first
    for _, overlay in pairs(self.overlays) do
        overlay:Hide()
    end

    if not ns.db or not ns.db.deMarkEnabled then return end

    for bag = 0, 4 do
        local numSlots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, numSlots do
            local item = ns:GetItemDetails(bag, slot)
            if item and ns.Rules:ShouldMarkDE(item) then
                self:ShowOverlay(bag, slot)
            end
        end
    end
end

function Disenchant:ShowOverlay(bag, slot)
    local button = self:GetBagSlotButton(bag, slot)
    if not button then return end

    local key = bag .. ":" .. slot
    local overlay = self.overlays[key]

    if not overlay then
        overlay = button:CreateTexture(nil, "OVERLAY")
        overlay:SetSize(16, 16)
        overlay:SetPoint("TOPRIGHT", button, "TOPRIGHT", -2, -2)
        overlay:SetTexture(136222) -- Disenchant spell icon
        overlay:SetVertexColor(1, 0.5, 0, 0.9)
        self.overlays[key] = overlay
    end

    overlay:Show()
end

function Disenchant:GetBagSlotButton(bag, slot)
    -- Try the modern container frame approach
    if ContainerFrameUtil_GetItemButtonAndContainer then
        local button = ContainerFrameUtil_GetItemButtonAndContainer(bag, slot)
        if button then return button end
    end

    -- Fallback: try direct frame name lookup
    local frameName
    if bag == 0 then
        frameName = "ContainerFrame1Item" .. slot
    else
        frameName = "ContainerFrame" .. (bag + 1) .. "Item" .. slot
    end

    return _G[frameName]
end

function Disenchant:ClearAllOverlays()
    for _, overlay in pairs(self.overlays) do
        overlay:Hide()
    end
end
