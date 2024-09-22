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
  @Bindable var store: StoreOf<UserSetting>
  
  public var body: some View {
    content
  }
  
  var content: some View {
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
        
        Spacer()
      }
    .padding(
      .horizontal,
      WineyGridRules
        .globalHorizontalPadding
    )
    .bottomSheet(
      backgroundColor: Color.wineyGray950,
      isPresented: .init(get: {
        store.isPresentedBottomSheet
      }, set: { _ in
        store.send(.tappedBottomSheetNoOption)
      }),
      headerArea: {
        Image(.analysisNoteIconW)
      },
      content: {
        LogoutBottomSheetContent()
      },
      bottomArea: {
        TwoOptionSelectorButtonView(
          leftTitle: "아니오",
          leftAction: { store.send(.tappedBottomSheetNoOption) },
          rightTitle: "네",
          rightAction: { store.send(.tappedBottomSheetYesOption) }
        )
      }
    )
    .background(.wineyMainBackground)
    .navigationBarHidden(true)
  }
  
  var navigationBarSpacer: some View {
    NavigationBar(
      title: "계정 설정",
      leftIcon: Image(.navigationBack_buttonW),
      leftIconButtonAction: {
        store.send(.tappedBackButton)
      },
      backgroundColor: .wineyMainBackground
    )
  }
  
  var divider: some View {
    Divider()
      .frame(height: 0.8)
      .overlay(
        .wineyGray900
      )
      .padding(
        .horizontal,
        -WineyGridRules
          .globalHorizontalPadding
      )
  }
  
  var changeNickname: some View {
    Button(
      action: { store.send(.tappedChangeNickname) },
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
      action: { store.send(.tappedLogout) },
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
      store.send(.tappedSignOut(userId: store.userId))
    }, label: {
      Text("회원탈퇴")
        .underline(pattern: .solid)
        .baselineOffset(4)
    })
    .wineyFont(.captionM1)
    .foregroundColor(.wineyGray700)
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
