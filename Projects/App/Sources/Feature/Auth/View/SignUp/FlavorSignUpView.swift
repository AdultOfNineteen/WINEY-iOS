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
        GeometryReader {_ in
          VStack {
            
            NavigationBar(
              leftIcon: Image(systemName: "arrow.backward"),
              leftIconButtonAction: {
                viewStore.send(.tappedBackButton)
              }
            )
            .overlay(alignment: .trailing) {
              Text("\(viewStore.state.pageState.rawValue)/3")
                .padding(.trailing, 24)
                .foregroundColor(WineyKitAsset.gray500.swiftUIColor)
                .wineyFont(.bodyB2)
            }
            
            Text("어떤 맛을 좋아하시나요?")
            Text("좋아하실만한 와인을 추천해드릴게요!")
            
            Text("\(viewStore.state.pageState.question())")
              .wineyFont(.captionB1)
              .foregroundColor(.white)
              .padding(.horizontal, 22)
              .padding(.vertical, 11)
              .background {
                RoundedRectangle(cornerRadius: 50)
                  .fill(WineyKitAsset.main1.swiftUIColor)
              }
            
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
            .animation(.easeInOut, value: viewStore.state.pageState.rawValue)
            Spacer()
          }
          .bottomSheet(
            backgroundColor: Color.black,
            isPresented: viewStore.binding(
              get: \.isPresentedBottomSheet,
              send: .tappedOutsideOfBottomSheet
            ),
            headerArea: {
              Text("좌물쇠 그림")
            },
            content: {
              Text("진행을 중단하고 처음으로\n되돌아가시겠어요?")
            },
            bottomArea: {
              HStack {
                Button("아니오") {
                  viewStore.send(._presentBottomSheet(false))
                }
                Button("네") {
                  viewStore.send(._backToFirstView)
                }
              }
            }
          )
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
