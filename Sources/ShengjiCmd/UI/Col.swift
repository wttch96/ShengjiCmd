
enum MainAxisAlignment {
    case start
    case center
    case end
    case spaceBetween
}


class Col: View {
    let children: [any View]
    var alignment: MainAxisAlignment = .start
    
    private var sizes: [Size] = []
    
    init(alignment: MainAxisAlignment = .start, @ViewBuilder _ content: () -> [View]) {
        self.children = content()
        self.alignment = alignment
    }

    func measure(maxWidth: Int, maxHeight: Int) -> Size {
        sizes = []
        
        var totalHeight = 0
        var maxW = 0
        
        for child in children {
            let size: Size
            if let space = child as? Space {
                size = space.measureForCol(maxWidth: maxWidth)
            } else {
                size = child.measure(maxWidth: maxWidth, maxHeight: maxHeight)
            }
            sizes.append(size)
            totalHeight += size.h
            maxW = max(maxW, size.w)
        }
        
        return Size(w: maxW, h: totalHeight)
    }

    func layout(in rect: Rect) {
        if sizes.count != children.count {
            _ = measure(maxWidth: rect.w, maxHeight: rect.h)
        }

        var adjustedSizes = sizes
        let totalMinHeight = sizes.reduce(0) { $0 + $1.h }
        let remainingHeight = max(0, rect.h - totalMinHeight)

        let flexibleSpaces = children.enumerated().compactMap { index, child -> (Int, Int)? in
            guard let space = child as? Space else { return nil }
            return (index, space.flex)
        }

        let totalFlex = flexibleSpaces.reduce(0) { $0 + $1.1 }
        if remainingHeight > 0 && totalFlex > 0 {
            var leftoverHeight = remainingHeight
            var leftoverFlex = totalFlex

            for (index, flex) in flexibleSpaces {
                let extra = leftoverHeight * flex / leftoverFlex
                adjustedSizes[index] = Size(w: adjustedSizes[index].w, h: adjustedSizes[index].h + extra)
                leftoverHeight -= extra
                leftoverFlex -= flex
            }
        }

        let totalHeight = adjustedSizes.reduce(0) { $0 + $1.h }
        
        var startY = rect.y
        
        switch alignment {
        case .start:
            startY = rect.y
        case .center:
            startY = rect.y + (rect.h - totalHeight) / 2
        case .end:
            startY = rect.y + rect.h - totalHeight
        case .spaceBetween:
            startY = rect.y
        }

        var currentY = startY
        
        for (i, child) in children.enumerated() {
            let size = adjustedSizes[i]
            
            child.layout(
                in: Rect(
                    x: rect.x,
                    y: currentY,
                    w: size.w,
                    h: size.h
                )
            )
            
            currentY += size.h
        }
    }

    func render(to canvas: Canvas) {
        for child in children {
            child.render(to: canvas)
        }
    }
}