local addonName, ns = ...

-- English (default)
local L = {
    -- General
    LOADED = "loaded. Type /bc for options.",
    STATUS_HEADER = "--- BagCleaner Status ---",

    -- Auto-Sell
    AUTOSELL_ENABLED = "Auto-sell: |cFF00FF00enabled|r",
    AUTOSELL_DISABLED = "Auto-sell: |cFFFF0000disabled|r",
    AUTOSELL_TOGGLED_ON = "Auto-sell |cFF00FF00enabled|r.",
    AUTOSELL_TOGGLED_OFF = "Auto-sell |cFFFF0000disabled|r.",
    SELL_POOR = "Sell Poor (grey): ",
    SELL_COMMON = "Sell Common (white): ",
    SELL_UNCOMMON = "Sell Uncommon (green): ",
    SELL_BELOW_ILVL = "Sell gear below ilvl: ",
    SOLD_SUMMARY = "Sold %d item(s) for %s.",
    SOLD_NOTHING = "Nothing to sell.",

    -- Disenchant
    DE_ENABLED = "Disenchant marking: |cFF00FF00enabled|r",
    DE_DISABLED = "Disenchant marking: |cFFFF0000disabled|r",
    DE_TOOLTIP = "BagCleaner: Disenchant",
    DE_QUALITY_RANGE = "DE quality range: %s - %s",

    -- Lists
    KEEP_LIST = "Keep list",
    SELL_LIST = "Sell list",
    LIST_EMPTY = "  (empty)",
    ITEM_ADDED_KEEP = "%s added to keep list.",
    ITEM_REMOVED_KEEP = "%s removed from keep list.",
    ITEM_ADDED_SELL = "%s added to sell list.",
    ITEM_REMOVED_SELL = "%s removed from sell list.",
    ITEM_NOT_FOUND = "Item not found. Please shift-click an item to link it.",

    -- Quality names
    QUALITY_POOR = "Poor",
    QUALITY_COMMON = "Common",
    QUALITY_UNCOMMON = "Uncommon",
    QUALITY_RARE = "Rare",
    QUALITY_EPIC = "Epic",

    -- UI
    SETTINGS_TITLE = "BagCleaner Settings",
    SECTION_AUTOSELL = "Auto-Sell",
    SECTION_DISENCHANT = "Disenchant Marking",
    SECTION_LISTS = "Item Lists",
    ENABLE_AUTOSELL = "Enable auto-sell at vendor",
    SELL_POOR_LABEL = "Sell Poor (grey) items",
    SELL_COMMON_LABEL = "Sell Common (white) items",
    SELL_UNCOMMON_LABEL = "Sell Uncommon (green) items",
    SELL_BELOW_ILVL_LABEL = "Sell gear below item level (0 = off)",
    ENABLE_DE = "Enable disenchant marking",
    DE_MIN_QUALITY_LABEL = "Minimum quality to mark",
    DE_MAX_QUALITY_LABEL = "Maximum quality to mark",
    DE_BELOW_ILVL_LABEL = "Mark gear below item level (0 = off)",
    KEEP_LIST_COUNT = "Keep list: %d item(s)",
    SELL_LIST_COUNT = "Sell list: %d item(s)",
    LIST_HELP = "Use /bc keep <itemlink> and /bc sell-add <itemlink> to manage lists.",

    -- Slash command help
    HELP_HEADER = "--- BagCleaner Commands ---",
    HELP_OPTIONS = "/bc - Open settings",
    HELP_STATUS = "/bc status - Show current settings",
    HELP_SELL = "/bc sell - Toggle auto-sell",
    HELP_DE = "/bc de - Toggle disenchant marking",
    HELP_KEEP = "/bc keep <itemlink> - Add item to keep list",
    HELP_SELL_ADD = "/bc sell-add <itemlink> - Add item to sell list",
    HELP_KEEP_REMOVE = "/bc keep-remove <itemlink> - Remove from keep list",
    HELP_SELL_REMOVE = "/bc sell-remove <itemlink> - Remove from sell list",
    HELP_LIST = "/bc list - Show keep and sell lists",

    -- Boolean display
    YES = "|cFF00FF00yes|r",
    NO = "|cFFFF0000no|r",
    DISABLED = "disabled",
}

ns.L = L

