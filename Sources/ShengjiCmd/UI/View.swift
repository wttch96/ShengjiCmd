

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


protocol View {
    /// 计算自身尺寸
    func measure(maxWidth: Int, maxHeight: Int) -> Size
    
    /// 布局（确定子元素位置）
    func layout(in rect: Rect)

    /// 渲染
    func render(to canvas: Canvas)
}


@resultBuilder
struct ViewBuilder {
    static func buildBlock(_ components: View...) -> [View] {
        components
    }
}