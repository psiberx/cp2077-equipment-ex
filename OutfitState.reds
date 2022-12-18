module EquipmentEx

class OutfitPart {
    private persistent let m_itemID: ItemID;
    private persistent let m_slotID: TweakDBID;

    public func GetItemID() -> ItemID {
        return this.m_itemID;
    }

    public func GetItemHash() -> Uint64 {
        return ItemID.GetCombinedHash(this.m_itemID);
    }

    public func SetItemID(itemID: ItemID) {
        this.m_itemID = itemID;
    }

    public func GetSlotID() -> TweakDBID {
        return this.m_slotID;
    }

    public func SetSlotID(slotID: TweakDBID) {
        this.m_slotID = slotID;
    }

    public static func Create(itemID: ItemID, slotID: TweakDBID) -> ref<OutfitPart> {
        let instance = new OutfitPart();
        instance.m_itemID = itemID;
        instance.m_slotID = slotID;
        return instance;
    }

    public static func Clone(source: ref<OutfitPart>) -> ref<OutfitPart> {
        return OutfitPart.Create(source.m_itemID, source.m_slotID);
    }
}

class OutfitSet {
    private persistent let m_name: CName;
    private persistent let m_parts: array<ref<OutfitPart>>;
    private persistent let m_timestamp: Float;
    private let m_hash: Uint64;

    public func GetName() -> CName {
        return this.m_name;
    }

    public func SetName(name: CName) {
        this.m_name = name;
    }

    public func GetParts() -> array<ref<OutfitPart>> {
        return this.m_parts;
    }

    public func SetParts(parts: array<ref<OutfitPart>>) {
        ArrayResize(this.m_parts, ArraySize(parts));

        let i = 0;
        for part in parts {
            this.m_parts[i] = OutfitPart.Clone(part);
            i += 1;
        }

        this.UpdateHash();
    }

    public func GetHash() -> Uint64 {
        return this.m_hash;
    }

    public func UpdateHash() {
        this.m_hash = OutfitSet.MakeHash(this.m_parts);
    }

    public static func Create(name: CName, timestamp: Float, parts: array<ref<OutfitPart>>) -> ref<OutfitSet> {
        let instance = new OutfitSet();
        instance.m_name = name;
        instance.m_timestamp = timestamp;
        instance.SetParts(parts);
        return instance;
    }

    public static func Clone(name: CName, timestamp: Float, source: ref<OutfitSet>) -> ref<OutfitSet> {
        return OutfitSet.Create(name, timestamp, source.m_parts);
    }
    
    public static func MakeHash(parts: array<ref<OutfitPart>>) -> Uint64 {
        if ArraySize(parts) == 0 {
            return 0ul;
        }

        let items: array<Uint64>;

        for part in parts {
            let item = part.GetItemHash();

            let index = 0;
            while index < ArraySize(items) && items[index] < item {
                index += 1;
            }

            ArrayInsert(items, index, item);
        }

        let hash = 14695981039346656037ul; // 0xcbf29ce484222325
		let prime = 1099511628211ul; // 0x00000100000001B3
        let base = 256ul;

        for item in items {
            let i = 8;
            while i > 0 {
                hash = hash ^ (item % base);
		    	hash *= prime;
                item /= base;
                i -= 1;
            }
        }

		return hash;
    }
}

class OutfitState {
    private persistent let m_active: Bool;
    private persistent let m_parts: array<ref<OutfitPart>>;
    private persistent let m_outfits: array<ref<OutfitSet>>;
    private let m_hash: Uint64;

    public func IsActive() -> Bool {
        return this.m_active;
    }

    public func SetActive(state: Bool) {
        this.m_active = state;
    }

    public func GetParts() -> array<ref<OutfitPart>> {
        return this.m_parts;
    }

    public func HasPart(itemID: ItemID) -> Bool {
        return IsDefined(this.GetPart(itemID));
    }

    public func HasPart(slotID: TweakDBID) -> Bool {
        return IsDefined(this.GetPart(slotID));
    }

