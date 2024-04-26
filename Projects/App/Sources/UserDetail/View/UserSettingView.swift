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
        .padding(
          .horizontal,
          -WineyGridRules
            .globalHorizontalPadding
        )
        
        changeNickname
        
        divider
        
        logoutButton
        
        divider
        
        signoutButton
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
        Image("analysisNoteIcon")
      },
      content: {
        LogoutBottomSheetContent()
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
  
  var divider: some View {
    Divider()
      .frame(height: 0.8)
      .overlay(
        WineyKitAsset.gray900.swiftUIColor
      )
      .padding(
        .horizontal,
        -WineyGridRules
          .globalHorizontalPadding
      )
  }
  
  var changeNickname: some View {
    Button(
      action: { viewStore.send(.tappedChangeNickname) },
      label: {
        HStack {
          Text("닉네임 변경")
            .wineyFont(.bodyM1)
          
          Spacer()
          
          Image(systemName: "chevron.right")
            .foregroundColor(.white)
            .wineyFont(.title2)
        }
      }
    )
    .frame(height: 48)
    .foregroundColor(.white)
    .padding(.vertical, 8)
  }
  
  var logoutButton: some View {
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
    .padding(.vertical, 8)
  }
  
  var signoutButton: some View {
    Button(action: {
      viewStore.send(.tappedSignOut(userId: viewStore.userId))
    }, label: {
      Text("회원탈퇴")
        .underline(pattern: .solid)
        .baselineOffset(4)
    })
    .wineyFont(.captionM1)
    .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
    .padding(.top, 17)
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
