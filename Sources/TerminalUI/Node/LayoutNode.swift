
struct Position {
    var x: Int
    var y: Int
}

extension Position {
    static let zero = Position(x: 0, y: 0)
}

struct Size {
    var width: Int
    var height: Int
}

extension Size {
    static let zero = Size(width: 0, height: 0)
}

struct Rect {
    var position: Position
    var size: Size
}

struct Padding {
    var top: Int
    var right: Int
    var bottom: Int
    var left: Int
}

extension Padding {
    static let zero = Padding(top: 0, right: 0, bottom: 0, left: 0)
}


struct Offset {
    var dx: Int
    var dy: Int
}

extension Offset {
    static let zero = Offset(dx: 0, dy: 0)
}

class LayoutNode {
    var frame: Rect = Rect(position: .zero, size: .zero)
    var position: Position { frame.position }
    var size: Size { frame.size }
    var padding: Padding = .zero
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