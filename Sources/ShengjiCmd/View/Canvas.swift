class Canvas {
    let width: Int
    let height: Int
    var grid: [[String?]]

    fileprivate var bgColor: Color? = nil
    fileprivate var fgColor: Color = .cyan

    init(width: Int, height: Int, withBorder: Bool = true) {
        self.width = width
        self.height = height
        self.grid = Array(repeating: Array(repeating: " ", count: width), count: height)

        if withBorder {
            self.drawBox(x: 0, y: 0, boxWidth: width, boxHeight: height)
        }
    }

    func setColor(fg: Color? = nil, bg: Color? = nil)  {
        if let fg = fg {
            self.fgColor = fg
        }
        self.bgColor = bg
    }

    func render() {
        let rendered = grid.map {
            $0.compactMap { $0 }.joined(separator: "")
        }.joined(separator: "\n")
        print(rendered)
    }

    /// 使用 nil 来解决中文占两个字符的问题
    fileprivate func setCharacter(x: Int, y: Int, char: Character?) {
        guard x >= 0 && x < width && y >= 0 && y < height else { return }
        guard let char = char else {
            grid[y][x] = nil
            return
        }
        grid[y][x] = String(char).colored(fg: fgColor, bg: bgColor)
    }
}

/// 文字对齐方向
enum TextEdges {
    case left
    case right(Int)
    case center(Int)
}

extension Canvas {
    func drawBox(x: Int, y: Int, boxWidth: Int, boxHeight: Int) {
        for i in 0..<boxWidth {
            setCharacter(x: x + i, y: y, char: "-")
            setCharacter(x: x + i, y: y + boxHeight - 1, char: "-")
        }
        for j in 0..<boxHeight {
            setCharacter(x: x, y: y + j, char: "|")
            setCharacter(x: x + boxWidth - 1, y: y + j, char: "|")
        }
        setCharacter(x: x, y: y, char: "+")
        setCharacter(x: x + boxWidth - 1, y: y, char: "+")
        setCharacter(x: x, y: y + boxHeight - 1, char: "+")
        setCharacter(x: x + boxWidth - 1, y: y + boxHeight - 1, char: "+")
    }

    func drawLine(x: Int, y: Int, length: Int, horizontal: Bool = true) {
        for i in 0..<length {
            var char: Character = " "
            if i == 0 || i == length - 1 {
                char = "+"
            } else {
                char = horizontal ? "-" : "|"
            }
            setCharacter(x: horizontal ? x + i : x, y: horizontal ? y : y + i, char: char)
        }
    }

    /// 绘制文字
    /// - Parameters:
    ///   - x: 坐标x
    ///   - y: 坐标y
    ///   - text: 文字，可以包含中文
    ///   - maxWidth: 最大显示长度
    ///   - edges: 对齐方向
    func drawText(x: Int, y: Int, text: String, edges: TextEdges = .left) {
        // 首先计算文本的显示宽度
        let textWidth = text.reduce(0) { $0 + $1.displayWidth }
        var currentX = 0

        switch edges {
        case .left:
            currentX = x
        case .right(let maxWidth):
            currentX = x + maxWidth - textWidth
        case .center(let maxWidth):
            currentX = x + (maxWidth - textWidth) / 2
        }

        for char in text {
            let displayWidth = char.displayWidth
            if displayWidth == 2 {
                setCharacter(x: currentX, y: y, char: char)
                setCharacter(x: currentX + 1, y: y, char: nil)  // 占位
            } else if displayWidth == 1 {
                setCharacter(x: currentX, y: y, char: char)
            } else {
                print("未知字符串长度...\(text)")
            }
            currentX += displayWidth
        }
    }
}
