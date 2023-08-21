import ComposableArchitecture
import SwiftUI
import TCACoordinators
import WineyKit

struct WineyApp: View {
  private let store: Store<AppState, AppAction>
  
  public init(store: Store<AppState, AppAction>) {
    self.store = store
    WineyKitFontFamily.registerAllCustomFonts() // 프로젝트 전체에서 공유할 수 있도록
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
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
        .onAppear { viewStore.send(.onAppear) }
    }
  }
}

public struct AppState: Equatable {
  init() {}
}

public enum AppAction {
  case onAppear
}

internal struct AppEnvironment {
  internal init() {
  }
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine([
  Reducer<AppState, AppAction, AppEnvironment> { state, action, env in
    switch action {
    case .onAppear:
      return .none
    }
  }
])
