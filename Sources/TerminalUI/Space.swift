/// 占位组件，用于在 Row/Col 中占用空间，支持设置最小尺寸和剩余空间分配权重
public final class Space: View {
    /// Space 在主轴上的最小尺寸
    private let minLength: Int

    /// 剩余空间分配权重，至少为 1
    public let flex: Int

    private var rect: Rect = .zero

    public init(_ minLength: Int = 0, flex: Int = 1) {
        self.minLength = max(0, minLength)
        self.flex = max(1, flex)
    }

    public func measure(maxWidth: Int, maxHeight: Int) -> Size {
        // 默认值用于通用 View 协议路径，主轴精确尺寸由 Row/Col 专门处理
        Size(w: minLength, h: minLength)
    }

    public func measureForHStack(maxHeight: Int) -> Size {
        Size(w: minLength, h: 0)
    }

    public func measureForVStack(maxWidth: Int) -> Size {
        Size(w: 0, h: minLength)
    }

    public func layout(in rect: Rect) {
        self.rect = rect
    }

    public func render(to canvas: Canvas) {
        // Space 仅参与布局，不做任何绘制
    }
}