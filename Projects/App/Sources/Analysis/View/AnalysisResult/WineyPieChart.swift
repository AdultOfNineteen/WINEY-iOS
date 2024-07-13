//
//  WineyPieChart.swift
//  Winey
//
//  Created by 정도현 on 7/8/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import SwiftUI
import WineyKit

public struct PieSliceData: Identifiable {
  public var id: Int {
    self.rank
  }
  
  var startAngle: Angle
  var endAngle: Angle
  var categoryText: String
  var percentage: String
  var rank: Int
}

public struct WineyPieChart: View {
  public let preferWineTypes: [TopType]
  
  public init(preferWineTypes: [TopType]) {
    self.preferWineTypes = preferWineTypes
  }
  
  public var body: some View {
    GeometryReader { geo in
      ZStack {
        ForEach(sliceData) { data in
          chartGraph(startAngle: data.startAngle, endAngle: data.endAngle, rank: data.rank)
            .scaleEffect(data.rank == 0 ? 1.02 : 0.94)
          
          chartText(data: data)
        }
        
        Circle()
          .fill(WineyKitAsset.mainBackground.swiftUIColor)
          .frame(width: geo.size.width / 3)
          .position(x: geo.size.width / 2, y: geo.size.height / 2)
      }
    }
  }
  
  private var sliceData: [PieSliceData] {
    let total = preferWineTypes.reduce(0) { $0 + $1.percent }
    var sliceData: [PieSliceData] = []
    
    var startAngle = Angle.zero
    
    for (i, value) in preferWineTypes.enumerated() {
      let itemAngle = Angle(degrees: Double(value.percent) * 360 / Double(total))   /// 각 아이템이 차지하는 비율
      let endAngle = startAngle + itemAngle
      
      sliceData.append(
        PieSliceData(
          startAngle: startAngle,
          endAngle: startAngle + itemAngle,
          categoryText: WineType.changeType(at: value.type).korName,
          percentage: value.percent.description,
          rank: i
        )
      )
      
      startAngle = endAngle
    }
    
    return sliceData
  }
}

private extension WineyPieChart {
  
  /// 파이 차트에서 그래프 부분을 담당합니다.
  private func chartGraph(startAngle: Angle, endAngle: Angle, rank: Int) -> some View {
    GeometryReader { geo in
      let path = Path { path in
        path.addArc(
          center: CGPoint(
            x: geo.size.width / 2,
            y: geo.size.height / 2
          ),
          radius: geo.size.width / 3.8,
          startAngle: startAngle,
          endAngle: endAngle,
          clockwise: false
        )
        
        path.addLine(
          to: CGPoint(
            x: geo.size.width / 2,
            y: geo.size.height / 2
          )
        )
        path.closeSubpath()
      }
      
      ZStack {
        path.fill(gaugeColor(rank: rank))
        path.stroke(WineyKitAsset.mainBackground.swiftUIColor, lineWidth: 5)
      }
    }
    .rotationEffect(.degrees(-90))
  }
  
  /// 차트 데이터 텍스트 부분을 담당합니다.
  @ViewBuilder
  private func chartText(data: PieSliceData) -> some View {
    GeometryReader { geo in
      let midRadians = Double.pi / 2 - (data.startAngle + data.endAngle).radians / 2 + textAdjustment(rank: data.rank)
      let radius = geo.size.width / 3.8 + textPadding(rank: data.rank)
      
      ZStack {
        VStack(spacing: 0) {
          HStack(spacing: 1) {
            Circle()
              .fill(gaugeColor(rank: data.rank))
              .frame(width: 7)
              .offset(y: -14)
            
            Text(data.categoryText)
          }
          
          if data.rank == 0 {
            Text(data.percentage.description + "%")
              .padding(.top, 4)
          }
        }
        .foregroundColor(descriptionColor(rank: data.rank))
        .wineyFont(chartFont(rank: data.rank))
      }
      .position(
        x: CGFloat(geo.size.width / 2 + radius * cos(midRadians)),
        y: CGFloat(geo.size.height / 2 - radius * sin(midRadians))
      )
    }
  }
}

private extension WineyPieChart {
  
  /// 파이 그래프에서 텍스트 부분 - 그래프 간의 패딩 값을 조정합니다.
  func textPadding(rank: Int) -> CGFloat {
    switch rank {
    case 1:
      return 24
    case 2:
      return 20
    default:
      return 56
    }
  }
  
  /// 파이 그래프에서 텍스트의 전, 후 offset을 조정합니다. + 될수록 차지하는 파이에서 앞쪽으로 텍스트 배치
  func textAdjustment(rank: Int) -> Double {
    switch rank {
    case 1:
      return 0.1
    case 2:
      return 0.14
    default:
      return 0.0
    }
  }
  
  func chartFont(rank: Int) -> WineyFontType {
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
  
  func descriptionColor(rank: Int) -> Color {
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
  
  func gaugeColor(rank: Int) -> Color {
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
}

#Preview {
  WineyPieChart(
    preferWineTypes: [
      TopType(type: "SPARKLING", percent: 70),
      TopType(type: "RED", percent: 30),
      TopType(type: "WHITE", percent: 40)
    ]
  )
}
