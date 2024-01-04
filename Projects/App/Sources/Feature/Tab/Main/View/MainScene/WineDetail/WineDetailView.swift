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
              Text(viewStore.wineCardData.name.useNonBreakingSpace())
                .wineyFont(.bodyB2)
                .foregroundColor(WineyKitAsset.gray500.swiftUIColor)
                .frame(alignment: .topLeading)
              
              Spacer()
            }
            .padding(.top, 16)
          }
          
          Divider()
            .overlay(WineyKitAsset.gray900.swiftUIColor)
            .padding(.top, 20)
          
          WineDetailInfoMiddle(
            illustImage: WineType.changeType(at: viewStore.windDetailData?.type ?? "test").illustImage,
            circleBorderColor: WineType.changeType(at: viewStore.windDetailData?.type ?? "test").cirlcleBorderColor,
            secondaryColor: WineType.changeType(at: viewStore.windDetailData?.type ?? "test").backgroundColor.secondCircle,
            nationalAnthems: viewStore.windDetailData?.country ?? "error",
            varities: viewStore.windDetailData?.varietal ?? "error",
            purchasePrice: Int(viewStore.windDetailData?.wineSummary.avgPrice ?? 0)
          )
          .padding(.top, 42)
          
          Divider()
            .overlay(WineyKitAsset.gray900.swiftUIColor)
            .padding(.top, 36)
          
          // MARK: Wine Graph
          if let info = viewStore.windDetailData {
            WineDetailTabView(detail: info)
              .frame(height: 450)
          } else {
            ProgressView()
          }
        }
        .padding(.top, 14)
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
      .onAppear {
        viewStore.send(._viewWillAppear)
      }
    }
    .navigationBarHidden(true)
    .background(WineyKitAsset.mainBackground.swiftUIColor)
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

public func setupAppearance() {
  UIPageControl.appearance()
    .currentPageIndicatorTintColor = WineyKitAsset.point1.color
  UIPageControl.appearance()
    .pageIndicatorTintColor = WineyKitAsset.gray900.color
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
  private  let illustImage: Image
  private  let circleBorderColor: Color
  private  let secondaryColor: Color
  
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
        .aspectRatio(contentMode: .fit)
        .frame(width: UIScreen.main.bounds.width / 2.5)
      
      illustImage
    }
  }
}


// MARK: PREVIEW
//struct WineDetailView_Previews: PreviewProvider {
//  static var previews: some View {
//    WineDetailView(
//      store: Store(
//        initialState: WineDetail.State(
//          windId: 1,
//          wineCardData: WineCardData(
//            id: 1,
//            wineType: .red,
//            wineName: "test",
//            nationalAnthems: "test",
//            varities: "test",
//            purchasePrice: 1.22)
//        ), reducer: {
//          WineDetail()
//            .dependency(\.wine, .mock)
//        }
//      )
//    )
//  }
//}
