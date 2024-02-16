//
//  UserSettingView.swift
//  MyPageFeature
//
//  Created by 박혜운 on 12/29/23.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct UserSettingView: View {
  private let store: StoreOf<UserSetting>
  @ObservedObject var viewStore: ViewStoreOf<UserSetting>
  let rows: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0), count: 2)
  
  public init(store: StoreOf<UserSetting>) {
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
        
        Button(
          action: { viewStore.send(.tappedLogout) },
          label: {
            HStack {
              Text("로그아웃")
              Spacer()
            }
          }
        )
        .frame(height: 48)
        .wineyFont(.bodyM1)
        .foregroundColor(.white)
        .padding(.bottom, 8)
        
        Divider()
          .padding(.bottom, 17)
          .padding(
            .horizontal,
            -WineyGridRules
              .globalHorizontalPadding
          )
        
        Button("회원탈퇴") {
          viewStore.send(.tappedSignOut(userId: viewStore.userId))
        }
        .wineyFont(.captionM1)
        .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
      }
    }
    .padding(
      .horizontal,
      WineyGridRules
        .globalHorizontalPadding
    )
    .bottomSheet(
      backgroundColor: WineyKitAsset.gray950.swiftUIColor,
      isPresented: viewStore.binding(
        get: \.isPresentedBottomSheet,
        send: .tappedBottomSheetNoOption
      ),
      headerArea: {
        BadgeBottomSheetHeader()
      },
      content: {
        SettingBottomSheetContent()
      },
      bottomArea: {
        TwoOptionSelectorButtonView(
          leftTitle: "아니오",
          leftAction: { viewStore.send(.tappedBottomSheetNoOption) },
          rightTitle: "네",
          rightAction: { viewStore.send(.tappedBottomSheetYesOption) }
        )
      }
    )
    .background(WineyKitAsset.mainBackground.swiftUIColor)
    .navigationBarHidden(true)
  }
  
  var navigationBarSpacer: some View {
    NavigationBar(
      title: "계정 설정",
      leftIcon: WineyAsset.Assets.navigationBackButton.swiftUIImage,
      leftIconButtonAction: {
        viewStore.send(.tappedBackButton)
      },
      backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
    )
  }
}

#Preview {
  UserSettingView(
    store: .init(
      initialState: .init(userId: 22),
      reducer: {
        UserSetting()
      }
    )
  )
}
