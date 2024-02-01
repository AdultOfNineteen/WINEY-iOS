//
//  TermsPolicyVew.swift
//  MyPageFeature
//
//  Created by 정도현 on 2/1/24.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct TermsPolicyView: View {
  private let store: StoreOf<TermsPolicy>
  @ObservedObject var viewStore: ViewStoreOf<TermsPolicy>
  
  public init(store: StoreOf<TermsPolicy>) {
    self.store = store
    self.viewStore = ViewStore(
      self.store,
      observe: { $0 }
    )
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "서비스 이용약관",
        leftIcon: /*WineyAsset.Assets.navigationBackButton.swiftUIImage,*/ // Asset 적용 후 활성화
        Image(systemName: "chevron.backward"),
        leftIconButtonAction: {
          viewStore.send(.tappedBackButton)
        },
        backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
      )
      
      WineyWebView(
        url: "http://winey-api-dev-env.eba-atefsiev.ap-northeast-2.elasticbeanstalk.com/docs/service-policy.html"
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
  TermsPolicyView(
    store: .init(
      initialState: TermsPolicy.State(),
      reducer: {
        TermsPolicy()
      }
    )
  )
}
