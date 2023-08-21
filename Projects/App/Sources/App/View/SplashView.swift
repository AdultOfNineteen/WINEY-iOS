//
//  SplashView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct SplashView: View {
  private let store: Store<SplashState, SplashAction>
  
  public init(store: Store<SplashState, SplashAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack(alignment: .center, spacing: 0) {
        Text("Winey SplashView")
        Spacer()
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // SplashView 확인용 강제 딜레이
          viewStore.send(._onAppear)
        }
      }
    }
    .background(.white)
    .navigationViewStyle(StackNavigationViewStyle())
    .navigationBarHidden(true)
  }
}
