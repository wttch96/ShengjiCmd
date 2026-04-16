import Foundation

struct Card {
    let suit: Suit?
    let rank: Rank?
    let isSmallJoker: Bool
    let isBigJoker: Bool
    let rawValue: Int

    init(_ rawValue: Int) {
        self.rawValue = rawValue
        let rawValue = rawValue % 54
        if rawValue == 52 {
            self.suit = nil 
            self.rank = nil
            self.isSmallJoker = true
            self.isBigJoker = false
        } else if rawValue == 53 {
            self.suit = nil
            self.rank = nil
            self.isSmallJoker = false
            self.isBigJoker = true
        } else {
            let suitIndex = rawValue / 13
            let rankIndex = rawValue % 13
            self.suit = Suit.allCases[suitIndex]
            self.rank = Rank(rawValue: rankIndex + 2)
            self.isSmallJoker = false
            self.isBigJoker = false
        }
    }
}

extension Card: CustomStringConvertible {
    var description: String {
        if isSmallJoker {
            return "小王".colored(fg: .white, bg: .blue)
        } else if isBigJoker {
            return "大王".colored(fg: .white, bg: .red)
        } else if let suit = suit, let rank = rank {
            let color: Color = (suit == .hearts || suit == .diamonds) ? .red : .blue
            // rank 占两个字符，如果不够则补一个空格
            // \(String(repeating: " ", count: 2-rank.description.count))
            return "\(suit.rawValue)\(rank.description)".colored(fg: .white, bg: color)
        } else {
            return "未知牌"
        }
    }
}

