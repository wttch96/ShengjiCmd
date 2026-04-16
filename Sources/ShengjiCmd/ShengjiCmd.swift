// The Swift Programming Language
// https://docs.swift.org/swift-book
import Darwin

@main
struct ShengjiCmd {
    static func main() {
        // 清屏并将光标移动到左上角
        // print("\u{001B}[2J\u{001B}[H", terminator: "")
        var canvas = Canvas(width: 160, height: 40)
        canvas = canvas.setFg(.cyan).setBg(.red)
        canvas.drawText(x: 10, y: 10, text: "王者荣耀Aho")
        canvas.render()
        let deck = Deck(2) // 使用两副牌
        deck.shuffle()
        let (hands, bottomCards) = deck.deal(4, bottomCount: 8) // 四人游戏，底牌8张
        for (index, hand) in hands.enumerated() {
            print("玩家 \(index + 1) 的手牌:\n \(hand)")
        }
        print("底牌: \(bottomCards)")
    }
}


func width(of string: String) -> Int {
    return string.unicodeScalars.reduce(0) {
        $0 + Int(wcwidth(Int32($1.value)))
    }
}