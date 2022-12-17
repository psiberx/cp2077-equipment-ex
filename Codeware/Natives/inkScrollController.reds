// -----------------------------------------------------------------------------
// inkScrollController
// -----------------------------------------------------------------------------
//
// - Viewport are size
//
// -----------------------------------------------------------------------------
//
// class inkScrollController extends inkLeafWidget {
//   public func GetFitToContentDirection() -> inkFitToContentDirection
//   public func SetFitToContentDirection(value: inkFitToContentDirection) -> Void
// }
//

@addField(inkScrollController)
native let viewportSize: Vector2;

@addMethod(inkScrollController)
public func GetViewportSize() -> Vector2 {
    return this.viewportSize;
}

@addMethod(inkScrollController)
public func SetViewportSize(size: Vector2) -> Void {
    this.viewportSize = size;
}

@addMethod(inkScrollController)
public func SetViewportWidth(width: Float) -> Void {
    this.viewportSize = new Vector2(width, this.viewportSize.Y);
}

@addMethod(inkScrollController)
public func SetViewportHeight(height: Float) -> Void {
    this.viewportSize = new Vector2(this.viewportSize.X, height);
}
