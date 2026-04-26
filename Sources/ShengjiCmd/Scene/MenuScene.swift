import Darwin

class MenuScene: BaseScene {
    override func render() {

        canvas.setColor(fg: .cyan)

        let row = HStack(alignment: .center) {
            Space()
            VStack {
                Text("欢迎来到打升级")
                    .bordered(.magenta)
                Space()
                VStack {
                    Text("1 开始游戏")
                    Text("")
                    Text("2 设置")
                    Text("")
                    Text("3 退出")
                }
                .bordered(.red)
            }
            Space()
        }
        .bordered(.cyan)

        let _ = row.measure(maxWidth: canvas.height, maxHeight: canvas.width)
        row.layout(in: Rect(x: 0, y: 0, w: canvas.width, h: canvas.height))
        row.render(to: canvas)

        canvas.render()
    }

    override func handleInput(_ input: String) -> SceneTransition? {
        if input == "1" {
            return .game
        }
        if input == "2" {
            return .settings
        }
        if input == "3" {
            exit(0)
        }
        return nil
    }
}
