
enum MainAxisAlignment {
    case start
    case center
    case end
    case spaceBetween
}

class Row: View {
    let children: [any View]
    var alignment: MainAxisAlignment = .start
    
    private var sizes: [Size] = []

    init(_ children: [any View], alignment: MainAxisAlignment = .start) {
        self.children = children
        self.alignment = alignment
    }

    init(alignment: MainAxisAlignment = .start, @ViewBuilder _ content: () -> [View]) {
        self.children = content()
        self.alignment = alignment
    }

    func measure(maxWidth: Int, maxHeight: Int) -> Size {
        sizes = []
        
        var totalWidth = 0
        var maxH = 0
        
        for child in children {
            let size: Size
            if let space = child as? Space {
                size = space.measureForRow(maxHeight: maxHeight)
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
            _ = measure(maxWidth: rect.w, maxHeight: rect.h)
        }

        var adjustedSizes = sizes
        let totalMinWidth = sizes.reduce(0) { $0 + $1.w }
        let remainingWidth = max(0, rect.w - totalMinWidth)

        let flexibleSpaces = children.enumerated().compactMap { index, child -> (Int, Int)? in
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

        let totalWidth = adjustedSizes.reduce(0) { $0 + $1.w }
        
        var startX = rect.x
        
        switch alignment {
        case .start:
            startX = rect.x
        case .center:
            startX = rect.x + (rect.w - totalWidth) / 2
        case .end:
            startX = rect.x + rect.w - totalWidth
        case .spaceBetween:
            startX = rect.x
        }

        var currentX = startX
        
        for (i, child) in children.enumerated() {
            let size = adjustedSizes[i]
            
            child.layout(
                in: Rect(
                    x: currentX,
                    y: rect.y,
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