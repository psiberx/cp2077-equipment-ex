# Equipment-EX

- Powerful transmog system with 30+ clothing slots
- Unlimited saved outfits with your names
- Accessible from Hub menu and apartment's closet
- Compatible with vanilla and custom items

## How to make compatible items

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
| `OutfitSlots.TorsoOuter`    | Jackets, Coats, Loose Dresses     |           
| `OutfitSlots.TorsoAux`      | Vests, Harnesses                  |                      
| `OutfitSlots.ShoulderLeft`  |                                   |                    
| `OutfitSlots.ShoulderRight` |                                   |                   
| `OutfitSlots.WristLeft`     | Watches, Bands                    |
| `OutfitSlots.WristRight`    | Watches, Bands                    |
| `OutfitSlots.HandLeft`      | Gloves, Rings                     |
| `OutfitSlots.HandRight`     | Gloves, Rings                     |
| `OutfitSlots.Waist`         | Belts                             |
| `OutfitSlots.LegsInner`     | Tights, Leggings                  |
| `OutfitSlots.LegsMiddle`    | Thight Pants, Thight Shorts       |
| `OutfitSlots.LegsOuter`     | Loose Pants, Loose Shorts, Skirts |
| `OutfitSlots.ThighLeft`     |                                   |
| `OutfitSlots.ThighRight`    |                                   |
| `OutfitSlots.AnkleLeft`     |                                   |
| `OutfitSlots.AnkleRight`    |                                   |
| `OutfitSlots.Feet`          | Footwear                          |
| `OutfitSlots.BodyInner`     | Tight-fitting Suits               |
| `OutfitSlots.BodyOuter`     | Jumpsuits, Tracksuits             |
