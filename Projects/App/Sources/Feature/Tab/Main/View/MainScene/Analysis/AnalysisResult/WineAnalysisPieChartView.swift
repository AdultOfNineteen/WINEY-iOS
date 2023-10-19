//
//  WineAnalysisInitView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

struct PieSliceData {
  var startAngle: Angle
  var endAngle: Angle
  var categoryText: String
  var percentage: String
}

public struct WineAnalysisPieChartView: View {
  private let store: StoreOf<WineAnalysisPieChart>
  @ObservedObject var viewStore: ViewStoreOf<WineAnalysisPieChart>
  
  public init(store: StoreOf<WineAnalysisPieChart>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    GeometryReader { geo in
      VStack(spacing: 0) {
        VStack(spacing: 0) {
          HStack(spacing: 0) {
            Text("지금까지")
              .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
            Text("\(viewStore.wineDrink)개의 와인을 마셨고,")
              .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
          }
          HStack(spacing: 0) {
            Text("\(viewStore.repurchase)개의 와인에 대해 재구매")
              .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
            Text("의향이 있어요!")
              .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
          }
        }
        .wineyFont(.captionM1)
        .padding(.top, 22)
        
        WinePieChart(
          values: viewStore.preferWineTypes.map{ $0.percent },
          names: viewStore.preferWineTypes.map{ $0.type }
        )
        .padding(.top, 50)
        
        Spacer()
        
        WineyAsset.Assets.arrowBottom.swiftUIImage
          .padding(.bottom, 64)
      }
    }
  }
}

public struct WinePieChart: View {
  public let values: [Int]
  public let names: [String]
  @State private var showGauge = false
  
  var slices: [PieSliceData] {
    let sum = values.reduce(0, +)
    var endDeg: Double = 0
    var tempSlices: [PieSliceData] = []
    
    for (i, value) in values.enumerated() {
      let degrees: Double = Double(value) * 360 / Double(sum)
      tempSlices.append(
        PieSliceData(
          startAngle: Angle(degrees: endDeg),
          endAngle: Angle(degrees: endDeg + degrees),
          categoryText: names[i],
          percentage: String(format: "%.0f%%", Double(value) * 100 / Double(sum))
        )
      )
      endDeg += degrees
    }
    return tempSlices
  }
  
  public var body: some View {
    VStack {
      GeometryReader { geometry in
        ZStack(alignment: .center) {
          
          ForEach(0..<self.values.count) { idx in
            PieSliceView(pieSliceData: self.slices[idx], rank: idx)
              .scaleEffect(idx == 0 ? 1.1 : 1.0)
          }
          
          Circle()
            .fill(WineyKitAsset.mainBackground.swiftUIColor)
            .frame(width: geometry.size.width / 3.4)
          
          Circle()
            .trim(from: showGauge ? 1 : 0, to: 1)
            .stroke(style: StrokeStyle(lineWidth: geometry.size.width / 4, lineJoin: .round))
            .frame(width: geometry.size.width / 4, height: geometry.size.height / 4)
            .foregroundColor(WineyKitAsset.mainBackground.swiftUIColor)
            .rotationEffect(.degrees(270))
        }
        .padding(.horizontal, 24)
      }
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
          withAnimation(.easeIn(duration: 1.0)) {
            showGauge = true
          }
        }
      }
    }
  }
}

struct PieSliceView: View {
  var pieSliceData: PieSliceData
  var rank: Int
  
  var descriptionFont: WineyFontType {
    switch rank {
    case 0:
      return WineyFontType.title2
    case 1:
      return WineyFontType.bodyB2
    case 2:
      return WineyFontType.captionB1
    default:
      return WineyFontType.title2
    }
  }
  
  var descriptionColor: Color {
    switch rank {
    case 0:
      return WineyKitAsset.gray50.swiftUIColor
    case 1:
      return WineyKitAsset.gray800.swiftUIColor
    case 2:
      return WineyKitAsset.gray900.swiftUIColor
    default:
      return WineyKitAsset.main1.swiftUIColor
    }
  }
  
  var gaugeColor: Color {
    switch rank {
    case 0:
      return WineyKitAsset.main1.swiftUIColor
    case 1:
      return WineyKitAsset.gray800.swiftUIColor
    case 2:
      return WineyKitAsset.gray900.swiftUIColor
    default:
      return WineyKitAsset.main1.swiftUIColor
    }
  }
  
  var midRadians: Double {
    return Double.pi / 2 - (pieSliceData.startAngle + pieSliceData.endAngle).radians / 2
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .center) {
        Path { path in
          path.addArc(
            center: CGPoint(
              x: geometry.size.width / 2,
              y: geometry.size.height / 2
            ),
            radius: geometry.size.width / 4,
            startAngle: Angle(degrees: -90.0) + pieSliceData.startAngle,
            endAngle: Angle(degrees: -90.0) + pieSliceData.endAngle,
            clockwise: false
          )
          path.addLine(
            to: CGPoint(
              x: geometry.size.width / 2,
              y: geometry.size.height / 2
            )
          )
          path.closeSubpath()
        }
        .fill(gaugeColor)
        .overlay(
          Path { path in
            path.addArc(
              center: CGPoint(
                x: geometry.size.width / 2,
                y: geometry.size.height / 2
              ),
              radius: geometry.size.width / 4,
              startAngle: Angle(degrees: -90.0) + pieSliceData.startAngle,
              endAngle: Angle(degrees: -90.0) + pieSliceData.endAngle,
              clockwise: false
            )
            path.addLine(
              to: CGPoint(
                x: geometry.size.width / 2,
                y: geometry.size.height / 2
              )
            )
            path.closeSubpath()
          }
            .stroke(WineyKitAsset.mainBackground.swiftUIColor, lineWidth: 5)
        )
        
        ZStack {
          VStack(spacing: 0) {
            HStack(spacing: 1) {
              Circle()
                .frame(width: 7)
                .offset(y: -14)
                .foregroundColor(gaugeColor)
              Text(pieSliceData.categoryText)
            }
            
            if rank == 0 {
              Text(pieSliceData.percentage)
                .padding(.top, 4)
            }
          }
          .foregroundColor(descriptionColor)
          .wineyFont(descriptionFont)
        }
        .offset(
          x: CGFloat(1.0 + geometry.size.width / 2.5 * cos(self.midRadians)),
          y: CGFloat(1.0 - geometry.size.width / 2.8 * sin(self.midRadians))
        )
      }
    }
  }
}

public struct WineAnalysisPieChartView_Previews: PreviewProvider {
  public static var previews: some View {
    WineAnalysisPieChartView(
      store: Store(
        initialState: WineAnalysisPieChart.State.init(
          wineDrink: 3,
          repurchase: 3, 
          preferWineTypes: []
        ),
        reducer: {
          WineAnalysisPieChart()
        }
      )
    )
  }
}
