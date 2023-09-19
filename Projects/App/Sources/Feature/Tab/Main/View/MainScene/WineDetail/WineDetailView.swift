//
//  WineDetailView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/14.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct WineDetailView: View {
  private let store: StoreOf<WineDetail>
  @ObservedObject var viewStore: ViewStoreOf<WineDetail>
  
  public init(store: StoreOf<WineDetail>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "와인 상세정보",
        leftIcon: WineyAsset.Assets.navigationBackButton.swiftUIImage,
        leftIconButtonAction: {
          viewStore.send(.tappedBackButton)
        }
      )
      
      ScrollView {
        VStack(spacing: 0) {
          // MARK: WINE TYPE, NAME
          VStack(spacing: 0) {
            HStack {
              Text(viewStore.wineCardData.wineType.typeName)
                .wineyFont(.display1)
                .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
                .frame(height: 54, alignment: .topLeading)
              
              WineyAsset.Assets.star1.swiftUIImage
                .padding(.top, 14)
                .padding(.leading, 6)
              
              Spacer()
            }
            .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
            
            HStack {
              Text(viewStore.wineCardData.wineName.useNonBreakingSpace())
                .wineyFont(.bodyB2)
                .foregroundColor(WineyKitAsset.gray500.swiftUIColor)
                .frame(width: 271, height: 64, alignment: .topLeading)
              
              Spacer()
            }
            .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
          }
          
          Divider()
            .overlay(WineyKitAsset.gray900.swiftUIColor)
            .padding(.top, 20)
          
          WineInfoMiddle(
            illustImage: viewStore.wineCardData.wineType.illustImage,
            circleBorderColor: viewStore.wineCardData.wineType.cirlcleBorderColor,
            secondaryColor: viewStore.wineCardData.wineType.backgroundColor.secondCircle,
            nationalAnthems: viewStore.wineCardData.nationalAnthems,
            varities: viewStore.wineCardData.varities,
            purchasePrice: viewStore.wineCardData.purchasePrice
          )
          .padding(.top, 42)
          
          Divider()
            .overlay(WineyKitAsset.gray900.swiftUIColor)
            .padding(.top, 36)
          
          // MARK: Wine Graph
          WineDetailTabView()
          
            .frame(height: 450)
        }
        .padding(.top, 14)
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
    }
    .navigationBarHidden(true)
    .background(Color(red: 31/255, green: 33/255, blue: 38/255))
  }
}


public struct WineInfoMiddle: View {
  public let illustImage: Image
  public let circleBorderColor: Color
  public let secondaryColor: Color
  public let nationalAnthems: String
  public let varities: String
  public let purchasePrice: Double
  
  public init(
    illustImage: Image,
    circleBorderColor: Color,
    secondaryColor: Color,
    nationalAnthems: String,
    varities: String,
    purchasePrice: Double
  ) {
    self.illustImage = illustImage
    self.circleBorderColor = circleBorderColor
    self.secondaryColor = secondaryColor
    self.nationalAnthems = nationalAnthems
    self.varities = varities
    self.purchasePrice = purchasePrice
  }
  
  public var body: some View {
    HStack {
      WineDetailIllust(illustImage: illustImage, circleBorderColor: circleBorderColor, secondaryColor: secondaryColor)
      
      Spacer()
        .frame(minWidth: 24)
      
      VStack(spacing: 18) {
        // MARK: NATIONAL ANTHEMS
        VStack(alignment: .leading, spacing: 4) {
          HStack {
            Text("national an thems")
              .wineyFont(.captionM3)
            
            Spacer()
          }
          
          HStack {
            Text(nationalAnthems)
              .wineyFont(.captionB1)
            
            Spacer()
          }
        }
        
        // MARK: Varities
        VStack(alignment: .leading, spacing: 4) {
          HStack {
            Text("Varities")
              .wineyFont(.captionM3)
            
            Spacer()
          }
          
          HStack {
            Text(varities)
              .wineyFont(.captionB1)
            
            Spacer()
          }
        }
        
        // MARK: Purchase Price
        VStack(alignment: .leading, spacing: 4) {
          HStack {
            Text("Purchae price")
              .wineyFont(.captionM3)
            
            Spacer()
          }
          
          HStack {
            Text("\(String(format: "%.2f", purchasePrice))")
              .wineyFont(.captionB1)
            
            Spacer()
          }
        }
      }
      .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
      .frame(width: 148)
    }
  }
}

