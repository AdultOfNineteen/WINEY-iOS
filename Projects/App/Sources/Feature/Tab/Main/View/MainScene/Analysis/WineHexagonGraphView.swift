//
//  WineOxagonGraphView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/18.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit

public struct WineHexagonGraphView: View {
  public var body: some View {
    GeometryReader { geo in
      VStack(spacing: 0) {
        Text("선호하는 맛")
          .wineyFont(.title2)
          .padding(.top, 66)
        
        Spacer()
        
        HexagonGraphDataView()
        
        WineyAsset.Assets.arrowBottom.swiftUIImage
          .padding(.bottom, 64)
      }
      .frame(width: geo.size.width)
      
    }
  }
}

public struct HexagonView: View {
  var hexagonSize: CGFloat
  var color: Color
  var lineWidth: CGFloat
  
  public var body: some View {
    GeometryReader { geometry in
      Path { path in
        let size: CGFloat = hexagonSize
        let sideLength = size / 2 * sqrt(3)
        
        let centerX = geometry.size.width / 2
        let centerY = geometry.size.height / 2
        let points: [CGPoint] = [
          CGPoint(x: centerX, y: centerY - size),
          CGPoint(x: centerX + sideLength, y: centerY - size / 2),
          CGPoint(x: centerX + sideLength, y: centerY + size / 2),
          CGPoint(x: centerX, y: centerY + size),
          CGPoint(x: centerX - sideLength, y: centerY + size / 2),
          CGPoint(x: centerX - sideLength, y: centerY - size / 2)
        ]
        path.addLines(points)
        path.closeSubpath()
      }
      .stroke(color, lineWidth: lineWidth)
    }
  }
}

public struct HexagonDataView: View {
  @State var animation = 0.0
  var hexagonSize: CGFloat
  var sweat: CGFloat
  var remain: CGFloat
  var alcohol: CGFloat
  var tannin: CGFloat
  var wineBody: CGFloat
  var acid: CGFloat
  
  public var body: some View {
    GeometryReader { geometry in
      Path { path in
        let size: CGFloat = hexagonSize
        let sideLength = size / 2 * sqrt(3)
        
        let centerX = geometry.size.width / 2
        let centerY = geometry.size.height / 2
        
        let points: [CGPoint] = [
          CGPoint(x: centerX, y: centerY - size * sweat),
          CGPoint(x: centerX + sideLength * remain, y: centerY - size / 2 * remain),
          CGPoint(x: centerX + sideLength * alcohol, y: centerY + size / 2 * alcohol),
          CGPoint(x: centerX, y: centerY + size * tannin),
          CGPoint(x: centerX - sideLength * wineBody, y: centerY + size / 2 * wineBody),
          CGPoint(x: centerX - sideLength * acid, y: centerY - size / 2 * acid)
        ]
        path.addLines(points)
      }
      .fill(WineyKitAsset.main3.swiftUIColor.opacity(0.5))
      .scaleEffect(animation)
      .onAppear {
        withAnimation(.easeIn(duration: 1.0)) {
          animation = 1.0
        }
      }
    }
  }
}

public struct HexagonBackgroundView: View {
  public var body: some View {
    GeometryReader { geo in
      ZStack(alignment: .center) {
        HexagonView(
          hexagonSize: geo.size.width / 22,
          color: WineyKitAsset.gray900.swiftUIColor.opacity(0.5),
          lineWidth: 1.0
        )
        
        ForEach(1..<5) { i in
          HexagonView(
            hexagonSize: geo.size.width / 22 * CGFloat(i + 1),
            color: WineyKitAsset.gray900.swiftUIColor.opacity(0.5),
            lineWidth: 1.0
          )
        }
        
        HexagonView(
          hexagonSize: geo.size.width / 22 * 7,
          color: WineyKitAsset.gray900.swiftUIColor.opacity(0.8),
          lineWidth: 1.5
        )
        
        Text("당도")
          .offset(y: -geo.size.width / 3 - 10)
        Text("산도")
          .offset(x: -geo.size.width / 3, y: -geo.size.width / 5 + 15)
        Text("여운")
          .offset(x: geo.size.width / 3, y: -geo.size.width / 5 + 15)
        Text("바디")
          .offset(x: -geo.size.width / 3, y: geo.size.width / 5 - 15)
        Text("알코올")
          .offset(x: geo.size.width / 3 + 5, y: geo.size.width / 5 - 15)
        Text("탄닌")
          .offset(y: geo.size.width / 3 + 10)
        
      }
      .wineyFont(.captionB1)
      .frame(width: geo.size.width)
    }
  }
}

public struct HexagonGraphDataView: View {
  public var body: some View {
    GeometryReader { geo in
      ZStack {
        HexagonBackgroundView()
        HexagonDataView(
          hexagonSize: geo.size.width / 22,
          sweat: 7,
          remain: 2,
          alcohol: 7,
          tannin: 2,
          wineBody: 6,
          acid: 3
        )
      }
      .frame(width: geo.size.width)
    }
    .onAppear {
      
    }
  }
}


public struct WineHexagonGraphView_Previews: PreviewProvider {
  public static var previews: some View {
    WineHexagonGraphView()
  }
}
