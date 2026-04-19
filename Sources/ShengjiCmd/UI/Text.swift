
class Text: View {
    let text: String
    private var rect: Rect = Rect(x: 0, y: 0, w: 0, h: 0)

    init(_ text: String) {
        self.text = text
    }

    func measure(maxWidth: Int, maxHeight: Int) -> Size {
        return Size(w: text.reduce(0) { $0 + $1.displayWidth } + 2, h: 3)   // 预留边框位置
    }

    func layout(in rect: Rect) {
        self.rect = rect
    }

    func render(to canvas: Canvas) {
        // 绘制边框
        canvas.drawBox(x: rect.x, y: rect.y, boxWidth: rect.w, boxHeight: rect.h)
        canvas.drawText(x: rect.x + 1, y: rect.y + rect.h - 2, text: text)
    }

}