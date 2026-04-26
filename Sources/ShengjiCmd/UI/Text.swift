
/// 纯文字
/// 没有多行支持，没有边框支持，只是简单的纯文字
/// 文字的渲染结果就是1行和文字的实际渲染宽度
class Text: ViewAttributes, View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    /// 计算文本的显示宽度，中文占2格，英文占1格
    func measure(maxWidth: Int, maxHeight: Int) -> Size {
        return Size(w: text.reduce(0) { $0 + $1.displayWidth }, h: 1)   // 预留边框位置
    }

    /// 布局时记录绝对位置，渲染时会用到
    func layout(in rect: Rect) {
        absoluteRect = rect
    }

    /// 渲染时直接在画布上绘制文本，使用前景色和背景色
    func render(to canvas: Canvas) {
        canvas.setColor(fg: self.foregroundColor, bg: self.backgroundColor)
        canvas.drawText(x: rect.x, y: rect.y, text: text)
    }
}
