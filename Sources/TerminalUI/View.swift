

public struct Size: Sendable {
    public let w: Int
    public let h: Int

    public init(w: Int, h: Int) {
        self.w = w
        self.h = h
    }
}

public extension Size {
    static let zero = Size(w: 0, h: 0)
}

public struct Offset: Sendable {
    public let x: Int
    public let y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

public extension Offset {
    static let zero = Offset(x: 0, y: 0)
}

public struct Rect: Sendable {
    public let x: Int
    public let y: Int
    public let w: Int
    public let h: Int

    public init(x: Int, y: Int, w: Int, h: Int) {
        self.x = x
        self.y = y
        self.w = w
        self.h = h
    }
}

public extension Rect {
    static let zero = Rect(x: 0, y: 0, w: 0, h: 0)
}

public protocol View {
    var body: any View { get }

    func measure(maxWidth: Int, maxHeight: Int) -> Size
    func layout(in rect: Rect)
    func render(to canvas: Canvas)
}

public extension View {
    var body: any View { self }
}

public class ViewAttributes {
    public var absoluteRect: Rect = .zero
    public var foregroundColor: Color = .white
    public var backgroundColor: Color? = nil
    public var offset: Offset = .zero

    public init() {}

    public var rect: Rect {
        Rect(
            x: absoluteRect.x + offset.x,
            y: absoluteRect.y + offset.y,
            w: absoluteRect.w,
            h: absoluteRect.h
        )
    }
}

public extension ViewAttributes {
    @discardableResult
    func setForegroundColor(_ color: Color) -> Self {
        foregroundColor = color
        return self
    }

    @discardableResult
    func setBackgroundColor(_ color: Color) -> Self {
        backgroundColor = color
        return self
    }

    @discardableResult
    func offset(x: Int = 0, y: Int = 0) -> Self {
        offset = Offset(x: x, y: y)
        return self
    }
}

@resultBuilder
public struct ViewBuilder {
    public static func buildBlock(_ components: any View...) -> [any View] {
        components
    }
}

public enum HorizontalAlignment {
    case leading
    case center
    case trailing
}

public enum VerticalAlignment {
    case top
    case center
    case bottom
}

public enum AlignmentEdge {
    case topLeading
    case top
    case topTrailing
    case leading
    case center
    case trailing
    case bottomLeading
    case bottom
    case bottomTrailing
}

public extension View {
    func bordered(_ color: Color) -> some View {
        Border(self).setForegroundColor(color)
    }
}