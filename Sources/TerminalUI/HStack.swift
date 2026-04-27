/// 水平排列视图，子视图会按照添加顺序依次水平排列
public final class HStack: View {
    public let children: [any View]
    public var alignment: VerticalAlignment = .center

    private var sizes: [Size] = []

    public init(_ children: [any View], alignment: VerticalAlignment = .top) {
        self.children = children
        self.alignment = alignment
    }

    public init(alignment: VerticalAlignment = .top, @ViewBuilder _ content: () -> [any View]) {
        self.children = content()
        self.alignment = alignment
    }

    /// 测量时先测量所有子视图的尺寸，记录下来以便布局时使用
    public func measure(maxWidth: Int, maxHeight: Int) -> Size {
        sizes = []

        var totalWidth = 0
        var maxH = 0

        for child in children {
            let size: Size
            if let space = child as? Space {
                // Space 组件在 Row 中测量时只关心主轴（宽度），交叉轴（高度）由 Row 统一处理
                size = space.measureForHStack(maxHeight: maxHeight)
            } else {
                size = child.measure(maxWidth: maxWidth, maxHeight: maxHeight)
            }
            sizes.append(size)
            totalWidth += size.w
            maxH = max(maxH, size.h)
        }

        return Size(w: totalWidth, h: maxH)
    }

    public func layout(in rect: Rect) {
        if sizes.count != children.count {
            _ = measure(maxWidth: rect.w, maxHeight: rect.h)
        }

        // 调整后的尺寸，主要考虑 Space 组件的剩余空间分配
        var adjustedSizes = sizes
        let totalMinWidth = sizes.reduce(0) { $0 + $1.w }
        let remainingWidth = max(0, rect.w - totalMinWidth)
        let flexibleSpaces = children.enumerated()
            .compactMap { index, child -> (Int, Int)? in
                guard let space = child as? Space else { return nil }
                return (index, space.flex)
            }

        let totalFlex = flexibleSpaces.reduce(0) { $0 + $1.1 }
        if remainingWidth > 0 && totalFlex > 0 {
            var leftoverWidth = remainingWidth
            var leftoverFlex = totalFlex

            for (index, flex) in flexibleSpaces {
                let extra = leftoverWidth * flex / leftoverFlex
                adjustedSizes[index] = Size(w: adjustedSizes[index].w + extra, h: adjustedSizes[index].h)
                leftoverWidth -= extra
                leftoverFlex -= flex
            }
        }

        let maxHeight = adjustedSizes.map { $0.h }.max() ?? 0
        let startY: Int
        switch alignment {
        case .top:
            startY = rect.y
        case .center:
            startY = rect.y + (rect.h - maxHeight) / 2
        case .bottom:
            startY = rect.y + rect.h - maxHeight
        }

        var currentX = rect.x

        for (index, child) in children.enumerated() {
            let size = adjustedSizes[index]
            child.layout(
                in: Rect(
                    x: currentX,
                    y: startY,
                    w: size.w,
                    h: size.h
                )
            )

            currentX += size.w
        }
    }

    public func render(to canvas: Canvas) {
        for child in children {
            child.render(to: canvas)
        }
    }
}