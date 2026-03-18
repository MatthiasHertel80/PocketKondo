local addonName, ns = ...

-- Minimap button (standalone, no lib dependencies)
local ICON_TEXTURE = "Interface\\Icons\\INV_Enchant_Disenchant"
local BUTTON_SIZE = 33
local BORDER_SIZE = 54

local button = CreateFrame("Button", "PocketKondoMinimapButton", Minimap)
button:SetSize(BUTTON_SIZE, BUTTON_SIZE)
button:SetFrameStrata("MEDIUM")
button:SetFrameLevel(8)
button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
button:SetMovable(true)
button:RegisterForClicks("AnyUp")
button:RegisterForDrag("LeftButton")
button:Hide() -- hidden until InitMinimapButton is called

-- Icon
local icon = button:CreateTexture(nil, "BACKGROUND")
icon:SetTexture(ICON_TEXTURE)
icon:SetSize(20, 20)
icon:SetPoint("CENTER")
button.icon = icon

-- Border overlay
local border = button:CreateTexture(nil, "OVERLAY")
border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
border:SetSize(BORDER_SIZE, BORDER_SIZE)
border:SetPoint("TOPLEFT")
button.border = border

-- Position around minimap
local function UpdatePosition(angle)
    local rad = math.rad(angle)
    local x = math.cos(rad) * 80
    local y = math.sin(rad) * 80
    button:ClearAllPoints()
    button:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

-- Dragging
button:SetScript("OnDragStart", function(self)
    self:SetScript("OnUpdate", function(self)
        if not ns.db then return end
        local mx, my = Minimap:GetCenter()
        local cx, cy = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        cx, cy = cx / scale, cy / scale
        local angle = math.deg(math.atan2(cy - my, cx - mx))
        ns.db.minimapAngle = angle
        UpdatePosition(angle)
    end)
end)

button:SetScript("OnDragStop", function(self)
    self:SetScript("OnUpdate", nil)
end)

-- Click handlers
button:SetScript("OnClick", function(self, btn)
    if btn == "LeftButton" then
        ns.UI:ToggleOptionsPanel()
    elseif btn == "RightButton" then
        ns.db.autoSellEnabled = not ns.db.autoSellEnabled
        local L = ns.L
        ns:Print(ns.db.autoSellEnabled and L.AUTOSELL_TOGGLED_ON or L.AUTOSELL_TOGGLED_OFF)
    end
end)

-- Tooltip
button:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("|cFFFF69B4PocketKondo|r")
    GameTooltip:AddLine(ns.L.MINIMAP_TOOLTIP_LEFT, 1, 1, 1)
    GameTooltip:AddLine(ns.L.MINIMAP_TOOLTIP_RIGHT, 1, 1, 1)
    GameTooltip:Show()
end)

button:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

-- Initialize after DB is ready
function ns:InitMinimapButton()
    if self.db.minimapAngle == nil then
        self.db.minimapAngle = 220
    end
    if self.db.showMinimapButton == nil then
        self.db.showMinimapButton = true
    end
    UpdatePosition(self.db.minimapAngle)
    if self.db.showMinimapButton then
        button:Show()
    else
        button:Hide()
    end
end

function ns:ToggleMinimapButton()
    self.db.showMinimapButton = not self.db.showMinimapButton
    if self.db.showMinimapButton then
        button:Show()
    else
        button:Hide()
    end
end
