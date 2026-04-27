
class LayoutNode {
    var frame: Rect = .zero
    var offset: Offset = .zero


    func measure(maxWidth: Int, maxHeight: Int) -> Size {
        fatalError("Subclasses must override measure()")
    }

    func layout(in rect: Rect) {
        fatalError("Subclasses must override layout()")
    }

    func render(to canvas: Canvas) {
        fatalError("Subclasses must override render()")
    }
}