@addField(ItemDisplayContextData)
private let m_isWardrobe: Bool;

@addMethod(ItemDisplayContextData)
public func SetWardrobe(state: Bool) {
    this.m_isWardrobe = state;
}

@addMethod(ItemDisplayContextData)
public func IsWardrobe() -> Bool {
    return this.m_isWardrobe;
}
