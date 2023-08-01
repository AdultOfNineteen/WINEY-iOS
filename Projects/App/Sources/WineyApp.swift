import SwiftUI
import Utils

@main
struct WineyApp: App {
  
  init() {
    UtilsFontFamily.registerAllCustomFonts() //프로젝트 전체에서 공유할 수 있도록
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
      
    }
  }
}
