

import Darwin

class MenuScene: BaseScene {
    override func render() {

        canvas.setColor(fg: .cyan)

        let row = Col {
            Text("1 开始游戏")
            Text("2 设置")
            Text("3 退出")
        }

        let _ = row.measure(maxWidth: 120, maxHeight: 20)
        row.layout(in: Rect(x: 0, y: 0, w: 120, h: 20))
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