import SwiftUI
import WineyKit

@main
struct WineyApp: App {
  
  init() {
    WineyKitFontFamily.registerAllCustomFonts() // 프로젝트 전체에서 공유할 수 있도록
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
