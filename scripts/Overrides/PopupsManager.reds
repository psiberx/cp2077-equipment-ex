@wrapMethod(PopupsManager)
private final func ShowTutorial() {
    if Equals(this.m_tutorialData.message, "LocKey#86091") || Equals(this.m_tutorialData.message, "LocKey#86092") {
        this.OnPopupCloseRequest(null);
        return;
    }

    wrappedMethod();
}