-- German localization
if GetLocale() == "deDE" then
    L.LOADED = "geladen. /bc für Optionen."
    L.STATUS_HEADER = "--- BagCleaner Status ---"

    L.AUTOSELL_ENABLED = "Auto-Verkauf: |cFF00FF00aktiviert|r"
    L.AUTOSELL_DISABLED = "Auto-Verkauf: |cFFFF0000deaktiviert|r"
    L.AUTOSELL_TOGGLED_ON = "Auto-Verkauf |cFF00FF00aktiviert|r."
    L.AUTOSELL_TOGGLED_OFF = "Auto-Verkauf |cFFFF0000deaktiviert|r."
    L.SELL_POOR = "Schlechte (graue) Items verkaufen: "
    L.SELL_COMMON = "Gewöhnliche (weiße) Items verkaufen: "
    L.SELL_UNCOMMON = "Ungewöhnliche (grüne) Items verkaufen: "
    L.SELL_BELOW_ILVL = "Ausrüstung unter Gegenstandsstufe verkaufen: "
    L.SOLD_SUMMARY = "%d Gegenstand/Gegenstände für %s verkauft."
    L.SOLD_NOTHING = "Nichts zu verkaufen."

    L.DE_ENABLED = "Entzauber-Markierung: |cFF00FF00aktiviert|r"
    L.DE_DISABLED = "Entzauber-Markierung: |cFFFF0000deaktiviert|r"
    L.DE_TOOLTIP = "BagCleaner: Entzaubern"
    L.DE_QUALITY_RANGE = "Entzauber-Qualität: %s - %s"

    L.KEEP_LIST = "Behalten-Liste"
    L.SELL_LIST = "Verkaufen-Liste"
    L.LIST_EMPTY = "  (leer)"
    L.ITEM_ADDED_KEEP = "%s zur Behalten-Liste hinzugefügt."
    L.ITEM_REMOVED_KEEP = "%s von der Behalten-Liste entfernt."
    L.ITEM_ADDED_SELL = "%s zur Verkaufen-Liste hinzugefügt."
    L.ITEM_REMOVED_SELL = "%s von der Verkaufen-Liste entfernt."
    L.ITEM_NOT_FOUND = "Gegenstand nicht gefunden. Bitte Shift-Klick auf einen Gegenstand."

    L.QUALITY_POOR = "Schlecht"
    L.QUALITY_COMMON = "Gewöhnlich"
    L.QUALITY_UNCOMMON = "Ungewöhnlich"
    L.QUALITY_RARE = "Selten"
    L.QUALITY_EPIC = "Episch"

    L.SETTINGS_TITLE = "BagCleaner Einstellungen"
    L.SECTION_AUTOSELL = "Auto-Verkauf"
    L.SECTION_DISENCHANT = "Entzauber-Markierung"
    L.SECTION_LISTS = "Gegenstandslisten"
    L.ENABLE_AUTOSELL = "Auto-Verkauf beim Händler aktivieren"
    L.SELL_POOR_LABEL = "Schlechte (graue) Gegenstände verkaufen"
    L.SELL_COMMON_LABEL = "Gewöhnliche (weiße) Gegenstände verkaufen"
    L.SELL_UNCOMMON_LABEL = "Ungewöhnliche (grüne) Gegenstände verkaufen"
    L.SELL_BELOW_ILVL_LABEL = "Ausrüstung unter Gegenstandsstufe verkaufen (0 = aus)"
    L.ENABLE_DE = "Entzauber-Markierung aktivieren"
    L.DE_MIN_QUALITY_LABEL = "Mindestqualität zum Markieren"
    L.DE_MAX_QUALITY_LABEL = "Höchstqualität zum Markieren"
    L.DE_BELOW_ILVL_LABEL = "Ausrüstung unter Gegenstandsstufe markieren (0 = aus)"
    L.KEEP_LIST_COUNT = "Behalten-Liste: %d Gegenstand/Gegenstände"
    L.SELL_LIST_COUNT = "Verkaufen-Liste: %d Gegenstand/Gegenstände"
    L.LIST_HELP = "Benutze /bc keep <Itemlink> und /bc sell-add <Itemlink> zur Listenverwaltung."

    L.HELP_HEADER = "--- BagCleaner Befehle ---"
    L.HELP_OPTIONS = "/bc - Einstellungen öffnen"
    L.HELP_STATUS = "/bc status - Aktuelle Einstellungen anzeigen"
    L.HELP_SELL = "/bc sell - Auto-Verkauf umschalten"
    L.HELP_DE = "/bc de - Entzauber-Markierung umschalten"
    L.HELP_KEEP = "/bc keep <Itemlink> - Gegenstand zur Behalten-Liste hinzufügen"
    L.HELP_SELL_ADD = "/bc sell-add <Itemlink> - Gegenstand zur Verkaufen-Liste hinzufügen"
    L.HELP_KEEP_REMOVE = "/bc keep-remove <Itemlink> - Von der Behalten-Liste entfernen"
    L.HELP_SELL_REMOVE = "/bc sell-remove <Itemlink> - Von der Verkaufen-Liste entfernen"
    L.HELP_LIST = "/bc list - Behalten- und Verkaufen-Listen anzeigen"

    L.YES = "|cFF00FF00ja|r"
    L.NO = "|cFFFF0000nein|r"
    L.DISABLED = "deaktiviert"
end

-- Quality name lookup helper
function ns:GetQualityName(quality)
    local names = {
        [0] = L.QUALITY_POOR,
        [1] = L.QUALITY_COMMON,
        [2] = L.QUALITY_UNCOMMON,
        [3] = L.QUALITY_RARE,
        [4] = L.QUALITY_EPIC,
    }
    return names[quality] or tostring(quality)
end
