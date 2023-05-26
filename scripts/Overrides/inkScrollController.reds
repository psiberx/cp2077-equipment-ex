@addMethod(inkScrollController)
public func SetScrollEnabled(enabled: Bool) {
    if enabled {
        if Equals(this.direction, inkEScrollDirection.Horizontal) {
            this.scrollDelta = this.contentSize.X - this.viewportSize.X;
        } else {
            this.scrollDelta = this.contentSize.Y - this.viewportSize.Y;
        }
    } else {
        this.scrollDelta = 0.0;
    }
}
