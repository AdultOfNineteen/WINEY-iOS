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
  @ObservedObject var viewStore: ViewStoreOf<SettingVintage>
  
  public init(store: StoreOf<SettingVintage>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  @FocusState private var focusedField: FieldCategory?
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "와인 정보 입력",
        leftIcon: Image("navigationBack_button"),
        leftIconButtonAction: { viewStore.send(.tappedBackButton) },
        backgroundColor: .clear
      )
      
      VStack(spacing: 73) {
        vintageTextField(
          category: .vintage,
          userInput: viewStore.binding(
            get: \.vintage,
            send: SettingVintage.Action.editVintage
          )
        )
        
        vintageTextField(
          category: .price,
          userInput: viewStore.binding(
            get: \.price,
            send: SettingVintage.Action.editPrice
          )
        )
      }
      .padding(.top, 131)
      
      Spacer()
      
      BottomOptionButton(
        validation: viewStore.buttonState,
        tooltipVisible: false
      ) {
        viewStore.send(.tappedNextButton)
      }
    }
    .onChange(of: viewStore.vintage, perform: { newValue in
      viewStore.send(._checkVintageValue(newValue))
    })
    .onChange(of: viewStore.price, perform: { newValue in
      viewStore.send(._checkPriceValue(newValue))
    })
    .background(
      WineyKitAsset.mainBackground.swiftUIColor
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
          .tint(WineyKitAsset.main1.swiftUIColor)
          .focused($focusedField, equals: category)
          .padding(.leading, 51)
          
          Text(category.suffixString)
            .frame(width: 60)
            .wineyFont(.bodyB2)
            .foregroundStyle(WineyKitAsset.gray800.swiftUIColor)
        }
        
        Divider()
          .frame(height: 1)
          .overlay(
            focusedField == category ? .white : WineyKitAsset.gray900.swiftUIColor
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
      initialState: SettingVintage.State(
        wineId: 0,
        officialAlcohol: 1
      ),
      reducer: {
        SettingVintage()
      }
    )
  )
}
