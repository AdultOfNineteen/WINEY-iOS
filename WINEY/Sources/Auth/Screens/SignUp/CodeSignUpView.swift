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
  
  @FocusState private var isTextFieldFocused: Bool
  
  public init(store: StoreOf<CodeSignUp>) {
    self.store = store
  }
  
  public var body: some View {
    GeometryReader {_ in
      VStack(spacing: 0) {
        NavigationBar(
          leftIcon: Image(.navigationBack_buttonW),
          leftIconButtonAction: {
            store.send(.tappedBackButton)
          },
          backgroundColor: .wineyMainBackground
        )
        
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
          errorMessage: store.isShowVerifyError ? "인증번호를 확인해주세요 (\(store.codeVerifyCount)/5)" : "인증번호 6자리를 입력해주세요",
          inputText: .init(
            get: { store.inputCode },
            set: { code in store.send(.edited(inputText: code) )}
          ),
          textStyle: { $0 },
          maximumInputCount: 6,
          clockIndicator: store.codeValidateClock,
          completeCondition: store.inputCode.count == 6 && !store.isShowVerifyError,
          keyboardType: .numberPad,
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
              store.send(.tappedReSendCodeButton)
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
        .foregroundColor(.wineyGray700)
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
        
        Spacer()
        
        WineyConfirmButton(
          title: "다음",
          validBy: store.state.validCode && !store.state.isTimeOver,
          action: {
            store.send(.tappedCodeConfirmButton)
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
      backgroundColor: Color.wineyGray950,
      isPresented: .init(
        get: { store.isPresentedBottomSheet },
        set: { _ in store.send(.tappedOutsideOfBottomSheet)}
      ),
      headerArea: {
        SignUpBottomSheetHeader()
      },
      content: {
        SignUpBottomSheetContent(
          bottomSheetType: store.state.bottomSheetType
        )
      },
      bottomArea: {
        HStack {
          SignUpBottomSheetFotter(
            bottomSheetType: store.state.bottomSheetType,
            tappedBackButtonNoOption: {
              store
                .send(._presentBottomSheet(false))
            },
            tappedBackButtonYesOption: {
              store
                .send(._backToFirstView)
            },
            tappedCodeFailConfirm: {
              store
                .send(._movePhoneNumberView)
            },
            tappedSendCodeConfirm: {
              store
                .send(._presentBottomSheet(false))
            },
            tappedBottomOverSendCodeButton: {
              store
                .send(._movePhoneNumberView)
            }
          )
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
    )
    .onChange(of: store.state.isPresentedBottomSheet) { sheetAppear in
      if sheetAppear {
        UIApplication.shared.endEditing()
      }
    }
    .background(.wineyMainBackground)
    .navigationBarHidden(true)
    .onAppear {
      isTextFieldFocused = true
      store.send(._onAppear)
    }
    .onDisappear {
      store.send(._onDisappear)
    }
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
        initialState: .init(
          phoneNumber: "01012341234"
        ),
        reducer: { CodeSignUp() }
      )
    )
  }
}
