# Equipment-EX

- Adds a new transmog system with 30+ clothing slots
- Adds a brand-new UI accessible from Hub menu and V's apartments
- Allows you to manage an unlimited amount of outfits with your names
- Converts your existing wardrobe sets to a new system at a first launch
- Works with vanilla and custom items

## Getting Started

### Requirements

- [ArchiveXL](https://github.com/psiberx/cp2077-archive-xl) 1.3.4+
- [TweakXL](https://github.com/psiberx/cp2077-tweak-xl) 1.1.1+
- [redscript](https://github.com/jac3km4/redscript) 0.5.9+

### Installation

1. Download [the latest release](https://github.com/psiberx/cp2077-equipment-ex/releases) archive
2. Extract the archive into the Cyberpunk 2077 installation directory

### How to use

- The outfit manager is accessible through the new "Wardrobe" button in the Inventory menu or from wardrobe call in V's apartments
- On the right side of the screen, you will see all your carried and stashed gear grouped by slots
- Clicking on any item will activate outfit mode, which applies the visuals of the selected items to your character over equipped gear
- On the left side of the screen, you will see a list of your outfits
- The "Save outfit" button becomes available when outfit mode is active
- To equip a previously saved outfit, just click on the name in the list
- To delete an outfit, hover over the outfit and press the hotkey from the hint
- To disable the outfit mode, you can select "No outfit" or unequip the outfit from the Inventory menu

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
| `OutfitSlots.Neckwear`      | Scarves, Collars, Ties                           |
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
- The slot must represent a body part
- If the slot cannot be bound to a body part, then the equipment category should be used

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
