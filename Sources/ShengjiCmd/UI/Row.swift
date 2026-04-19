
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

    func measure(maxWidth: Int, maxHeight: Int) -> Size {
        sizes = []
        
        var totalWidth = 0
        var maxH = 0
        
        for child in children {
            let size = child.measure(maxWidth: maxWidth, maxHeight: maxHeight)
            sizes.append(size)
            totalWidth += size.w
            maxH = max(maxH, size.h)
        }
        
        return Size(w: totalWidth, h: maxH)
    }

    func layout(in rect: Rect) {
        let totalWidth = sizes.reduce(0) { $0 + $1.w }
        
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
            let size = sizes[i]
            
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