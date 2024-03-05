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
  private let store: StoreOf<PhoneSignUp>
  @ObservedObject var viewStore: ViewStoreOf<PhoneSignUp>
  
  public init(store: StoreOf<PhoneSignUp>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        NavigationBar(
          leftIcon: Image("navigationBack_button")
          ,
          leftIconButtonAction: {
            viewStore.send(.tappedBackButton)
          },
          backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
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
          inputText: viewStore.binding(
            get: { $0.inputPhoneNumber },
            send: PhoneSignUp.Action.edited
          ),
          textStyle: formatPhoneNumber(_:),
          maximumInputCount: 13,
          completeCondition: viewStore.inputPhoneNumber.count == 13,
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
          validBy: viewStore.state.validPhoneNumber,
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
        SignUpBottomSheetHeader()
      },
      content: {
        SignUpBottomSheetContent(
          bottomSheetType: viewStore.state.bottomSheetType
        )
      },
      bottomArea: {
        SignUpBottomSheetFotter(
          bottomSheetType: viewStore.state.bottomSheetType,
          tappedAlreadySignUpConfirm: {
            viewStore
              .send(._presentBottomSheet(false))
            viewStore.send(
              .tappedBackButton
            )
          },
          tappedSendCodeConfirm: {
            viewStore.send(.tappedBottomCodeSendConfirmButton)
          },
          tappedCodeDelayMinuteConfirm: {
            viewStore
              .send(._presentBottomSheet(false))
          }
        )
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
    )
    .onDisappear {
      viewStore.send(._disappear)
    }
    .onChange(of: viewStore.state.isPresentedBottomSheet ) { sheetAppear in
      if sheetAppear {
        UIApplication.shared.endEditing()
      }
    }
    .background(WineyKitAsset.mainBackground.swiftUIColor)
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
      store: StoreOf<PhoneSignUp>(
        initialState: .init(),
        reducer: { PhoneSignUp() }
      )
    )
  }
}
