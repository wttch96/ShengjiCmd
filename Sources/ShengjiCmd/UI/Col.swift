

class Col: View {
    let children: [any View]
    var alignment: MainAxisAlignment = .start
    
    private var sizes: [Size] = []
    
    init(@ViewBuilder _ content: () -> [View]) {
        self.children = content()
    }

    func measure(maxWidth: Int, maxHeight: Int) -> Size {
        sizes = []
        
        var totalHeight = 0
        var maxW = 0
        
        for child in children {
            let size = child.measure(maxWidth: maxWidth, maxHeight: maxHeight)
            sizes.append(size)
            totalHeight += size.h
            maxW = max(maxW, size.w)
        }
        
        return Size(w: maxW, h: totalHeight)
    }

    func layout(in rect: Rect) {
        let totalHeight = sizes.reduce(0) { $0 + $1.h }
        
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
            let size = sizes[i]
            
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