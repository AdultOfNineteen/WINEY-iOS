import ComposableArchitecture
import MyPageFeature
import SwiftUI

@main
struct MyPageFeatureDemoView: App {
  init() {
    self.store = .init(
      initialState: .init(),
      reducer: { UserInfoCoordinator() }
    )
  }
  
  private let store: StoreOf<UserInfoCoordinator>
  
  var body: some Scene {
    WindowGroup {
      UserInfoCoordinatorView(store: store)
    }
  }
}
