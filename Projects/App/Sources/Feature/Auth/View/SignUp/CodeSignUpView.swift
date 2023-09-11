//
//  CodeSignUpView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

struct CodeSignUpView: View {
  private let store: StoreOf<CodeSignUp>
  @ObservedObject var viewStore: ViewStoreOf<CodeSignUp>
  @FocusState private var isTextFieldFocused: Bool
  
  public init(store: StoreOf<CodeSignUp>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    GeometryReader {_ in
      VStack(spacing: 0) {
        NavigationBar(
          leftIcon: Image("navigationBack_button"),
          leftIconButtonAction: {
            viewStore.send(.tappedBackButton)
          })
        
        HStack(alignment: .firstTextBaseline) {
          Text("인증번호를 입력해주세요")
            .wineyFont(.title1)
          Spacer()
        }
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
        .padding(.bottom, 54)
        
        CustomTextField(
          mainTitle: "인증번호",
          placeholderText: "",
          errorMessage: "인증번호를 확인해주세요",
          inputText: viewStore.binding(
            get: \.inputCode,
            send: CodeSignUp.Action.edited
          ),
          textStyle: { $0 },
          maximumInputCount: 6,
          isInputTextCompleteCondition: { text in
            text.count == 6
          },
          onEditingChange: { }
        )
        .focused($isTextFieldFocused)
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
        .padding(.bottom, 15)
        
        HStack(spacing: 10) {
          Text("인증번호가 오지 않나요?")
            .wineyFont(.bodyM2)
          
          Button(
            action: {
              viewStore.send(.tappedReSendCodeButton)
            },
            label: {
              VStack(spacing: 0) {
                Text("인증번호 재전송")
                  .wineyFont(.bodyB2)
                  .offset(y: -0.5)
                  .overlay(alignment: .bottom) {
                    Rectangle()
                      .frame(height: 1.5)
                  }
              }
            }
          )
          
          Spacer()
        }
        .foregroundColor(
          WineyKitAsset.gray500.swiftUIColor
        )
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
        
        Spacer()
        
        WineyConfirmButton(
          title: "다음",
          validBy:
            viewStore.state.validCode,
          action: {
            viewStore.send(.tappedCodeConfirmButton)
          }
        )
        .padding(
          .horizontal,
          WineyGridRules
            .globalHorizontalPadding
        )
        .padding(.bottom, WineyGridRules.bottomButtonPadding)
      }
    }
    .bottomSheet(
      backgroundColor: WineyKitAsset.gray950.swiftUIColor,
      isPresented: viewStore.binding(
        get: \.isPresentedBottomSheet,
        send: .tappedOutsideOfBottomSheet
      ),
      headerArea: {
        CodeSignUpBottomSheetHeader()
      },
      content: {
        CodeSignUpBottomSheetContent(
          store: self.store
        )
      },
      bottomArea: {
        HStack {
          CodeSignUpBottomSheetFooter(
            store: store 
          )
        }
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
    )
    .onChange(of: viewStore.state.isPresentedBottomSheet ) { sheetAppear in
      if sheetAppear {
        UIApplication.shared.endEditing()
      }
    }
    .navigationBarHidden(true)
  }
  
  func formatPhoneNumber(_ number: String) -> String {
    var digits = number.filter { $0.isNumber }
    if digits.count > 3 {
      digits.insert("-", at: digits.index(digits.startIndex, offsetBy: 3))
    }
    if digits.count > 8 {
      digits.insert("-", at: digits.index(digits.startIndex, offsetBy: 8))
    }
    return String(digits)
  }
}

struct CodeSignUpView_Previews: PreviewProvider {
  static var previews: some View {
    CodeSignUpView(
      store: Store(
        initialState: .init(),
        reducer: { CodeSignUp() }
      )
    )
  }
}
