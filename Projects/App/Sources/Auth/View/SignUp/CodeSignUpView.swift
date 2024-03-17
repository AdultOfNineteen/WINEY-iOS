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
          },
          backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
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
          errorMessage: viewStore.isShowVerifyError ? "인증번호를 확인해주세요 (\(viewStore.codeVerifyCount)/5)" : "인증번호 6자리를 입력해주세요",
          inputText: viewStore.binding(
            get: \.inputCode,
            send: CodeSignUp.Action.edited
          ),
          textStyle: { $0 },
          maximumInputCount: 6,
          clockIndicator: viewStore.codeValidateClock,
          completeCondition: viewStore.inputCode.count == 6 && !viewStore.isShowVerifyError,
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
          WineyKitAsset.gray700.swiftUIColor
        )
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
        
        Spacer()
        
        WineyConfirmButton(
          title: "다음",
          validBy: viewStore.state.validCode && !viewStore.state.isTimeOver,
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
        SignUpBottomSheetHeader()
      },
      content: {
        SignUpBottomSheetContent(
          bottomSheetType: viewStore.state.bottomSheetType
        )
      },
      bottomArea: {
        HStack {
          SignUpBottomSheetFotter(
            bottomSheetType: viewStore.state.bottomSheetType,
            tappedBackButtonNoOption: {
              viewStore
                .send(._presentBottomSheet(false))
            },
            tappedBackButtonYesOption: {
              viewStore
                .send(._backToFirstView)
            },
            tappedCodeFailConfirm: {
              viewStore
                .send(._movePhoneNumberView)
            },
            tappedSendCodeConfirm: {
              viewStore
                .send(._presentBottomSheet(false))
            },
            tappedBottomOverSendCodeButton: {
              viewStore
                .send(._movePhoneNumberView)
            }
          )
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
    )
    .onChange(of: viewStore.state.isPresentedBottomSheet) { sheetAppear in
      if sheetAppear {
        UIApplication.shared.endEditing()
      }
    }
    .background(WineyKitAsset.mainBackground.swiftUIColor)
    .navigationBarHidden(true)
    .onAppear {
      isTextFieldFocused = true
      viewStore.send(._onAppear)
    }
    .onDisappear {
      viewStore.send(._onDisappear)
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
