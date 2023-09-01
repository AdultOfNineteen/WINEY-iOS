//
//  SignUpView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

struct SignUpView: View {
  private let store: Store<PhoneSignUpState, PhoneSignUpAction>
  
  public init(store: Store<PhoneSignUpState, PhoneSignUpAction>) {
    self.store = store
  }
    var body: some View {
      WithViewStore(store) { viewStore in
        GeometryReader { geometry in
          VStack(spacing: 0) {
            NavigationBar(
              leftIcon: Image("navigationBack_button")
              ,
              leftIconButtonAction: {
                viewStore.send(.tappedBackButton)
              })
            
            HStack(alignment: .firstTextBaseline) {
              Text("휴대폰 번호를 입력해주세요")
              .wineyFont(.title1)
              Spacer()
            }
            .padding(
              .leading,
              WineyGridRules
              .globalHorizontalPadding
            )
            
            CustomTextField(
              mainTitle: "전화번호",
              placeholderText: "11자리 입력",
              errorMessage: "올바른 번호를 입력해주세요",
              inputText: viewStore.binding(
                get: { $0.inputPhoneNumber },
                send: PhoneSignUpAction.edited
              ),
              textStyle: formatPhoneNumber(_:),
              maximumInputCount: 13,
              isInputTextCompleteCondition: { text in
                text.count == 13
              },
              onEditingChange: { }
            )
            .padding(
              .horizontal,
              WineyGridRules
              .globalHorizontalPadding
            )
            .padding(.top, 54)
            
            Spacer()
            
            WineyConfirmButton(
              title: "다음",
              validBy:
                viewStore.state.validPhoneNumber,
              action: {
                viewStore.send(.tappedNextButton)
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
            Image("rock_image")
          },
          content: {
            VStack(spacing: 14) {
              VStack(spacing: 2.4) {
                Text("인증번호가 발송되었어요")
                Text("3분 안에 인증번호를 입력해주세요")
              }
              .foregroundColor(WineyKitAsset.gray200.swiftUIColor)
              .wineyFont(.bodyB1)
              
              Text("*인증번호 요청 3회 초과 시 5분 제한")
                .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
                .wineyFont(.captionM2)
            }
          },
          bottomArea: {
            WineyConfirmButton(
              title: "확인",
              validBy: true,
              action: {
                viewStore.send(.tappedBottomCodeSendConfirmButton)
              }
            )
            .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
          }
        )
        .onChange(of: viewStore.state.isPresentedBottomSheet ) { sheetAppear in
          if sheetAppear {
            UIApplication.shared.endEditing()
          }
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

struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
    SignUpView(
      store: Store<PhoneSignUpState, PhoneSignUpAction>(
        initialState: .init(),
        reducer: setPhoneSignUpReducer,
        environment: SetPhoneSignUpEnvironment(
          mainQueue: .main,
          userDefaultsService: .live)
      )
    )
  }
}
