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

struct PhoneSignUpView: View {
  private let store: StoreOf<PhoneSignUp>
  
  public init(store: StoreOf<PhoneSignUp>) {
    self.store = store
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        NavigationBar(
          leftIcon: Image(.navigationBack_buttonW)
          ,
          leftIconButtonAction: {
            store.send(.tappedBackButton)
          },
          backgroundColor: .wineyMainBackground
        )
        
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
          inputText: .init(
            get: { store.inputPhoneNumber },
            set: { text in store.send(.edited(inputText: text))}
          ),
          textStyle: formatPhoneNumber(_:),
          maximumInputCount: 11,
          completeCondition: store.inputPhoneNumber.count == 11, 
          textDeleteButton: Image(.text_delete_iconW),
          keyboardType: .numberPad,
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
          validBy: store.state.validPhoneNumber,
          action: {
            store.send(.tappedNextButton)
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
        set: { text in store.send(.tappedOutsideOfBottomSheet) }
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
        SignUpBottomSheetFotter(
          bottomSheetType: store.state.bottomSheetType,
          tappedAlreadySignUpConfirm: {
            store
              .send(._presentBottomSheet(false))
            store.send(
              .tappedBackButton
            )
          },
          tappedSendCodeConfirm: {
            store.send(.tappedBottomCodeSendConfirmButton)
          },
          tappedCodeDelayMinuteConfirm: {
            store
              .send(._presentBottomSheet(false))
          }
        )
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
    )
    .onDisappear {
      store.send(._disappear)
    }
    .onChange(of: store.isPresentedBottomSheet ) { sheetAppear in
      if sheetAppear {
        UIApplication.shared.endEditing()
      }
    }
    .background(.wineyMainBackground)
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
    PhoneSignUpView(
      store: StoreOf<PhoneSignUp>(
        initialState: .init(),
        reducer: { PhoneSignUp() }
      )
    )
  }
}