    public func GetPart(itemID: ItemID) -> ref<OutfitPart> {
        for part in this.m_parts {
            if Equals(part.GetItemID(), itemID) {
                return part;
            }
        }
        return null;
    }

    public func GetPart(slotID: TweakDBID) -> ref<OutfitPart> {
        for part in this.m_parts {
            if Equals(part.GetSlotID(), slotID) {
                return part;
            }
        }
        return null;
    }

    public func UpdatePart(itemID: ItemID, slotID: TweakDBID) {
        let updated = false;

        for part in this.m_parts {
            if Equals(part.GetItemID(), itemID) {
                if Equals(part.GetSlotID(), slotID) {
                    return;
                }
                part.SetSlotID(slotID);
                updated = true;
                break;
            }
        }

        for part in this.m_parts {
            if Equals(part.GetSlotID(), slotID) {
                if updated {
                    if NotEquals(part.GetItemID(), itemID) {
                        ArrayRemove(this.m_parts, part);
                    }
                } else {
                    part.SetItemID(itemID);
                    updated = true;
                }
                break;
            }
        }

        if !updated {
            ArrayPush(this.m_parts, OutfitPart.Create(itemID, slotID));
        }

        this.UpdateHash();
    }

    public func RemovePart(itemID: ItemID) -> Bool {
        for part in this.m_parts {
            if Equals(part.GetItemID(), itemID) {
                ArrayRemove(this.m_parts, part);
                this.UpdateHash();
                return true;
            }
        }
        return false;
    }

    public func RemovePart(slotID: TweakDBID) -> Bool {
        for part in this.m_parts {
            if Equals(part.GetSlotID(), slotID) {
                ArrayRemove(this.m_parts, part);
                this.UpdateHash();
                return true;
            }
        }
        return false;
    }

    public func ClearParts() {
        ArrayClear(this.m_parts);

        this.UpdateHash();
    }

    public func GetOutfits() -> array<ref<OutfitSet>> {
        return this.m_outfits;
    }

    public func GetOutfit(name: CName) -> ref<OutfitSet> {
        for outfit in this.m_outfits {
            if Equals(outfit.GetName(), name) {
                return outfit;
            }
        }
        return null;
    }

    public func SaveOutfit(name: CName, overwrite: Bool, timestamp: Float) -> Bool {
        return this.SaveOutfit(name, this.m_parts, overwrite, timestamp);
    }

    public func SaveOutfit(name: CName, parts: array<ref<OutfitPart>>, overwrite: Bool, timestamp: Float) -> Bool {
        let outfit = this.GetOutfit(name);

        if IsDefined(outfit) {
            if !overwrite {
                return false;
            }

            outfit.SetParts(parts);
            return true;            
        }
        
        ArrayPush(this.m_outfits, OutfitSet.Create(name, timestamp, parts));
        return true;
    }

    public func CopyOutfit(name: CName, from: CName, timestamp: Float) -> Bool {
        let outfit = this.GetOutfit(name);

        if !IsDefined(outfit) {
            return false;
        }

        ArrayPush(this.m_outfits, OutfitSet.Clone(name, timestamp, outfit));
        return true;
    }

    public func DeleteOutfit(name: CName) -> Bool {
        let outfit = this.GetOutfit(name);

        if !IsDefined(outfit) {
            return false;
        }

        ArrayRemove(this.m_outfits, outfit);
        return true;
    }

    public func IsOutfit(name: CName) -> Bool {
        if Equals(name, n"") {
            return !this.m_active;
        }

        let outfit = this.GetOutfit(name);

        return IsDefined(outfit) ? this.m_hash == outfit.GetHash() : false;
    }

    public func UpdateHash() {
        this.m_hash = OutfitSet.MakeHash(this.m_parts);
    }

    public func Restore() {
        this.UpdateHash();

        for outfit in this.m_outfits {
            outfit.UpdateHash();
        }
    }

    public static func Create() -> ref<OutfitState> {
        return new OutfitState();
    }
}
