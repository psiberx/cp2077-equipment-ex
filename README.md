# Equipment-EX

- Powerful transmog system with 30+ clothing slots
- Unlimited saved outfits with your names
- Accessible from Hub menu and apartment's closet
- Compatible with vanilla and custom items

## How to make compatible items

Any item can support one standard slot and one outfit slot at the same time,
making the item compatible with both the game equipment system and the outfit system.

To make an item compatible with the outfit system the outfit slot must be added to the `placementSlots` property:

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

If the user doesn't have Equipment-EX installed, the item will still work with the standard slot.

Supported slots:

| Slot name                   | Purpose                           |
|:----------------------------|:----------------------------------|
| `OutfitSlots.Headwear`      | Hats, Hijabs, Helmets             |
| `OutfitSlots.Balaclava`     | Balaclavas                        |
| `OutfitSlots.Mask`          | Face Masks                        |
| `OutfitSlots.Glasses`       | Glasses, Visors                   |
| `OutfitSlots.Wreath`        | Wreaths                           |
| `OutfitSlots.EarLeft`       | Earrings                          |
| `OutfitSlots.EarRight`      | Earrings                          |
| `OutfitSlots.Neckwear`      | Scarves, Collars, Ties            |
| `OutfitSlots.NecklaceShort` | Short Necklaces                   | 
| `OutfitSlots.NecklaceLong`  | Long Necklaces                    |  
| `OutfitSlots.TorsoInner`    | Bras, Tops, T-Shirts              |  
| `OutfitSlots.TorsoMiddle`   | Shirts, Vests, Tight Dresses      |     
| `OutfitSlots.TorsoOuter`    | Jackets, Coats, Looses Dresses    |           
| `OutfitSlots.TorsoAux`      | Vests, Harnesses                  |                      
| `OutfitSlots.ShoulderLeft`  |                                   |                    
| `OutfitSlots.ShoulderRight` |                                   |                   
| `OutfitSlots.WristLeft`     | Watches, Bands                    |
| `OutfitSlots.WristRight`    | Watches, Bands                    |
| `OutfitSlots.HandLeft`      | Gloves, Rings                     |
| `OutfitSlots.HandRight`     | Gloves, Rings                     |
| `OutfitSlots.Waist`         | Belts                             |
| `OutfitSlots.LegsInner`     | Thights, Leggings                 |
| `OutfitSlots.LegsMiddle`    | Thight Pants, Thight Shorts       |
| `OutfitSlots.LegsOuter`     | Loose Pants, Loose Shorts, Skirts |
| `OutfitSlots.ThighLeft`     |                                   |
| `OutfitSlots.ThighRight`    |                                   |
| `OutfitSlots.AnkleLeft`     |                                   |
| `OutfitSlots.AnkleRight`    |                                   |
| `OutfitSlots.Feet`          | Footwear                          |
| `OutfitSlots.BodyInner`     | Netrunning Suits                  |
| `OutfitSlots.BodyOuter`     | Jumpsuits                         |
