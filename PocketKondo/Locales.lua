local addonName, ns = ...

-- English (default)
local L = {
    -- General
    LOADED = "loaded. Does your loot spark joy? Type /pk for options.",
    STATUS_HEADER = "--- PocketKondo Status ---",

    -- Auto-Sell
    AUTOSELL_ENABLED = "Auto-sell: |cFF00FF00enabled|r",
    AUTOSELL_DISABLED = "Auto-sell: |cFFFF0000disabled|r",
    AUTOSELL_TOGGLED_ON = "Auto-sell |cFF00FF00enabled|r. Joyless items will be sold!",
    AUTOSELL_TOGGLED_OFF = "Auto-sell |cFFFF0000disabled|r.",
    SELL_POOR = "Sell Poor (grey): ",
    SELL_COMMON = "Sell Common (white): ",
    SELL_UNCOMMON = "Sell Uncommon (green): ",
    SELL_BELOW_ILVL = "Sell gear below ilvl: ",
    SOLD_SUMMARY = "Tidied up! Sold %d joyless item(s) for %s.",
    SOLD_NOTHING = "Your bags already spark joy!",
    CONFIRM_SELL_HEADER = "Sell %d item(s) for %s?",
    CONFIRM_SELL_BTN = "Sell",
    CONFIRM_TOTAL = "Total",
    MINIMAP_TOOLTIP_LEFT = "Left-click: Open settings",
    MINIMAP_TOOLTIP_RIGHT = "Right-click: Toggle auto-sell",

    -- Disenchant
    DE_ENABLED = "Disenchant marking: |cFF00FF00enabled|r",
    DE_DISABLED = "Disenchant marking: |cFFFF0000disabled|r",
    DE_TOOLTIP = "PocketKondo: Does not spark joy - Disenchant!",
    DE_QUALITY_RANGE = "DE quality range: %s - %s",

    -- Lists
    KEEP_LIST = "Sparks Joy (keep list)",
    SELL_LIST = "Does Not Spark Joy (sell list)",
    LIST_EMPTY = "  (empty)",
    ITEM_ADDED_KEEP = "%s sparks joy! Added to keep list.",
    ITEM_REMOVED_KEEP = "%s removed from keep list.",
    ITEM_ADDED_SELL = "%s does not spark joy. Added to sell list.",
    ITEM_REMOVED_SELL = "%s removed from sell list.",
    ITEM_NOT_FOUND = "Item not found. Please shift-click an item to link it.",

    -- Quality names
    QUALITY_POOR = "Poor",
    QUALITY_COMMON = "Common",
    QUALITY_UNCOMMON = "Uncommon",
    QUALITY_RARE = "Rare",
    QUALITY_EPIC = "Epic",

    -- Expansion names
    EXP_CLASSIC = "Classic",
    EXP_BC = "The Burning Crusade",
    EXP_WRATH = "Wrath of the Lich King",
    EXP_CATA = "Cataclysm",
    EXP_MOP = "Mists of Pandaria",
    EXP_WOD = "Warlords of Draenor",
    EXP_LEGION = "Legion",
    EXP_BFA = "Battle for Azeroth",
    EXP_SL = "Shadowlands",
    EXP_DF = "Dragonflight",
    EXP_TWW = "The War Within",
    EXP_MIDNIGHT = "Midnight",

    -- UI Labels
    SETTINGS_TITLE = "PocketKondo - The KonMari Method for Your Bags",
    SECTION_AUTOSELL = "Auto-Sell (Tidying Up)",
    SECTION_DISENCHANT = "Disenchant Marking (Transform)",
    SECTION_EXPANSIONS = "Expansion Filter (Sell All Items From)",
    SECTION_LISTS = "Joy Lists",
    ENABLE_AUTOSELL = "Enable auto-sell at vendor",
    SELL_POOR_LABEL = "Sell Poor (grey) items",
    SELL_COMMON_LABEL = "Sell Common (white) items",
    SELL_UNCOMMON_LABEL = "Sell Uncommon (green) items",
    SELL_BELOW_ILVL_LABEL = "Sell gear below item level (0 = off)",
    PROTECT_UNBOUND_LABEL = "Protect non-soulbound gear",
    CONFIRM_SELL_LABEL = "Confirm before selling",
    MARK_LEARNABLES_LABEL = "Mark learnable items in bags",
    EXPANSION_HELP = "Check expansions to sell all their items at vendor.",
    ENABLE_DE = "Enable disenchant marking",
    DE_MIN_QUALITY_LABEL = "Minimum quality to mark",
    DE_MAX_QUALITY_LABEL = "Maximum quality to mark",
    DE_BELOW_ILVL_LABEL = "Mark gear below item level (0 = off)",
    KEEP_LIST_COUNT = "Sparks Joy: %d item(s)",
    SELL_LIST_COUNT = "Does Not Spark Joy: %d item(s)",
    LIST_HELP = "Use /pk keep <itemlink> and /pk sell-add <itemlink> to manage lists.",

    -- Tooltips for Settings panel
    TOOLTIP_AUTOSELL = "Automatically sell items matching your rules when visiting a vendor.",
    TOOLTIP_SELL_POOR = "Sell grey quality items - no joy here!",
    TOOLTIP_SELL_COMMON = "Sell white quality items at the vendor.",
    TOOLTIP_SELL_UNCOMMON = "Sell green quality items at the vendor.",
    TOOLTIP_SELL_ILVL = "Sell equipment below this item level. Set to 0 to disable.",
    TOOLTIP_PROTECT_UNBOUND = "Prevent selling equipment that is not soulbound. Keeps tradeable items safe from accidental sales.",
    TOOLTIP_CONFIRM_SELL = "Show a confirmation dialog listing all items before selling.",
    TOOLTIP_MARK_LEARNABLES = "Show a green icon on one-time learnable items (recipes, companion pets, mounts, toys) so you can learn them and free bag space.",
    TOOLTIP_DE = "Mark items in your bags for disenchanting with a visual overlay.",
    TOOLTIP_DE_MIN = "Minimum item quality to mark for disenchanting.",
    TOOLTIP_DE_MAX = "Maximum item quality to mark for disenchanting.",
    TOOLTIP_DE_ILVL = "Only mark equipment below this item level. Set to 0 to disable.",
    TOOLTIP_EXPANSION = "Sell all items from %s at the vendor.",

    -- Slash command help
    HELP_HEADER = "--- PocketKondo Commands ---",
    HELP_OPTIONS = "/pk - Open settings",
    HELP_STATUS = "/pk status - Show current settings",
    HELP_SELL = "/pk sell - Toggle auto-sell",
    HELP_DE = "/pk de - Toggle disenchant marking",
    HELP_KEEP = "/pk keep <itemlink> - This item sparks joy!",
    HELP_SELL_ADD = "/pk sell-add <itemlink> - This item does not spark joy",
    HELP_KEEP_REMOVE = "/pk keep-remove <itemlink> - Remove from joy list",
    HELP_SELL_REMOVE = "/pk sell-remove <itemlink> - Remove from sell list",
    HELP_LIST = "/pk list - Show joy and sell lists",

    -- Boolean display
    YES = "|cFF00FF00yes|r",
    NO = "|cFFFF0000no|r",
    DISABLED = "disabled",
}

