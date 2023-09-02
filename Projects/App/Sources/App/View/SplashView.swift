//
//  SplashView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct SplashView: View {
  private let store: Store<SplashState, SplashAction>
  
  public init(store: Store<SplashState, SplashAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      mainLogoSpace
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // SplashView 확인용 강제 딜레이
          viewStore.send(._onAppear)
        }
      }
    }
    .background(.black)
    .navigationViewStyle(StackNavigationViewStyle())
    .navigationBarHidden(true)
  }
  
  private var mainLogoSpace: some View {
    VStack(spacing: 21) {
      Image("logo_imge")
        .background {
          RadientCircleBackgroundView()
        }
      
      ZStack(alignment: .top) {
        Image("logoText_imge")
        Image("wave_imge")
        .offset(y: 2)
      }
    }
  }
}

struct SplashView_Previews: PreviewProvider {
  static var previews: some View {
    SplashView(
      store: Store<SplashState, SplashAction>(
        initialState: .init(),
        reducer: splashReducer,
        environment: SplashEnvironment(
          userDefaultsService: .live
        )
      )
    )
  }
}
