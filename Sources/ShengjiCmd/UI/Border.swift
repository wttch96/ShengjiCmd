import TerminalUI

/// 边框组件，给子视图添加一个边框
class Border: ViewAttributes, View {
    let children: any View

    /// 这个 init 是私有的，外部只能通过 View 的 bordered() 方法来创建 Border
    fileprivate init(_ child: any View) {
        self.children = child
    }

    /// 边框占用额外的空间，所以在测量时需要在子视图的基础上加上边框的宽度
    func measure(maxWidth: Int, maxHeight: Int) -> Size {
        let size = children.measure(maxWidth: maxWidth, maxHeight: maxHeight)
        return Size(w: size.w + 2, h: size.h + 2)   // 边框占用额外的空间
    }

    /// 布局时先记录自己的绝对位置，然后给子视图布局时传入一个缩小了边框宽度的空间
    func layout(in rect: Rect) {
        absoluteRect = rect
        let childRect = Rect(x: rect.x + 1, y: rect.y + 1, w: rect.w - 2, h: rect.h - 2)
        children.layout(in: childRect)
    }

    /// 渲染时先绘制边框，然后再渲染子视图
    func render(to canvas: Canvas) {
        canvas.setColor(fg: self.foregroundColor, bg: self.backgroundColor)
        canvas.drawBox(x: absoluteRect.x, y: absoluteRect.y, boxWidth: absoluteRect.w, boxHeight: absoluteRect.h)

        children.render(to: canvas)
    }
}

extension View {
    func bordered(_ color: Color) -> some View {
        Border(self)
            .setForegroundColor(color)
    }
}