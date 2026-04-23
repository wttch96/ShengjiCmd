

import Darwin

class MenuScene: BaseScene {
    override func render() {

        canvas.setColor(fg: .cyan)

        let row = Row {
            Space()
            Col {
                Space()
                Text("1 开始游戏")
                    .bordered(.red)
                Text("2 设置")
                    .setForegroundColor(.cyan)
                    .setBackgroundColor(.yellow)
                Text("3 退出")
                    .setForegroundColor(.red)
                Space()
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