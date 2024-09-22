//
//  SettingVintageView.swift
//  Winey
//
//  Created by 정도현 on 11/12/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct SettingVintageView: View {
  private let store: StoreOf<SettingVintage>
  
  public init(store: StoreOf<SettingVintage>) {
    self.store = store
  }
  
  @FocusState private var focusedField: FieldCategory?
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "와인 정보 입력",
        leftIcon: Image(.navigationBack_buttonW),
        leftIconButtonAction: { store.send(.tappedBackButton) },
        backgroundColor: .clear
      )
      
      VStack(spacing: 73) {
        vintageTextField(
          category: .vintage,
          userInput: .init(
            get: { store.vintage },
            set: { edit in store.send(.editVintage(edit)) }
          )
        )
        
        vintageTextField(
          category: .price,
          userInput: .init(
            get: { store.price },
            set: { edit in store.send(.editPrice(edit)) }
          )
        )
      }
      .padding(.top, 131)
      
      Spacer()
      
      BottomOptionButton(
        validation: store.buttonState,
        tooltipVisible: store.tooltipVisible,
        action: { store.send(.tappedNextButton) },
        skipAction: { store.send(.tappedNextButton) }
      )
    }
    .onAppear {
      store.send(._viewWillAppear)
    }
    .onChange(of: store.vintage, perform: { newValue in
      store.send(._checkVintageValue(newValue))
    })
    .onChange(of: store.price, perform: { newValue in
      store.send(._checkPriceValue(newValue))
    })
    .background(
      .wineyMainBackground
    )
    .onTapGesture {
      focusedField = nil
    }
    .navigationBarHidden(true)
  }
}

extension SettingVintageView {
  private enum FieldCategory {
    case vintage
    case price
    
    public var title: String {
      switch self {
      case .vintage:
        return "빈티지를 입력해주세요!"
      case .price:
        return "구매 시 가격을 입력해주세요!"
      }
    }
    
    public var placeholder: String {
      switch self {
      case .vintage:
        return "ex ) 1990"
      case .price:
        return "ex ) 300000"
      }
    }
    
    public var suffixString: String {
      switch self {
      case .vintage:
        return "년도"
        
      case .price:
        return "원"
      }
    }
  }
  
  @ViewBuilder
  private func vintageTextField(
    category: FieldCategory,
    userInput: Binding<String>
  ) -> some View {
    VStack(spacing: 24) {
      Text(category.title)
        .wineyFont(.bodyB1)
      
      VStack(spacing: 7) {
        HStack {
          TextField(
            category.placeholder,
            text: userInput
          )
          .autocorrectionDisabled()
          .textInputAutocapitalization(.never)
          .wineyFont(.bodyM1)
          .frame(height: 26)
          .foregroundColor(.white)
          .keyboardType(.numberPad)
          .tint(.wineyMain1)
          .focused($focusedField, equals: category)
          .padding(.leading, 51)
          
          Text(category.suffixString)
            .frame(width: 60)
            .wineyFont(.bodyB2)
            .foregroundStyle(.wineyGray800)
        }
        
        Divider()
          .frame(height: 1)
          .overlay(
            focusedField == category ? .white : .wineyGray900
          )
      }
    }
    .onTapGesture {
      focusedField = category
    }
    .padding(.horizontal, 89)
  }
}

#Preview {
  SettingVintageView(
    store: Store(
      initialState: SettingVintage.State(),
      reducer: {
        SettingVintage()
      }
    )
  )
}
