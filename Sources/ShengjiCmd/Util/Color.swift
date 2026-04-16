
enum Color: Int {
    case black = 0
    case red = 1
    case green = 2
    case yellow = 3
    case blue = 4
    case magenta = 5
    case cyan = 6
    case white = 7
}

extension String {
    func colored(fg: Color, bg: Color) -> String {
        return "\u{1B}[\(fg.rawValue + 30);\(bg.rawValue + 40)m\(self)\u{1B}[0m"
    }
}