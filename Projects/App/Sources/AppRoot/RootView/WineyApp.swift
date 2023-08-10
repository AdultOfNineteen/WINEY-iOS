import ComposableArchitecture
import SwiftUI
import TCACoordinators
import WineyKit

@main
struct WineyApp: App {
  
  init() {
    WineyKitFontFamily.registerAllCustomFonts() // 프로젝트 전체에서 공유할 수 있도록
  }
  
  var body: some Scene {
    WindowGroup {
      AppCoordinatorView
        .init(
          store: .init(
            initialState: .init(),
            reducer: appCoordinatorReducer,
            environment: .init(
              mainQueue: .main,
              userDefaultsService: .live
            )
        )
      )
    }
  }
}
