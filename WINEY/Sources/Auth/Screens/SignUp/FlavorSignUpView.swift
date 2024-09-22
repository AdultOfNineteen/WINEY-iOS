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
  
  public init(store: StoreOf<FlavorSignUp>) {
    self.store = store
  }
  
  var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        leftIcon: Image(.navigationBack_buttonW),
        leftIconButtonAction: {
          store.send(.tappedBackButton)
        },
        backgroundColor: .wineyMainBackground
      )
      .overlay(alignment: .trailing) {
        Text("\(store.state.pageState.rawValue)/3")
          .padding(.trailing, WineyGridRules.globalHorizontalPadding)
          .foregroundColor(.wineyGray500)
          .wineyFont(.bodyB2)
      }
      
      VStack(alignment: .leading, spacing: 14) {
        HStack(alignment: .firstTextBaseline) {
          Text("어떤 맛을 좋아하시나요?")
            .foregroundColor(.wineyGray50)
            .wineyFont(.title1)
          Spacer()
        }
        
        Text("좋아하실만한 와인을 추천해드릴게요!")
          .foregroundColor(.wineyGray700)
          .wineyFont(.bodyM2)
      }
      .padding(.leading, WineyGridRules.globalHorizontalPadding)
      .padding(.bottom, 77)
      
      Text("\(store.state.pageState.question())")
        .wineyFont(.captionB1)
        .foregroundColor(.white)
        .padding(.horizontal, 22)
        .padding(.vertical, 11)
        .background {
          RoundedRectangle(cornerRadius: 50)
            .fill(.wineyMain1)
        }
        .padding(.bottom, 31)
      
      HStack {
        if store.state.pageState.rawValue == 1 {
          chocolateView
            // .transition(.slideInAndOut(edge: store.transitionEdge))
        } else if store.state.pageState.rawValue == 2 {
          coffeeView
            // .transition(.slideInAndOut(edge: store.transitionEdge))
        } else {
          fruitView
            // .transition(.slideInAndOut(edge: store.transitionEdge))
        }
      }
      .padding(.horizontal, 24)
      .animation(.spring(duration: 0.6), value: store.state.pageState.rawValue)
      
      Spacer()
      
      if store.state.pageState.rawValue == 3 {
        WineyConfirmButton(
          title: "확인",
          validBy: store.bottomButtonStatus
        ){
          store.send(.tappedConfirmButton)
        }
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
        .padding(.bottom, 54)
      }
    }
    .ignoresSafeArea(edges: .bottom)
    .bottomSheet(
      backgroundColor: Color.wineyGray950,
      isPresented: .init(
        get: { store.isPresentedBottomSheet },
        set: { _ in store.send(.tappedOutsideOfBottomSheet)}
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
            store.send(._presentBottomSheet(false))
          },
          rightTitle: "예",
          rightAction: {
            store.send(._backToFirstView)
          }
        )
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
    )
    .onChange(of: store.isPresentedBottomSheet ) { sheetAppear in
      if sheetAppear {
        UIApplication.shared.endEditing()
      }
    }
    .background(.wineyMainBackground)
    .navigationBarHidden(true)
  }
  
  var chocolateView: some View {
    HStack(spacing: 21) {
      FlavorCheckButton(
        mainTitle: ChocolateFlavor.milk.title,
        subTitle: ChocolateFlavor.milk.subTitle,
        isSelected: store.userCheck.chocolate == .milk,
        action: {
          store.send(.tappedChocolateButton(.milk))
        }
      )
      
      FlavorCheckButton(
        mainTitle: ChocolateFlavor.dark.title,
        subTitle: ChocolateFlavor.dark.subTitle,
        isSelected: store.userCheck.chocolate == .dark,
        action: {
          store.send(.tappedChocolateButton(.dark))
        }
      )
    }
  }
  
  var coffeeView: some View {
    HStack(spacing: 21) {
      FlavorCheckButton(
        mainTitle: CoffeeFlavor.americano.title,
        subTitle: CoffeeFlavor.americano.subTitle,
        isSelected: store.userCheck.coffee == .americano,
        action: {
          store.send(.tappedCoffeeButton(.americano))
        }
      )
      
      FlavorCheckButton(
        mainTitle: CoffeeFlavor.cafe_latte.title,
        subTitle: CoffeeFlavor.cafe_latte.subTitle,
        isSelected: store.userCheck.coffee == .cafe_latte,
        action: {
          store.send(.tappedCoffeeButton(.cafe_latte))
        }
      )
    }
  }
  
  var fruitView: some View {
    HStack(spacing: 21) {
      FlavorCheckButton(
        mainTitle: FruitFlavor.peach.title,
        subTitle: FruitFlavor.peach.subTitle,
        isSelected: store.userCheck.fruit == .peach,
        action: {
          store.send(.tappedFruitButton(.peach))
        }
      )
      
      FlavorCheckButton(
        mainTitle: FruitFlavor.pineapple.title,
        subTitle: FruitFlavor.pineapple.subTitle,
        isSelected: store.userCheck.fruit == .pineapple,
        action: {
          store.send(.tappedFruitButton(.pineapple))
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
