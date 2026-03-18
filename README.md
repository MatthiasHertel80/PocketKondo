# BagCleaner

A World of Warcraft addon for configurable inventory decluttering. Automatically sells junk at vendors and marks items for disenchanting.

## Features

- **Auto-Sell at Vendor** — Automatically sells items when you open a merchant window, based on configurable rules
- **Disenchant Marking** — Marks equipment in tooltips and bag slots that should be disenchanted
- **Configurable Rules:**
  - Sell by item quality (Poor/grey, Common/white, Uncommon/green)
  - Sell gear below a certain item level
  - Keep-list: protect specific items from being sold
  - Sell-list: always sell specific items regardless of other rules
- **Localization** — English and German (Deutsch) supported

## Installation

1. Download or clone this repository
2. Copy the `BagCleaner` folder to:
   ```
   World of Warcraft/_retail_/Interface/AddOns/BagCleaner
   ```
3. Restart WoW or type `/reload` in the chat

## Commands

| Command | Description |
|---------|-------------|
| `/bc` | Open settings panel |
| `/bc status` | Show current configuration |
| `/bc sell` | Toggle auto-sell on/off |
| `/bc de` | Toggle disenchant marking on/off |
| `/bc keep <itemlink>` | Add item to keep list (Shift-click item) |
| `/bc sell-add <itemlink>` | Add item to sell list |
| `/bc keep-remove <itemlink>` | Remove item from keep list |
| `/bc sell-remove <itemlink>` | Remove item from sell list |
| `/bc list` | Show keep and sell lists |
| `/bc help` | Show all commands |

## How It Works

### Auto-Sell
When you open a merchant window, BagCleaner scans your bags and sells items matching your rules. Items are sold one at a time with a short delay to avoid issues. The keep-list always takes priority — items on it will never be sold.

### Disenchant Marking
Items matching your disenchant rules get an orange "Disenchant" label in their tooltip and a small icon overlay on the bag slot. This is a visual reminder only — WoW addons cannot automatically disenchant items.

### Rule Priority
1. **Keep-list** — Always prevents selling/marking (highest priority)
2. **Sell-list** — Always sells at vendor
3. **Quality rules** — Sell Poor, Common, or Uncommon items
4. **Item level rules** — Sell gear below a threshold

## Configuration

Open the settings panel with `/bc` to configure:
- Which item qualities to auto-sell
- Item level thresholds for selling and DE marking
- Quality range for disenchant marking

Use slash commands to manage keep/sell lists by shift-clicking items.

## License

MIT License — see [LICENSE](LICENSE) for details.
