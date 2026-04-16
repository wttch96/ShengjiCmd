
extension Character {
    /// 计算中文字符的显示宽度
    var displayWidth: Int {
        // 简单使用 utf8 编码值域来判断
        return self.unicodeScalars.reduce(0) { width, scalar in
            let value = scalar.value
            if (value >= 0x4E00 && value <= 0x9FFF) || // CJK Unified Ideographs
               (value >= 0x3400 && value <= 0x4DBF) || // CJK Unified Ideographs Extension A
               (value >= 0x20000 && value <= 0x2A6DF) || // CJK Unified Ideographs Extension B
               (value >= 0x2A700 && value <= 0x2B73F) || // CJK Unified Ideographs Extension C
               (value >= 0x2B740 && value <= 0x2B81F) || // CJK Unified Ideographs Extension D
               (value >= 0x2B820 && value <= 0x2CEAF) { // CJK Unified Ideographs Extension E
                return width + 2
            } else {
                return width + 1
            }
        }
    }
}