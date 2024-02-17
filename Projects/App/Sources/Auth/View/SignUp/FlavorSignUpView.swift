//
//  TasteSignUpView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

struct FlavorSignUpView: View {
  private let store: StoreOf<FlavorSignUp>
  @ObservedObject var viewStore: ViewStoreOf<FlavorSignUp>
  
  public init(store: StoreOf<FlavorSignUp>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        leftIcon: Image("navigationBack_button"),
        leftIconButtonAction: {
          viewStore.send(.tappedBackButton)
        },
        backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
      )
      .overlay(alignment: .trailing) {
        Text("\(viewStore.state.pageState.rawValue)/3")
          .padding(.trailing, WineyGridRules.globalHorizontalPadding)
          .foregroundColor(WineyKitAsset.gray500.swiftUIColor)
          .wineyFont(.bodyB2)
      }
      
      VStack(alignment: .leading, spacing: 14) {
        HStack(alignment: .firstTextBaseline) {
          Text("어떤 맛을 좋아하시나요?")
            .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
            .wineyFont(.title1)
          Spacer()
        }
        
        Text("좋아하실만한 와인을 추천해드릴게요!")
          .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
          .wineyFont(.bodyM2)
      }
      .padding(.leading, WineyGridRules.globalHorizontalPadding)
      .padding(.bottom, 77)
      
      Text("\(viewStore.state.pageState.question())")
        .wineyFont(.captionB1)
        .foregroundColor(.white)
        .padding(.horizontal, 22)
        .padding(.vertical, 11)
        .background {
          RoundedRectangle(cornerRadius: 50)
            .fill(WineyKitAsset.main1.swiftUIColor)
        }
        .padding(.bottom, 31)
      
      HStack {
        if viewStore.state.pageState.rawValue == 1 {
          chocolateView
            // .transition(.slideInAndOut(edge: viewStore.transitionEdge))
        } else if viewStore.state.pageState.rawValue == 2 {
          coffeeView
            // .transition(.slideInAndOut(edge: viewStore.transitionEdge))
        } else {
          fruitView
            // .transition(.slideInAndOut(edge: viewStore.transitionEdge))
        }
      }
      .padding(.horizontal, 24)
      .animation(.spring(duration: 0.6), value: viewStore.state.pageState.rawValue)
      
      Spacer()
      
      if viewStore.state.pageState.rawValue == 3 {
        WineyConfirmButton(
          title: "확인",
          validBy: viewStore.bottomButtonStatus
        ){
          
        }
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
        .padding(.bottom, 54)
      }
    }
    .ignoresSafeArea(edges: .bottom)
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
        CustomVStack(text1: "진행을 중단하고 처음으로", text2: "되돌아가시겠어요?")
      },
      bottomArea: {
        TwoOptionSelectorButtonView(
          leftTitle: "아니오",
          leftAction: {
            viewStore.send(._presentBottomSheet(false))
          },
          rightTitle: "예",
          rightAction: {
            viewStore.send(._backToFirstView)
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
    .background(WineyKitAsset.mainBackground.swiftUIColor)
    .navigationBarHidden(true)
  }
  
  var chocolateView: some View {
    HStack(spacing: 21) {
      FlavorCheckButton(
        mainTitle: ChocolateFlavor.milk.title,
        subTitle: ChocolateFlavor.milk.subTitle,
        isSelected: viewStore.userCheck.chocolate == .milk,
        action: {
          viewStore.send(.tappedChocolateButton(.milk))
        }
      )
      
      FlavorCheckButton(
        mainTitle: ChocolateFlavor.dark.title,
        subTitle: ChocolateFlavor.dark.subTitle,
        isSelected: viewStore.userCheck.chocolate == .dark,
        action: {
          viewStore.send(.tappedChocolateButton(.dark))
        }
      )
    }
  }
  
  var coffeeView: some View {
    HStack(spacing: 21) {
      FlavorCheckButton(
        mainTitle: CoffeeFlavor.americano.title,
        subTitle: CoffeeFlavor.americano.subTitle,
        isSelected: viewStore.userCheck.coffee == .americano,
        action: {
          viewStore.send(.tappedCoffeeButton(.americano))
        }
      )
      
      FlavorCheckButton(
        mainTitle: CoffeeFlavor.cafe_latte.title,
        subTitle: CoffeeFlavor.cafe_latte.subTitle,
        isSelected: viewStore.userCheck.coffee == .cafe_latte,
        action: {
          viewStore.send(.tappedCoffeeButton(.cafe_latte))
        }
      )
    }
  }
  
  var fruitView: some View {
    HStack(spacing: 21) {
      FlavorCheckButton(
        mainTitle: FruitFlavor.peach.title,
        subTitle: FruitFlavor.peach.subTitle,
        isSelected: viewStore.userCheck.fruit == .peach,
        action: {
          viewStore.send(.tappedFruitButton(.peach))
        }
      )
      
      FlavorCheckButton(
        mainTitle: FruitFlavor.pineapple.title,
        subTitle: FruitFlavor.pineapple.subTitle,
        isSelected: viewStore.userCheck.fruit == .pineapple,
        action: {
          viewStore.send(.tappedFruitButton(.pineapple))
        }
      )
    }
  }
}

struct FlavorSignUpView_Previews: PreviewProvider {
  static var previews: some View {
    FlavorSignUpView(
      store: StoreOf<FlavorSignUp>(
        initialState: .init(),
        reducer: { FlavorSignUp() }
      )
    )
  }
}

extension AnyTransition {
  static func slideInAndOut(edge: Edge) -> AnyTransition {
    let insertion = AnyTransition.move(edge: .trailing)
      .combined(with: .opacity)
    let removal = AnyTransition.move(edge: edge)
      .combined(with: .opacity)
    return .asymmetric(insertion: insertion, removal: removal)
  }
}
