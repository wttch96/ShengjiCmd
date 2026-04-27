import TerminalUI




/// 水平排列视图，子视图会按照添加顺序依次水平排列
class HStack: View {
    let children: [any View]
    var alignment: VerticalAlignment = .center

    private var sizes: [Size] = []

    init(_ children: [any View], alignment: VerticalAlignment = .top) {
        self.children = children
        self.alignment = alignment
    }

    init(alignment: VerticalAlignment = .top, @ViewBuilder _ content: () -> [View]) {
        self.children = content()
        self.alignment = alignment
    }

    /// 测量时先测量所有子视图的尺寸，记录下来以便布局时使用
    func measure(maxWidth: Int, maxHeight: Int) -> Size {
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

    func layout(in rect: Rect) {
        if sizes.count != children.count {
            // 重新测量
            _ = measure(maxWidth: rect.w, maxHeight: rect.h)
        }

        // 调整后的尺寸，主要考虑 Space 组件的剩余空间分配
        var adjustedSizes = sizes
        // 计算宽度
        let totalMinWidth = sizes.reduce(0) { $0 + $1.w }
        // 剩余的最大宽度
        let remainingWidth = max(0, rect.w - totalMinWidth)
        // 找出所有的 Space 组件及其 flex 权重
        let flexibleSpaces = children.enumerated()
            .compactMap { index, child -> (Int, Int)? in
                guard let space = child as? Space else { return nil }
                return (index, space.flex)
            }

        // 计算总的 flex 权重
        let totalFlex = flexibleSpaces.reduce(0) { $0 + $1.1 }
        if remainingWidth > 0 && totalFlex > 0 {
            // 分配剩余宽度
            var leftoverWidth = remainingWidth
            // 分配剩余宽度时需要动态调整剩余宽度和剩余 flex 权重，以确保分配的总宽度不超过剩余宽度
            var leftoverFlex = totalFlex

            // 按照 flex 权重分配剩余宽度
            for (index, flex) in flexibleSpaces {
                let extra = leftoverWidth * flex / leftoverFlex
                adjustedSizes[index] = Size(w: adjustedSizes[index].w + extra, h: adjustedSizes[index].h)
                leftoverWidth -= extra
                leftoverFlex -= flex
            }
        }
        
        var startY = rect.y
        
        switch alignment {
        case .top:
            startY = rect.y
        case .center:
            startY = rect.y + (rect.h - adjustedSizes.map { $0.h }.max()!) / 2
        case .bottom:
            startY = rect.y + (rect.h - adjustedSizes.map { $0.h }.max()!)
        }

        var currentX = 0
        
        for (i, child) in children.enumerated() {
            let size = adjustedSizes[i]
            
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

    func render(to canvas: Canvas) {
        for child in children {
            child.render(to: canvas)
        }
    }
}