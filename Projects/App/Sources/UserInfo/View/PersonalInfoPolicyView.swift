//
//  PersonalInfoPolicyView.swift
//  MyPageFeature
//
//  Created by 정도현 on 2/1/24.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct PersonalInfoPolicyView: View {
  private let store: StoreOf<PersonalInfoPolicy>
  @ObservedObject var viewStore: ViewStoreOf<PersonalInfoPolicy>
  
  public init(store: StoreOf<PersonalInfoPolicy>) {
    self.store = store
    self.viewStore = ViewStore(
      self.store,
      observe: { $0 }
    )
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "개인정보 처리방침",
        leftIcon: WineyAsset.Assets.navigationBackButton.swiftUIImage,
        leftIconButtonAction: {
          viewStore.send(.tappedBackButton)
        },
        backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
      )
      
      WineyWebView(
        url: "http://winey-api-dev-env.eba-atefsiev.ap-northeast-2.elasticbeanstalk.com/docs/privacy-policy.html"
      )
    }
    .background(
      WineyKitAsset.mainBackground.swiftUIColor
    )
    .ignoresSafeArea(edges: .bottom)
    .navigationBarHidden(true)
  }
}

#Preview {
  PersonalInfoPolicyView(
    store: .init(
      initialState: PersonalInfoPolicy.State(),
      reducer: {
        PersonalInfoPolicy()
      }
    )
  )
}
