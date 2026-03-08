module EquipmentEx

@if(ModuleExists("EquipmentEx.DevMode"))
public func DevMode() -> Bool = true;

@if(!ModuleExists("EquipmentEx.DevMode"))
public func DevMode() -> Bool = false;