ns.L = L

-- German localization
if GetLocale() == "deDE" then
    L.LOADED = "geladen. Macht dein Loot Freude? /pk fuer Optionen."
    L.STATUS_HEADER = "--- PocketKondo Status ---"

    L.AUTOSELL_ENABLED = "Auto-Verkauf: |cFF00FF00aktiviert|r"
    L.AUTOSELL_DISABLED = "Auto-Verkauf: |cFFFF0000deaktiviert|r"
    L.AUTOSELL_TOGGLED_ON = "Auto-Verkauf |cFF00FF00aktiviert|r. Freudlose Items werden verkauft!"
    L.AUTOSELL_TOGGLED_OFF = "Auto-Verkauf |cFFFF0000deaktiviert|r."
    L.SELL_POOR = "Schlechte (graue) Items verkaufen: "
    L.SELL_COMMON = "Gewoehnliche (weisse) Items verkaufen: "
    L.SELL_UNCOMMON = "Ungewoehnliche (gruene) Items verkaufen: "
    L.SELL_BELOW_ILVL = "Ausruestung unter Gegenstandsstufe verkaufen: "
    L.SOLD_SUMMARY = "Aufgeraeumt! %d freudlose(n) Gegenstand/Gegenstaende fuer %s verkauft."
    L.SOLD_NOTHING = "Deine Taschen machen bereits Freude!"
    L.CONFIRM_SELL_HEADER = "%d Gegenstand/Gegenstaende fuer %s verkaufen?"
    L.CONFIRM_SELL_BTN = "Verkaufen"
    L.CONFIRM_TOTAL = "Gesamt"
    L.MINIMAP_TOOLTIP_LEFT = "Linksklick: Einstellungen oeffnen"
    L.MINIMAP_TOOLTIP_RIGHT = "Rechtsklick: Auto-Verkauf umschalten"

    L.DE_ENABLED = "Entzauber-Markierung: |cFF00FF00aktiviert|r"
    L.DE_DISABLED = "Entzauber-Markierung: |cFFFF0000deaktiviert|r"
    L.DE_TOOLTIP = "PocketKondo: Macht keine Freude - Entzaubern!"
    L.DE_QUALITY_RANGE = "Entzauber-Qualitaet: %s - %s"

    L.KEEP_LIST = "Macht Freude (Behalten-Liste)"
    L.SELL_LIST = "Macht keine Freude (Verkaufen-Liste)"
    L.LIST_EMPTY = "  (leer)"
    L.ITEM_ADDED_KEEP = "%s macht Freude! Zur Behalten-Liste hinzugefuegt."
    L.ITEM_REMOVED_KEEP = "%s von der Behalten-Liste entfernt."
    L.ITEM_ADDED_SELL = "%s macht keine Freude. Zur Verkaufen-Liste hinzugefuegt."
    L.ITEM_REMOVED_SELL = "%s von der Verkaufen-Liste entfernt."
    L.ITEM_NOT_FOUND = "Gegenstand nicht gefunden. Bitte Shift-Klick auf einen Gegenstand."

    L.QUALITY_POOR = "Schlecht"
    L.QUALITY_COMMON = "Gewoehnlich"
    L.QUALITY_UNCOMMON = "Ungewoehnlich"
    L.QUALITY_RARE = "Selten"
    L.QUALITY_EPIC = "Episch"

    L.SETTINGS_TITLE = "PocketKondo - Die KonMari-Methode fuer deine Taschen"
    L.SECTION_AUTOSELL = "Auto-Verkauf (Aufraeumen)"
    L.SECTION_DISENCHANT = "Entzauber-Markierung (Verwandeln)"
    L.SECTION_EXPANSIONS = "Erweiterungsfilter (Alle Items verkaufen aus)"
    L.SECTION_LISTS = "Freude-Listen"
    L.ENABLE_AUTOSELL = "Auto-Verkauf beim Haendler aktivieren"
    L.SELL_POOR_LABEL = "Schlechte (graue) Gegenstaende verkaufen"
    L.SELL_COMMON_LABEL = "Gewoehnliche (weisse) Gegenstaende verkaufen"
    L.SELL_UNCOMMON_LABEL = "Ungewoehnliche (gruene) Gegenstaende verkaufen"
    L.SELL_BELOW_ILVL_LABEL = "Ausruestung unter Gegenstandsstufe verkaufen (0 = aus)"
    L.PROTECT_UNBOUND_LABEL = "Nicht-seelengebundene Ausruestung schuetzen"
    L.CONFIRM_SELL_LABEL = "Vor dem Verkaufen bestaetigen"
    L.MARK_LEARNABLES_LABEL = "Lernbare Items in Taschen markieren"
    L.EXPANSION_HELP = "Erweiterungen ankreuzen, um alle deren Items beim Haendler zu verkaufen."
    L.ENABLE_DE = "Entzauber-Markierung aktivieren"

    L.TOOLTIP_AUTOSELL = "Automatisch Items nach deinen Regeln beim Haendler verkaufen."
    L.TOOLTIP_SELL_POOR = "Graue Gegenstaende verkaufen - macht keine Freude!"
    L.TOOLTIP_SELL_COMMON = "Weisse Gegenstaende beim Haendler verkaufen."
    L.TOOLTIP_SELL_UNCOMMON = "Gruene Gegenstaende beim Haendler verkaufen."
    L.TOOLTIP_SELL_ILVL = "Ausruestung unter dieser Gegenstandsstufe verkaufen. 0 = deaktiviert."
    L.TOOLTIP_PROTECT_UNBOUND = "Verhindert den Verkauf von nicht-seelengebundener Ausruestung. Haelt handelbare Items sicher."
    L.TOOLTIP_CONFIRM_SELL = "Zeigt einen Bestaetigungsdialog mit allen Items vor dem Verkauf."
    L.TOOLTIP_MARK_LEARNABLES = "Zeigt ein gruenes Symbol auf einmalig lernbaren Items (Rezepte, Begleiter, Reittiere, Spielzeug), damit du sie lernen und Platz schaffen kannst."
    L.TOOLTIP_DE = "Markiert Items in deinen Taschen zum Entzaubern mit einem visuellen Overlay."
    L.TOOLTIP_DE_MIN = "Mindestqualitaet zum Markieren fuer Entzauberung."
    L.TOOLTIP_DE_MAX = "Hoechstqualitaet zum Markieren fuer Entzauberung."
    L.TOOLTIP_DE_ILVL = "Nur Ausruestung unter dieser Gegenstandsstufe markieren. 0 = deaktiviert."
    L.TOOLTIP_EXPANSION = "Alle Items aus %s beim Haendler verkaufen."
    L.DE_MIN_QUALITY_LABEL = "Mindestqualitaet zum Markieren"
    L.DE_MAX_QUALITY_LABEL = "Hoechstqualitaet zum Markieren"
    L.DE_BELOW_ILVL_LABEL = "Ausruestung unter Gegenstandsstufe markieren (0 = aus)"
    L.KEEP_LIST_COUNT = "Macht Freude: %d Gegenstand/Gegenstaende"
    L.SELL_LIST_COUNT = "Macht keine Freude: %d Gegenstand/Gegenstaende"
    L.LIST_HELP = "Benutze /pk keep <Itemlink> und /pk sell-add <Itemlink> zur Listenverwaltung."

    L.HELP_HEADER = "--- PocketKondo Befehle ---"
    L.HELP_OPTIONS = "/pk - Einstellungen oeffnen"
    L.HELP_STATUS = "/pk status - Aktuelle Einstellungen anzeigen"
    L.HELP_SELL = "/pk sell - Auto-Verkauf umschalten"
    L.HELP_DE = "/pk de - Entzauber-Markierung umschalten"
    L.HELP_KEEP = "/pk keep <Itemlink> - Dieser Gegenstand macht Freude!"
    L.HELP_SELL_ADD = "/pk sell-add <Itemlink> - Macht keine Freude"
    L.HELP_KEEP_REMOVE = "/pk keep-remove <Itemlink> - Von der Freude-Liste entfernen"
    L.HELP_SELL_REMOVE = "/pk sell-remove <Itemlink> - Von der Verkaufen-Liste entfernen"
    L.HELP_LIST = "/pk list - Freude- und Verkaufen-Listen anzeigen"

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
