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
  let store: StoreOf<SignOut>

  @FocusState private var isFocused: Bool  
  let rows: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0), count: 2)

  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      navigationBarSpacer
      
      ScrollView(showsIndicators: false) {
        LazyVStack(alignment: .leading, spacing: 0) {
          signOutDescription
          
          signOutReason
          
          if store.selectedSignOutOption == .etc {
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
      isPresented: .init(get: {
        store.isOptionListShow
      }, set: { _ in
        store.send(._closeOption)
      }),
      content: {
        ZStack {
          Color.wineyGray950.ignoresSafeArea(edges: .all)
          
          signOutReasonList
        }
        .presentationDetents([.fraction(507/812)])
        .presentationDragIndicator(.visible)
      }
    )
    .background(.wineyMainBackground)
    .onTapGesture {
      isFocused = false
    }
    .navigationBarHidden(true)
  }
  
  var navigationBarSpacer: some View {
    NavigationBar(
      title: "회원 탈퇴",
      leftIcon: Image(.navigationBack_buttonW),
      leftIconButtonAction: {
        store.send(.tappedBackButton)
      },
      backgroundColor: .wineyMainBackground
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
      .foregroundColor(.wineyGray50)
      
      Text("계정을 삭제하면 희연님의 모든 리뷰 게시글 , 이용 하신 정보들이 삭제됩니다.계정 삭제 후 7일간 다시 가입할 수 없어요.")
        .wineyFont(.bodyB2)
        .foregroundColor(.wineyGray600)
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
      .foregroundColor(.wineyGray50)
      
      VStack(spacing: 13) {
        HStack(alignment: .center, spacing: 0) {
          Text(store.selectedSignOutOption?.rawValue ?? "이유를 선택해주세요.")
          
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
        .wineyMainBackground
      )
      .foregroundStyle(.white)
      .onTapGesture {
        store.send(.tappedSignOutReason)
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
              .overlay(.wineyGray900)
          }
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .onTapGesture {
          store.send(.tappedSignOutOption(option))
        }
      }
    }
  }
  
  var etcReasonField: some View {
    VStack(spacing: 10) {
      TextField(
        "이유를 작성해주세요 :)",
        text: .init(get: {
          store.userReason
        }, set: { reason in
          store.send(._writingReason(reason))
        }),
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
          .stroke(isFocused ? .white : .wineyGray800)
      )
      .onChange(of: store.userReason, perform: { value in
        if value.count > store.maxCommentLength {
          store.send(._limitMemo(value))
        }
      })
      .tint(.white)
      .focused($isFocused)
      
      HStack {
        Spacer()
        
        Text("\(store.userReason.count)/\(store.maxCommentLength)")
          .wineyFont(.bodyM2)
          .foregroundStyle(.wineyGray500)
      }
    }
  }
  
  var bottomButton: some View {
    WineyConfirmButton(
      title: "다음",
      validBy: store.selectedSignOutOption != nil && (store.selectedSignOutOption != .etc || !store.userReason.isEmpty),
      action: {
        store.send(
          .tappedNextButton(
            userId: store.userId,
            selectedOption: store.selectedSignOutOption!,
            userReason: store.userReason
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
