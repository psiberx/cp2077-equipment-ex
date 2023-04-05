import EquipmentEx.PuppetStateSystem

@addMethod(ScriptedPuppet)
public func SupportsNewSlots() -> Bool {
    let characterSlots = TweakDBInterface.GetForeignKeyArray(this.GetRecordID() + t".attachmentSlots");
    return ArrayContains(characterSlots, t"OutfitSlots.Feet");
}

@wrapMethod(ScriptedPuppet)
protected cb func OnGameAttached() -> Bool {
    if this.SupportsNewSlots() {
        PuppetStateSystem.GetInstance(this.GetGame()).RegisterPuppet(this);
    }

    wrappedMethod();
}

@wrapMethod(ScriptedPuppet)
protected cb func OnDetach() -> Bool {
    if this.SupportsNewSlots() {
        PuppetStateSystem.GetInstance(this.GetGame()).UnregisterPuppet(this);
    }

    wrappedMethod();
}
