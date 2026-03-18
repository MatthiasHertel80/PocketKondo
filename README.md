# PocketKondo

*Does this loot spark joy?*

A World of Warcraft addon that applies the KonMari method to your bags. Automatically sells joyless items at vendors and marks gear for disenchanting. Compatible with WoW Midnight (12.0.1).

## Features

- **Auto-Sell at Vendor** -- Automatically sells items when you open a merchant window. "Tidied up! Sold 12 joyless items for 4g 20s."
- **Disenchant Marking** -- Marks equipment in tooltips and bag slots that should be disenchanted: "Does not spark joy - Disenchant!"
- **Configurable Rules:**
  - Sell by item quality (Poor/grey, Common/white, Uncommon/green)
  - Sell gear below a certain item level
  - "Sparks Joy" list: protect specific items from ever being sold
  - "Does Not Spark Joy" list: always sell specific items
- **Localization** -- English and German (Deutsch)

## Installation

1. Download or clone this repository
2. Copy the `PocketKondo` folder to:
   ```
   World of Warcraft/_retail_/Interface/AddOns/PocketKondo
   ```
3. Restart WoW or type `/reload`

## Commands

| Command | Description |
|---------|-------------|
| `/pk` | Open settings panel |
| `/pk status` | Show current configuration |
| `/pk sell` | Toggle auto-sell on/off |
| `/pk de` | Toggle disenchant marking on/off |
| `/pk keep <itemlink>` | This item sparks joy! (Shift-click item) |
| `/pk sell-add <itemlink>` | This item does not spark joy |
| `/pk keep-remove <itemlink>` | Remove from joy list |
| `/pk sell-remove <itemlink>` | Remove from sell list |
| `/pk list` | Show joy and sell lists |
| `/pk help` | Show all commands |

## How It Works

### Auto-Sell (Tidying Up)
When you open a merchant window, PocketKondo scans your bags and sells items matching your rules. Items are sold one at a time with a short delay. The "Sparks Joy" list always takes priority -- items on it will never be sold.

### Disenchant Marking (Transform)
Items matching your disenchant rules get an orange "Does not spark joy - Disenchant!" label in their tooltip and a small icon overlay on the bag slot. This is a visual reminder only -- WoW addons cannot automatically disenchant items.

### Rule Priority
1. **Sparks Joy list** -- Always prevents selling/marking (highest priority)
2. **Does Not Spark Joy list** -- Always sells at vendor
3. **Quality rules** -- Sell Poor, Common, or Uncommon items
4. **Item level rules** -- Sell gear below a threshold

## License

MIT License -- see [LICENSE](LICENSE) for details.
