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

function AutoSell:OnMerchantShow()
    if not ns.db.autoSellEnabled then return end

    self.cancelled = false
    self:BuildSellQueue()

    if #self.sellQueue == 0 then
        return
    end

    self:ProcessQueue()
end

function AutoSell:OnMerchantClosed()
    self.cancelled = true
    self.isSelling = false
    wipe(self.sellQueue)
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
