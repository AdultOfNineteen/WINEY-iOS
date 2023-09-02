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
  private let store: Store<FlavorSignUpState, FlavorSignUpAction>
  
  public init(store: Store<FlavorSignUpState, FlavorSignUpAction>) {
    self.store = store
  }
    var body: some View {
      WithViewStore(store) { viewStore in
        VStack(spacing: 0) {
          NavigationBar(
            leftIcon: Image("navigationBack_button"),
            leftIconButtonAction: {
              viewStore.send(.tappedBackButton)
            }
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
          .padding(.bottom, 66)
          
          Text("\(viewStore.state.pageState.question())")
            .wineyFont(.captionB1)
            .foregroundColor(.white)
            .padding(.horizontal, 22)
            .padding(.vertical, 11)
            .background {
              RoundedRectangle(cornerRadius: 50)
                .fill(WineyKitAsset.main1.swiftUIColor)
            }
            .padding(.bottom, 20)
          
          HStack {
            if viewStore.state.pageState.rawValue == 1 {
              chocolateView
                .transition(.slideInAndOut(edge: .leading))
            } else if viewStore.state.pageState.rawValue == 2 {
              coffeeView
                .transition(.slideInAndOut(edge: .leading))
            } else {
              fruitView
                .transition(.slideInAndOut(edge: .leading))
            }
          }
          .padding(.horizontal, 24)
          .animation(.easeInOut, value: viewStore.state.pageState.rawValue)
          
          Spacer()
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
        .navigationBarHidden(true)
      }
    }
  
  var chocolateView: some View {
    WithViewStore(store) { viewStore in
      HStack(spacing: 21) {
        FlavorCheckButton(
          mainTitle: FlavorInfoProvider(flavor: ChocolateFlavor.milk).title,
          subTitle: FlavorInfoProvider(flavor: ChocolateFlavor.milk).subtitle,
          action: {
            viewStore.send(.tappedChocolateButton(.milk))
          }
        )
        
        FlavorCheckButton(
          mainTitle: FlavorInfoProvider(flavor: ChocolateFlavor.dark).title,
          subTitle: FlavorInfoProvider(flavor: ChocolateFlavor.dark).subtitle,
          action: {
            viewStore.send(.tappedChocolateButton(.dark))
          }
        )
      }
    }
  }
  
  var coffeeView: some View {
    WithViewStore(store) { viewStore in
      HStack(spacing: 21) {
        FlavorCheckButton(
          mainTitle: FlavorInfoProvider(flavor: CoffeeFlavor.americano).title,
          subTitle: FlavorInfoProvider(flavor: CoffeeFlavor.americano).subtitle,
          action: {
            viewStore.send(.tappedCoffeeButton(.americano))
          }
        )
        
        FlavorCheckButton(
          mainTitle: FlavorInfoProvider(flavor: CoffeeFlavor.latte).title,
          subTitle: FlavorInfoProvider(flavor: CoffeeFlavor.latte).subtitle,
          action: {
            viewStore.send(.tappedCoffeeButton(.latte))
          }
        )
      }
    }
  }
  
  var fruitView: some View {
    WithViewStore(store) { viewStore in
      HStack(spacing: 21) {
        FlavorCheckButton(
          mainTitle: FlavorInfoProvider(flavor: FruitFlavor.sweet).title,
          subTitle: FlavorInfoProvider(flavor: FruitFlavor.sweet).subtitle,
          action: {
            viewStore.send(.tappedFruitButton(.sweet))
          }
        )
        
        FlavorCheckButton(
          mainTitle: FlavorInfoProvider(flavor: FruitFlavor.sour).title,
          subTitle: FlavorInfoProvider(flavor: FruitFlavor.sour).subtitle,
          action: {
            viewStore.send(.tappedFruitButton(.sour))
          }
        )
      }
    }
  }
}

struct FlavorSignUpView_Previews: PreviewProvider {
  static var previews: some View {
    FlavorSignUpView(
      store: Store<FlavorSignUpState, FlavorSignUpAction>(
        initialState: .init(),
        reducer: setFlavorSignUpReducer,
        environment: SetFlavorSignUpEnvironment(
          mainQueue: .main,
          userDefaultsService: .live)
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
