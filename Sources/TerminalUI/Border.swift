/// 边框组件，给子视图添加一个边框
public final class Border: ViewAttributes, View {
    let child: any View

    /// 这个 init 是私有的，外部只能通过 View 的 bordered() 方法来创建 Border
    init(_ child: any View) {
        self.child = child
    }

    /// 边框占用额外的空间，所以在测量时需要在子视图的基础上加上边框的宽度
    public func measure(maxWidth: Int, maxHeight: Int) -> Size {
        let size = child.measure(maxWidth: maxWidth, maxHeight: maxHeight)
        return Size(w: size.w + 2, h: size.h + 2)
    }

    /// 布局时先记录自己的绝对位置，然后给子视图布局时传入一个缩小了边框宽度的空间
    public func layout(in rect: Rect) {
        absoluteRect = rect
        let childRect = Rect(x: rect.x + 1, y: rect.y + 1, w: max(0, rect.w - 2), h: max(0, rect.h - 2))
        child.layout(in: childRect)
    }

    /// 渲染时先绘制边框，然后再渲染子视图
    public func render(to canvas: Canvas) {
        canvas.setColor(fg: foregroundColor, bg: backgroundColor)
        canvas.drawBox(x: absoluteRect.x, y: absoluteRect.y, boxWidth: absoluteRect.w, boxHeight: absoluteRect.h)

        child.render(to: canvas)
    }
}