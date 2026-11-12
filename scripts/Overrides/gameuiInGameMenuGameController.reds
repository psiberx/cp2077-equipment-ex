import EquipmentEx.{OutfitSystem,WardrobeCache}

@addField(gameuiInGameMenuGameController)
private let m_outfitSystem: wref<OutfitSystem>;

@wrapMethod(gameuiInGameMenuGameController)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    this.m_outfitSystem = OutfitSystem.GetInstance(this.GetPlayerControlledObject().GetGame());
}

@wrapMethod(gameuiInGameMenuGameController)
protected cb func OnPuppetReady(sceneName: CName, puppet: ref<gamePuppet>) -> Bool {
    wrappedMethod(sceneName, puppet);

    if this.m_outfitSystem.IsActive() && Equals(sceneName, n"inventory") && !GetPlayer(puppet.GetGame()).IsReplacer() {
        this.m_outfitSystem.EquipPuppetOutfit(puppet) ;
    }
}

@wrapMethod(gameuiInGameMenuGameController)
protected cb func OnEquipmentChanged(value: Variant) -> Bool {
    if !this.m_outfitSystem.UpdatePuppetFromBlackboard(this.GetPuppet(n"inventory")) {
        wrappedMethod(value);
    }
}

@wrapMethod(gameuiInGameMenuGameController)
protected cb func OnUninitialize() -> Bool {
    WardrobeCache.GetInstance(this.GetPlayerControlledObject().GetGame()).Invalidate();

    return wrappedMethod();
}
