

final class TextLayoutNode: LayoutNode {
    var text: String
    var color: Color?
    
    init(text: String, color: Color? = nil) {
        self.text = text
        self.color = color
    }

}