/// z轴堆叠视图，子视图会按照添加顺序依次覆盖在前一个视图上
/// 暂时先不用，因为目前的需求还不需要，等后续需要了再完善
public final class ZStack: View {
    public let children: [any View]
    public let alignment: AlignmentEdge

    public init(@ViewBuilder _ content: () -> [any View], alignment: AlignmentEdge = .topLeading) {
        self.children = content()
        self.alignment = alignment
    }

    public func measure(maxWidth: Int, maxHeight: Int) -> Size {
        var maxW = 0
        var maxH = 0

        for child in children {
            let size = child.measure(maxWidth: maxWidth, maxHeight: maxHeight)
            maxW = max(maxW, size.w)
            maxH = max(maxH, size.h)
        }

        return Size(w: maxW, h: maxH)
    }

    public func layout(in rect: Rect) {
        for child in children {
            let childSize = child.measure(maxWidth: rect.w, maxHeight: rect.h)
            let childRect: Rect
            switch alignment {
            case .topLeading:
                childRect = Rect(x: rect.x, y: rect.y, w: childSize.w, h: childSize.h)
            case .top:
                childRect = Rect(x: rect.x + (rect.w - childSize.w) / 2, y: rect.y, w: childSize.w, h: childSize.h)
            case .topTrailing:
                childRect = Rect(x: rect.x + rect.w - childSize.w, y: rect.y, w: childSize.w, h: childSize.h)
            case .leading:
                childRect = Rect(x: rect.x, y: rect.y + (rect.h - childSize.h) / 2, w: childSize.w, h: childSize.h)
            case .center:
                childRect = Rect(x: rect.x + (rect.w - childSize.w) / 2, y: rect.y + (rect.h - childSize.h) / 2, w: childSize.w, h: childSize.h)
            case .trailing:
                childRect = Rect(x: rect.x + rect.w - childSize.w, y: rect.y + (rect.h - childSize.h) / 2, w: childSize.w, h: childSize.h)
            case .bottomLeading:
                childRect = Rect(x: rect.x, y: rect.y + rect.h - childSize.h, w: childSize.w, h: childSize.h)
            case .bottom:
                childRect = Rect(x: rect.x + (rect.w - childSize.w) / 2, y: rect.y + rect.h - childSize.h, w: childSize.w, h: childSize.h)
            case .bottomTrailing:
                childRect = Rect(x: rect.x + rect.w - childSize.w, y: rect.y + rect.h - childSize.h, w: childSize.w, h: childSize.h)
            }
            child.layout(in: childRect)
        }
    }

    public func render(to canvas: Canvas) {
        for child in children {
            child.render(to: canvas)
        }
    }
}