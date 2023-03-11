module EquipmentEx

@if(ModuleExists("EquipmentEx.DevMode"))
public static func DevMode() -> Bool = true;

@if(!ModuleExists("EquipmentEx.DevMode"))
public static func DevMode() -> Bool = false;
