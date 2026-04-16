struct Canvas {
    let width: Int
    let height: Int
    var grid: [[String?]]

    fileprivate var bgColor: Color = .black
    fileprivate var fgColor: Color = .cyan

    init(width: Int, height: Int, withBorder: Bool = true) {
        self.width = width
        self.height = height
        self.grid = Array(repeating: Array(repeating: " ", count: width), count: height)

        if withBorder {
            self.drawBox(x: 0, y: 0, boxWidth: width, boxHeight: height)
        }
    }

    func setBg(_ color: Color) -> Self {
        var copy = self
        copy.bgColor = color
        return copy
    }

    func setFg(_ color: Color) -> Self {
        var copy = self
        copy.fgColor = color
        return copy
    }

    func render() {
        let rendered = grid.map {
            $0.compactMap { $0 }.joined(separator: "")
        }.joined(separator: "\n")
        print(rendered)
    }

    /// 使用 nil 来解决中文占两个字符的问题
    fileprivate mutating func setCharacter(x: Int, y: Int, char: Character?) {
        guard x >= 0 && x < width && y >= 0 && y < height else { return }
        guard let char = char else {
            grid[y][x] = nil
            return
        }
        grid[y][x] = String(char).colored(fg: fgColor, bg: bgColor)
    }
}

extension Canvas {
    mutating func drawBox(x: Int, y: Int, boxWidth: Int, boxHeight: Int) {
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

    /// 绘制文字
    /// - Parameters:
    ///   - x: 坐标x
    ///   - y: 坐标y
    ///   - text: 文字，可以包含中文
    ///   - maxWidth: 最大显示长度
    mutating func drawText(x: Int, y: Int, text: String, maxWidth: Int? = nil) {
        var currentX = x
        for char in text {
            let displayWidth = char.displayWidth
            if let maxWidth = maxWidth, currentX + displayWidth > x + maxWidth {
                break
            }
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
