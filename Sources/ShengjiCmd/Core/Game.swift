import Darwin

enum GameState {
    case menu // 菜单页面
}

class Game {
    private var state: GameState = .menu
    
    private var canvas: Canvas = Canvas(width: 160, height: 40)
    private var currentScene: Scene


    init( ) {
        currentScene = MenuScene(canvas: Canvas(width: 160, height: 40))
    }

    func loop() {
        while true {
            // 游戏主循环
            // 清屏
            print("\u{001B}[2J\u{001B}[H", terminator: "")
            currentScene.render()
            let input = readLine() ?? ""
            if let transition = currentScene.handleInput(input) {
                // 处理场景切换
                switch transition {
                    case .settings:
                        currentScene = SettingScene(canvas: canvas)
                    default:
                        break
                }
            }
        }
    }
}