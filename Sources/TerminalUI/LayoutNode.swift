
internal struct Position {
    var x: Int
    var y: Int
}

extension Position {
    static let zero = Position(x: 0, y: 0)
}

internal struct Size {
    var width: Int
    var height: Int
}

extension Size {
    static let zero = Size(width: 0, height: 0)
}


internal struct Padding {
    var top: Int
    var right: Int
    var bottom: Int
    var left: Int
}

extension Padding {
    static let zero = Padding(top: 0, right: 0, bottom: 0, left: 0)
}


internal struct Offset {
    var dx: Int
    var dy: Int
}

extension Offset {
    static let zero = Offset(dx: 0, dy: 0)
}

internal final class LayoutNode {
    var position: Position = .zero
    var size: Size = .zero
    var padding: Padding = .zero
    var offset: Offset = .zero
}