public struct WineDetailTabView: View {
  public var body: some View {
    TabView {
      WineDetailInfoSum()
      WineDetailGraph(category: "당도", originalStatistic: 1.0, peopleStatistic: 3.0)
      WineDetailGraph(category: "산도", originalStatistic: 4.0, peopleStatistic: 2.0)
      WineDetailGraph(category: "바디", originalStatistic: 3.0, peopleStatistic: 2.0)
      WineDetailGraph(category: "탄닌", originalStatistic: 5.0, peopleStatistic: 4.0)
    }
    .tabViewStyle(PageTabViewStyle())
    .onAppear {
      setupAppearance()
    }
  }
  
  func setupAppearance() {
    UIPageControl.appearance()
      .currentPageIndicatorTintColor = WineyKitAsset.point1.color
    UIPageControl.appearance()
      .pageIndicatorTintColor = WineyKitAsset.gray900.color
  }
}

public struct WineDetailInfoSum: View {
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack {
        Circle()
          .fill(WineyKitAsset.main3.swiftUIColor)
          .frame(width: 12, height: 12)
        
        Text("취향이 비슷한 사람들이 느낀 와인의 맛")
          .wineyFont(.captionM2)
        
      }
      .padding(.bottom, 10)
      
      HStack {
        Circle()
          .fill(WineyKitAsset.point1.swiftUIColor)
          .frame(width: 12, height: 12)
        
        Text("와인의 기본맛")
          .wineyFont(.captionM2)
        
      }
      .padding(.bottom, 35)
      
      VStack(spacing: 0) {
        WineInfoDetailGraph(peopleStatistic: 2.0, originalStatistic: 5.0, infoCategory: "당도")
        WineInfoDetailGraph(peopleStatistic: 4.0, originalStatistic: 1.0, infoCategory: "산도")
        WineInfoDetailGraph(peopleStatistic: 2.8, originalStatistic: 3.0, infoCategory: "바디")
        WineInfoDetailGraph(peopleStatistic: 5.0, originalStatistic: 4.0, infoCategory: "탄닌")
      }
      .padding(.bottom, 22)
    }
    .padding(.top, 30)
    .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
  }
}

// MARK: WINE INFO ILLUST
public struct WineDetailIllust: View {
  public let illustImage: Image
  public let circleBorderColor: Color
  public let secondaryColor: Color
  
  public init(
    illustImage: Image,
    circleBorderColor: Color,
    secondaryColor: Color
  ) {
    self.illustImage = illustImage
    self.circleBorderColor = circleBorderColor
    self.secondaryColor = secondaryColor
  }
  
  public var body: some View {
    ZStack {
      Circle()
        .fill(
          LinearGradient(
            gradient: Gradient(
              colors: [secondaryColor, secondaryColor.opacity(0)]
            ),
            startPoint: .top, endPoint: .bottom
          )
        )
        .background(
          Circle()
            .stroke(
              LinearGradient(
                colors: [circleBorderColor, circleBorderColor.opacity(0)],
                startPoint: .top, endPoint: .bottom
              )
            )
        )
        .frame(width: 148, height: 148)
      
      illustImage
    }
  }
}


// MARK: PREVIEW
struct WineDetailView_Previews: PreviewProvider {
  static var previews: some View {
    WineDetailView(
      store: Store(
        initialState: WineDetail.State(
          wineCardData: WineCardData(
            id: 1,
            wineType: .red,
            wineName: "test",
            nationalAnthems: "test",
            varities: "test",
            purchasePrice: 1.22)
        ), reducer: {
          WineDetail()
        }
      )
    )
  }
}
