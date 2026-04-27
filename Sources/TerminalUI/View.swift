

protocol View {
    var body: any View { get }

}


extension View {
    internal func _makeNode() -> LayoutNode {
        let node = LayoutNode()
        return node
    }
}