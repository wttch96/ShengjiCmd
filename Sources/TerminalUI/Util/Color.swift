
public enum Color: Int {
    case black = 0
    case red = 1
    case green = 2
    case yellow = 3
    case blue = 4
    case magenta = 5
    case cyan = 6
    case white = 7
}

public extension String {
    /// 为字符串添加终端颜色
    /// - Parameters:
    ///  - fg: 前景色
    ///  - bg: 背景色，如果为 nil 则不设置背景色
    func colored(fg: Color, bg: Color?) -> String {
        let bgCode = bg?.rawValue != nil ? ";\(bg!.rawValue + 40)" : ""
        return "\u{1B}[\(fg.rawValue + 30)\(bgCode)m\(self)\u{1B}[0m"
    }
}