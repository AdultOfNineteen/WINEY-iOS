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
  @FocusState private var isFocused: Bool
  
  let rows: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0), count: 2)
  
  public init(store: StoreOf<SignOut>) {
    self.store = store
    self.viewStore = ViewStore(
      self.store,
      observe: { $0 }
    )
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      navigationBarSpacer
      
      ScrollView(showsIndicators: false) {
        LazyVStack(alignment: .leading, spacing: 0) {
          signOutDescription
          
          signOutReason
          
          if viewStore.selectedSignOutOption == .etc {
            etcReasonField
          }
        }
        .padding(.top, 20)
      }
      
      Spacer()
      
      bottomButton
    }
    .padding(
      .horizontal,
      WineyGridRules
        .globalHorizontalPadding
    )
    .sheet(
      isPresented: viewStore.binding(
        get: \.isOptionListShow,
        send: ._closeOption
      ),
      content: {
        ZStack {
          WineyKitAsset.gray950.swiftUIColor.ignoresSafeArea(edges: .all)
          
          signOutReasonList
        }
        .presentationDetents([.fraction(507/812)])
        .presentationDragIndicator(.visible)
      }
    )
    .background(WineyKitAsset.mainBackground.swiftUIColor)
    .onTapGesture {
      isFocused = false
    }
    .navigationBarHidden(true)
  }
  
  var navigationBarSpacer: some View {
    NavigationBar(
      title: "회원 탈퇴",
      leftIcon: WineyAsset.Assets.navigationBackButton.swiftUIImage,
      leftIconButtonAction: {
        viewStore.send(.tappedBackButton)
      },
      backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
    )
    .padding(
      .horizontal,
      -WineyGridRules
        .globalHorizontalPadding
    )
  }
  
  var signOutDescription: some View {
    VStack(alignment: .leading, spacing: 0) {
      Group {
        Text("정말 탈퇴하시겠어요?")
          .padding(.bottom, 5)
        Text("이별하기 너무 아쉬워요.")
          .padding(.bottom, 20)
      }
      .wineyFont(.title2)
      .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
      
      Text("계정을 삭제하면 희연님의 모든 리뷰 게시글 , 이용 하신 정보들이 삭제됩니다.계정 삭제 후 7일간 다시 가입할 수 없어요.")
        .wineyFont(.bodyB2)
        .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
        .padding(.bottom, 30)
        .padding(.trailing, 50)
    }
  }
  
  var signOutReason: some View {
    VStack(alignment: .leading, spacing: 0) {
      Group {
        Text("계정을 삭제하려는")
          .padding(.bottom, 5)
        Text("이유를 알려주세요.")
          .padding(.bottom, 45)
      }
      .wineyFont(.title2)
      .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
      
      VStack(spacing: 13) {
        HStack(alignment: .center, spacing: 0) {
          Text(viewStore.selectedSignOutOption?.rawValue ?? "이유를 선택해주세요.")
          
          Spacer()
          
          Image(systemName: "chevron.down")
            .padding(.trailing, 12)
        }
        .wineyFont(.bodyB2)
        
        Divider()
          .frame(height: 1)
          .overlay(.white)
      }
      .background(
        WineyKitAsset.mainBackground.swiftUIColor
      )
      .foregroundStyle(.white)
      .onTapGesture {
        viewStore.send(.tappedSignOutReason)
      }
      .padding(.bottom, 30)
    }
  }
  
  var signOutReasonList: some View {
    VStack(alignment: .leading, spacing: 0) {
      ForEach(SignOutOptions.allCases, id: \.self) { option in
        VStack(alignment: .leading, spacing: 20) {
          Text(option.rawValue)
            .foregroundStyle(.white)
            .wineyFont(.bodyM1)
          
          if option != .etc {
            Divider()
              .frame(height: 0.8)
              .overlay(WineyKitAsset.gray900.swiftUIColor)
          }
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .onTapGesture {
          viewStore.send(.tappedSignOutOption(option))
        }
      }
    }
  }
  
  var etcReasonField: some View {
    VStack(spacing: 10) {
      TextField(
        "이유를 작성해주세요 :)",
        text: viewStore.binding(
          get: \.userReason,
          send: SignOut.Action._writingReason
        ),
        axis: .vertical
      )
      .lineLimit(8, reservesSpace: true)
      .wineyFont(.captionM1)
      .padding(.vertical, 14)
      .padding(.horizontal, 15)
      .autocorrectionDisabled()
      .textInputAutocapitalization(.never)
      .background(
        RoundedRectangle(cornerRadius: 10)
          .stroke(isFocused ? .white : WineyKitAsset.gray800.swiftUIColor)
      )
      .onChange(of: viewStore.userReason, perform: { value in
        if value.count > viewStore.maxCommentLength {
          viewStore.send(._limitMemo(value))
        }
      })
      .tint(.white)
      .focused($isFocused)
      
      HStack {
        Spacer()
        
        Text("\(viewStore.userReason.count)/\(viewStore.maxCommentLength)")
          .wineyFont(.bodyM2)
          .foregroundStyle(WineyKitAsset.gray500.swiftUIColor)
      }
    }
  }
  
  var bottomButton: some View {
    WineyConfirmButton(
      title: "다음",
      validBy: viewStore.selectedSignOutOption != nil && (viewStore.selectedSignOutOption != .etc || !viewStore.userReason.isEmpty),
      action: {
        viewStore.send(
          .tappedNextButton(
            userId: viewStore.userId,
            selectedOption: viewStore.selectedSignOutOption!,
            userReason: viewStore.userReason
          )
        )
      }
    )
    .padding(.bottom, WineyGridRules.bottomButtonPadding)
  }
}

#Preview {
  SignOutView(
    store: .init(
      initialState: .init(userId: 22),
      reducer: {
        SignOut()
      }
    )
  )
}
