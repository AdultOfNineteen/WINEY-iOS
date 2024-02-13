//
//  SignOutConfirmView.swift
//  MyPageFeature
//
//  Created by 정도현 on 1/31/24.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct SignOutConfirmView: View {
  private let store: StoreOf<SignOutConfirm>
  @ObservedObject var viewStore: ViewStoreOf<SignOutConfirm>
  
  public init(store: StoreOf<SignOutConfirm>) {
    self.store = store
    self.viewStore = ViewStore(
      self.store,
      observe: { $0 }
    )
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      navigationBar
      
      signOutDescription
      
      confirmText
      
      Spacer()
      
      signOutButton
    }
    .bottomSheet(
      backgroundColor: WineyKitAsset.gray950.swiftUIColor,
      isPresented: viewStore.binding(
        get: \.isPresentedBottomSheet,
        send: .tappedOutsideSheet
      ),
      headerArea: {
        BadgeBottomSheetHeader()
      },
      content: {
        Text("탈퇴가 완료되었어요\n언젠가 다시 만나요!")
          .wineyFont(.bodyB1)
          .foregroundStyle(WineyKitAsset.gray200.swiftUIColor)
      },
      bottomArea: {
        WineyConfirmButton(
          title: "확인",
          validBy: true,
          action: { viewStore.send(.tappedConfirmButton) }
        )
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
    )
    .navigationBarHidden(true)
    .background(
      WineyKitAsset.mainBackground.swiftUIColor
    )
    .ignoresSafeArea(edges: .bottom)
  }
  
  public var navigationBar: some View {
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
  
  public var signOutDescription: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("잠깐만요! 삭제하기 전에 확인해주세요.\n계정 삭제 후에는,")
        .foregroundStyle(.white)
        .wineyFont(.title2)
        .padding(.bottom, 30)
      
      signOutRules
      
      signOutDetailDescription
    }
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .padding(.top, 30)
  }
  
  public var signOutRules: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(alignment: .top, spacing: 0) {
        Text(" • ")
        Text("회원님의 모든 정보는 삭제됩니다.")
      }
      .padding(.bottom, 9)
      
      HStack(alignment: .top, spacing: 0) {
        Text(" • ")
        Text("서비스 이용 후기 등 일부 정보는 계속 남아있을 수 있습니다.")
      }
      .padding(.bottom, 18)
      
      HStack(alignment: .top, spacing: 0) {
        Text(" • ")
        Text("7일 동안 재가입할 수 없습니다.")
      }
      .padding(.bottom, 16)
      
      HStack(alignment: .top, spacing: 0) {
        Text(" • ")
        Text("현재 계정으로 다시 로그인할 수 없습니다.")
      }
    }
    .padding(.trailing, 34)
    .wineyFont(.bodyM2)
    .bold()
    .foregroundStyle(WineyKitAsset.gray600.swiftUIColor)
  }
  
  public var signOutDetailDescription: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text("아래의 계정 삭제 버튼을 누르면")
        .foregroundStyle(WineyKitAsset.gray600.swiftUIColor)
      Text("모든 정보와 활동 영구히 삭제되며,")
        .foregroundStyle(WineyKitAsset.gray600.swiftUIColor)
      Text("7일 동안 다시 가입할 수 없어요.")
        .foregroundStyle(WineyKitAsset.main3.swiftUIColor)
    }
    .padding(.top, 28)
    .wineyFont(.subhead)
    .bold()
  }
  
  public var confirmText: some View {
    Text("그래도 삭제하시겠습니까?")
      .wineyFont(.title2)
      .foregroundStyle(.white)
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      .padding(.top, 48)
  }
  
  public var signOutButton: some View {
    WineyConfirmButton(
      title: "계정 삭제",
      validBy: true,
      action: {
        viewStore.send(.tappedSignOutButton)
      }
    )
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .padding(.bottom, 54)
  }
}

#Preview {
  SignOutConfirmView(
    store: .init(
      initialState: .init(
        userId: 22,
        selectedSignOutOption: .etc,
        userReason: ""
      ),
      reducer: {
        SignOutConfirm()
      }
    )
  )
}
