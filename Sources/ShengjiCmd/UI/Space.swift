

/// 占位组件，用于在 Row/Col 中占用空间，支持设置最小尺寸和剩余空间分配权重
final class Space: View {
    /// Space 在主轴上的最小尺寸
    private let minLength: Int

    /// 剩余空间分配权重，至少为 1
    let flex: Int

    private var rect: Rect = Rect(x: 0, y: 0, w: 0, h: 0)

    init(_ minLength: Int = 0, flex: Int = 1) {
        self.minLength = max(0, minLength)
        self.flex = max(1, flex)
    }

    func measure(maxWidth: Int, maxHeight: Int) -> Size {
        // 默认值用于通用 View 协议路径，主轴精确尺寸由 Row/Col 专门处理
        Size(w: minLength, h: minLength)
    }

    func measureForRow(maxHeight: Int) -> Size {
        Size(w: minLength, h: 0)
    }

    func measureForCol(maxWidth: Int) -> Size {
        Size(w: 0, h: minLength)
    }

    func layout(in rect: Rect) {
        self.rect = rect
    }

    func render(to canvas: Canvas) {
        // Space 仅参与布局，不做任何绘制
    }
}
