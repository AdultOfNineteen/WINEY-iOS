//
//  SignOutView.swift
//  MyPageFeature
//
//  Created by 박혜운 on 12/29/23.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct SignOutView: View {
  private let store: StoreOf<SignOut>
  @ObservedObject var viewStore: ViewStoreOf<SignOut>
  let rows: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0), count: 2)
  
  public init(store: StoreOf<SignOut>) {
    self.store = store
    self.viewStore = ViewStore(
      self.store,
      observe: { $0 }
    )
  }
  
  public var body: some View {
    GeometryReader { _ in
      VStack(alignment: .leading, spacing: 0) {
        navigationBarSpacer
        .padding(.bottom, 20)
        .padding(
          .horizontal,
          -WineyGridRules
            .globalHorizontalPadding
        )

        Group {
          Text("정말 탈퇴하시겠어요?")
            .padding(.bottom, 5)
          Text("이별하기 너무 아쉬워요.")
            .padding(.bottom, 20)
        }
        .wineyFont(.title2)
        .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
        
        Text("계정을 삭제하면 작성하신 노트를 포함하여\n이용한 정보들이 삭제됩니다. 계정 삭제 후\n7일간 다시 가입할 수 없어요.")
          .wineyFont(.bodyB2)
          .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
          .padding(.bottom, 30)
        
        Group {
          Text("계정을 삭제하려는")
            .padding(.bottom, 5)
          Text("이유를 알려주세요.")
            .padding(.bottom, 29)
        }
        .wineyFont(.title2)
        .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
      }
    }
    .padding(
      .horizontal,
      WineyGridRules
        .globalHorizontalPadding
    )
    .background(WineyKitAsset.mainBackground.swiftUIColor)
    .navigationBarHidden(true)
  }
  
  var navigationBarSpacer: some View {
    NavigationBar(
      title: "회원 탈퇴",
      leftIcon: /*WineyAsset.Assets.navigationBackButton.swiftUIImage,*/ // Asset 적용 후 활성화
      Image(systemName: "chevron.backward"),
      leftIconButtonAction: {
        viewStore.send(.tappedBackButton)
      },
      backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
    )
  }
}

#Preview {
  SignOutView(
    store: .init(
      initialState: .init(),
      reducer: {
        SignOut()
      }
    )
  )
}
