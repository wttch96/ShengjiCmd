

struct Size {
    let w: Int
    let h: Int
}

struct Rect {
    let x: Int
    let y: Int
    let w: Int
    let h: Int
}

extension Size {
    static var zero: Size {
        return Size(w: 0, h: 0)
    }
}

extension Rect {
    static var zero: Rect {
        return Rect(x: 0, y: 0, w: 0, h: 0)
    }
}


protocol View {
    /// 计算自身尺寸
    func measure(maxWidth: Int, maxHeight: Int) -> Size
    
    /// 布局（确定子元素位置）
    func layout(in rect: Rect)

    /// 渲染
    func render(to canvas: Canvas)
}

class ViewAttributes {
    /// 绝对位置，最终渲染时会用到
    var absoluteRect: Rect = Rect.zero
    /// 前景色
    var foregroundColor: Color = .white
    /// 背景色
    var backgroundColor: Color? = nil
}

extension ViewAttributes {
    func setForegroundColor(_ color: Color) -> Self {
        self.foregroundColor = color
        return self
    }

    func setBackgroundColor(_ color: Color) -> Self {
        self.backgroundColor = color
        return self
    }
}


@resultBuilder
struct ViewBuilder {
    static func buildBlock(_ components: View...) -> [View] {
        components
    }
}