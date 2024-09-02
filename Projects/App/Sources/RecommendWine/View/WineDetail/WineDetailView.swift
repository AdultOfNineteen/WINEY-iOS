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
        },
        backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
      )
      
      ScrollView {
        LazyVStack(spacing: 0) {
          
          wineTypeName()
          
          divider()
          
          if let wineDetailData = viewStore.windDetailData {
            WineDetailInfoMiddleView(
              wineType: WineType.changeType(at: wineDetailData.type),
              nationalAnthems: wineDetailData.country,
              varities: wineDetailData.varietal,
              purchasePrice: Int(wineDetailData.wineSummary.avgPrice)
            )
            .padding(.top, 42)
            .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
          } else {
            ProgressView()
          }
          
          divider()
          
          wineGraph()
        }
        .padding(.top, 14)
      }
      .onAppear {
        viewStore.send(._viewWillAppear)
      }
    }
    .navigationBarHidden(true)
    .background(WineyKitAsset.mainBackground.swiftUIColor)
  }
}


extension WineDetailView {
  
  @ViewBuilder
  private func wineTypeName() -> some View {
    VStack(spacing: 0) {
      HStack {
        Text(viewStore.wineCardData.wineType.typeName)
          .wineyFont(.display1)
          .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
          .frame(height: 54, alignment: .topLeading)
        
        Spacer()
      }
      
      HStack {
        Text(viewStore.wineCardData.name.useNonBreakingSpace())
          .wineyFont(.bodyB2)
          .foregroundColor(WineyKitAsset.gray500.swiftUIColor)
          .frame(alignment: .topLeading)
        
        Spacer()
      }
      .padding(.top, 16)
    }
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
  
  @ViewBuilder
  private func wineGraph() -> some View {
    if let info = viewStore.windDetailData {
      WineDetailTabView(detail: info)
        .frame(height: 450)
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    } else {
      ProgressView()
    }
  }
  
  @ViewBuilder
  private func divider() -> some View {
    Divider()
      .frame(height: 0.8)
      .overlay(WineyKitAsset.gray900.swiftUIColor)
      .padding(.top, 20)
  }
}

public struct WineDetailTabView: View {
  private let detail: WineDTO
  
  init(detail: WineDTO) {
    self.detail = detail
  }
  
  public var body: some View {
    TabView {
      WineDetailInfoSum(detail: detail)
      WineDetailGraph(
        category: "당도",
        originalStatistic: Double(detail.sweetness),
        peopleStatistic: Double(
          detail
          .wineSummary
          .avgSweetness
        )
      )
      WineDetailGraph(
        category: "산도",
        originalStatistic: Double(detail.acidity),
        peopleStatistic: Double(
          detail
          .wineSummary
          .avgAcidity
        )
      )
      WineDetailGraph(
        category: "바디",
        originalStatistic: Double(detail.body),
        peopleStatistic: Double(
          detail
          .wineSummary
          .avgBody
        )
      )
      WineDetailGraph(
        category: "탄닌",
        originalStatistic: Double(detail.tannins),
        peopleStatistic: Double(
          detail
          .wineSummary
          .avgTannins
        )
      )
    }
    .tabViewStyle(PageTabViewStyle())
    .onAppear {
      setupAppearance()
    }
  }
}

public struct WineDetailInfoSum: View {
  private let detail: WineDTO
  
  init(detail: WineDTO) {
    self.detail = detail
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack {
        Circle()
          .fill(WineyKitAsset.main3.swiftUIColor)
          .frame(width: 12, height: 12)
        
        Text("테이스팅노트 기반 데이터")
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
        WineInfoDetailGraph(
          peopleStatistic: Double(
            detail
            .wineSummary
            .avgSweetness
          ),
          originalStatistic: Double(detail.sweetness),
          infoCategory: "당도"
        )
        WineInfoDetailGraph(
          peopleStatistic: Double(
            detail
            .wineSummary
            .avgAcidity
          ),
          originalStatistic: Double(detail.acidity),
          infoCategory: "산도"
        )
        WineInfoDetailGraph(
          peopleStatistic: Double(
            detail
            .wineSummary
            .avgBody
          ),
          originalStatistic: Double(detail.body),
          infoCategory: "바디"
        )
        WineInfoDetailGraph(
          peopleStatistic: Double(
            detail
            .wineSummary
            .avgTannins
          ),
          originalStatistic: Double(detail.tannins),
          infoCategory: "탄닌"
        )
      }
      .padding(.bottom, 22)
    }
    .padding(.top, 30)
    .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
  }
}

// MARK: WINE INFO ILLUST
public struct WineDetailIllust: View {
  
  let wineType: WineType
  
  public init(wineType: WineType) {
    self.wineType = wineType
  }
  
  public var body: some View {
    ZStack {
      Circle()
        .fill(
          LinearGradient(
            gradient: Gradient(
              colors: [wineType.backgroundColor.secondCircle, wineType.backgroundColor.secondCircle.opacity(0)]
            ),
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .overlay(
          Circle()
            .strokeBorder(
              LinearGradient(
                colors: [
                  wineType.circleBorderColor,
                  wineType.circleBorderColor.opacity(0.2),
                  wineType.circleBorderColor.opacity(0)
                ],
                startPoint: .top, endPoint: .bottom
              ),
              lineWidth: 1
            )
        )
        .overlay(
          wineType.illustImage
            .resizable()
            .scaledToFit()
            .padding(.vertical, wineType == .red || wineType == .etc ? 26 : 18)
        )
    }
  }
}

#Preview {
  WineDetailView(
    store: .init(
      initialState: WineDetail.State.init(
        windId: 0,
        wineCardData: .init(
          id: 0,
          wineType: .red,
          name: "와인이름",
          country: "와인 생산지",
          varietal: "배리에이션",
          price: 30000
        )
      ),
      reducer: { WineDetail() }
    )
  )
}
