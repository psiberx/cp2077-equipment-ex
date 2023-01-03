# Equipment-EX

- Adds a new transmog system with 30+ clothing slots
- Adds a brand-new UI accessible from Hub menu and V's apartments
- Allows you to manage an unlimited amount of outfits with your names
- Converts your existing wardrobe sets to a new system at a first launch
- Works with vanilla and custom items

## Getting Started

### Requirements

- Cyberpunk 2077 1.61
- [ArchiveXL](https://github.com/psiberx/cp2077-archive-xl) 1.3.4+
- [TweakXL](https://github.com/psiberx/cp2077-tweak-xl) 1.1.1+
- [RED4ext](https://github.com/WopsS/RED4ext) 1.9.0+
- [redscript](https://github.com/jac3km4/redscript) 0.5.9+
- (Optional) [Mod Settings](https://github.com/jackhumbert/mod_settings) 0.0.10+

### Installation

1. Install all requirements
2. Download [the latest release](https://github.com/psiberx/cp2077-equipment-ex/releases) archive
3. Extract the archive into the Cyberpunk 2077 installation directory

### How to use

- The outfit manager is accessible through the new "Wardrobe" button in the Inventory menu or from wardrobe call in V's apartments
- On the right side of the screen, you will see all compatible gear grouped by slots
- Clicking on any item will activate outfit mode, which applies the visuals of the selected items to your character over equipped gear
- On the left side of the screen, you will see a list of your outfits
- The "Save outfit" button becomes available when outfit mode is active
- To equip a previously saved outfit, just click on the name in the list
- To delete an outfit, hover over the outfit and press the hotkey from the hint
- To disable the outfit mode, you can select "No outfit" or unequip the outfit from the Inventory menu
- In photo mode, you will find the option to change outfits on the fly in the pose section

### Mod settings

| Name             | Description                                                                                                                                                                                                                                                          |
|:-----------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Item&nbsp;Source | Selects the preferred source of items for outfit manager:<br>"Inventory + Stash" will only use the current items in your inventory and stashes<br>"Wardrobe Store" will use every item you have ever obtained in the game (including dropped and disassembled items) |

## Documentation

### Compatible items

Any item can support one base slot and one outfit slot at the same time,
making the item compatible with both the game equipment system and the outfit system.

The outfit slot must be added to the `placementSlots` property after the base slot:

```yaml
Items.MyNecklace:
  $base: Items.GenericHeadClothing
  placementSlots: 
    - !append OutfitSlots.NecklaceShort
```

Which is equivalent to:

```yaml
Items.MyNecklace:
  $base: Items.GenericHeadClothing
  placementSlots: 
    - AttachmentSlots.Head
    - OutfitSlots.NecklaceShort
```

If user doesn't have Equipment-EX installed, the item will still work with the base slot.

### Outfit slots

| Slot name                   | Purpose                                          |
|:----------------------------|:-------------------------------------------------|
| `OutfitSlots.Head`          | Hats, Hijabs, Helmets                            |
| `OutfitSlots.Balaclava`     | Balaclavas                                       |
| `OutfitSlots.Mask`          | Face Masks                                       |
| `OutfitSlots.Glasses`       | Glasses, Visors                                  |
| `OutfitSlots.Wreath`        | Wreaths                                          |
| `OutfitSlots.EarLeft`       | Earrings                                         |
| `OutfitSlots.EarRight`      | Earrings                                         |
| `OutfitSlots.Neckwear`      | Scarves, Collars                                 |
| `OutfitSlots.NecklaceTight` | Chokers                                          | 
| `OutfitSlots.NecklaceShort` | Short Necklaces                                  | 
| `OutfitSlots.NecklaceLong`  | Long Necklaces                                   |  
| `OutfitSlots.TorsoUnder`    | Bras, Tight Long-sleeves                         |  
| `OutfitSlots.TorsoInner`    | Tops, T-Shirts, Tight Shirts, Tight Dresses      |  
| `OutfitSlots.TorsoMiddle`   | Waistcoats, Blazers, Loose Shirts, Loose Dresses |     
| `OutfitSlots.TorsoOuter`    | Jackets, Coats                                   |           
| `OutfitSlots.TorsoAux`      | Vests, Harnesses, Puffers                        |                      
| `OutfitSlots.ShoulderLeft`  |                                                  |                    
| `OutfitSlots.ShoulderRight` |                                                  |                   
| `OutfitSlots.WristLeft`     | Watches, Bands                                   |
| `OutfitSlots.WristRight`    | Watches, Bands                                   |
| `OutfitSlots.HandLeft`      | Gloves, Rings                                    |
| `OutfitSlots.HandRight`     | Gloves, Rings                                    |
| `OutfitSlots.Waist`         | Belts                                            |
| `OutfitSlots.LegsInner`     | Tights, Leggings                                 |
| `OutfitSlots.LegsMiddle`    | Tight Pants, Tight Shorts                        |
| `OutfitSlots.LegsOuter`     | Loose Pants, Loose Shorts, Skirts                |
| `OutfitSlots.ThighLeft`     |                                                  |
| `OutfitSlots.ThighRight`    |                                                  |
| `OutfitSlots.AnkleLeft`     |                                                  |
| `OutfitSlots.AnkleRight`    |                                                  |
| `OutfitSlots.Feet`          | Footwear                                         |
| `OutfitSlots.BodyUnder`     | Netrunning Suits                                 |
| `OutfitSlots.BodyInner`     |                                                  |
| `OutfitSlots.BodyMiddle`    | Jumpsuits, Tracksuits                            |
| `OutfitSlots.BodyOuter`     |                                                  |

When proposing a new slot, please follow these recommendations:

- The purpose of the slot must be clear and distinguishable from other slots
- The slot must represent an area or layer for only one item equipped at a time
- The slot must be named after a body part if possible, or equipment category otherwise

### Auto conversions

If you don't specify any outfit slot for your item, 
then the slot will be automatically assigned according to this table:

| Base record                       | Assigned slot            |
|:----------------------------------|:-------------------------|
| `Items.GenericHeadClothing`       | `OutfitSlots.Head`       |
| `Items.Glasses`                   | `OutfitSlots.Glasses`    |
| `Items.Visor`                     | `OutfitSlots.Glasses`    |
| `Items.GenericFaceClothing`       | `OutfitSlots.Mask`       |
| `Items.GenericInnerChestClothing` | `OutfitSlots.TorsoInner` |
| `Items.GenericOuterChestClothing` | `OutfitSlots.TorsoOuter` |
| `Items.GenericLegClothing`        | `OutfitSlots.LegsMiddle` |
| `Items.Skirt`                     | `OutfitSlots.LegsOuter`  |
| `Items.GenericFootClothing`       | `OutfitSlots.Feet`       |
| `Items.Outfit`                    | `OutfitSlots.BodyMiddle` |

### Appearance suffixes

The mod adds a new appearance suffix that represents the state of the legs of female characters.
It can be used to properly render tights depending on whether the character is wearing shoes.

To activate a new suffix, you must add it to `appearanceSuffixes` as usual:

```yaml
Items.MyTights:
  $base: Items.GenericLegClothing
  appearanceSuffixes: 
   - !append itemsFactoryAppearanceSuffix.LegsState
```

| Character | Footwear   | Suffix    |
|:----------|:-----------|:----------|
| Female    | Unequipped | `&Flat`   |
| Female    | Equipped   | `&Lifted` |
| Male      | Unequipped | (empty)   |
| Male      | Equipped   | (empty)   |

## Translations

If you want to translate this mod into your language, get translation template JSON 
[`support/localization/lang.json.json`](https://github.com/psiberx/cp2077-equipment-ex/blob/master/support/localization/lang.json.json), 
translate all `femaleVariant` values, and send it to us.
Please try to make a translation as close to the English version as possible.
Your translation will be added to the mod, and you will be credited on the mod page.

Available translations:

- English
- Russian (by @Locked15)
