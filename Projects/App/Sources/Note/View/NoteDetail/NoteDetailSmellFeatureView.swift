//
//  NoteDetailSmellFeature.swift
//  Winey
//
//  Created by 정도현 on 10/19/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit

// MARK: DETAIL SMELL FEATURE
public struct NoteDetailSmellFeatureView: View {
  let circleColor: String
  let smellKeywordList: [String]
  
  public var body: some View {
    // MARK: FEATURE
    VStack(alignment: .leading, spacing: 0) {
      Text("Feature")
        .wineyFont(.display2)
      
      HStack(spacing: 7) {
        Circle()
          .fill(RadialGradient(
            colors: [
              Color(hex: circleColor),
              Color(hex: circleColor).opacity(0.5),
              .clear
            ],
            center: .center,
            startRadius: 0,
            endRadius: 20)
          )
          .frame(width: 40, height: 40)
        
        Divider()
          .overlay(WineyKitAsset.gray900.swiftUIColor)
        
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack {
            ForEach(smellKeywordList, id: \.self) { smell in
              Text(smell)
                .wineyFont(.captionB1)
                .padding(.horizontal, 10)
                .padding(.vertical, 9)
                .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
                .background(
                  Capsule()
                    .stroke(WineyKitAsset.gray900.swiftUIColor)
                )
            }
          }
          .padding(.leading, 2)
          .padding(.vertical, 4)
        }
      }
      .padding(.top, 20)
      
      HStack(spacing: -6) {
        Image("noteDetailArrowBody")
        Image("noteDetailArrowHeader")
      }
      .padding(.top, 8)
      .padding(.leading, 20)
      .frame(maxWidth: .infinity)
    }
  }
}

extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
  
  func toHex() -> String? {
    let uic = UIColor(self)
    guard let components = uic.cgColor.components, components.count >= 3 else {
      return nil
    }
    let r = Float(components[0])
    let g = Float(components[1])
    let b = Float(components[2])
    var a = Float(1.0)
    
    if components.count >= 4 {
      a = Float(components[3])
    }
    
    if a != Float(1.0) {
      return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
    } else {
      return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
  }
}

#Preview {
  NoteDetailSmellFeatureView(
    circleColor: "#213144",
    smellKeywordList: ["test", "Test"]
  )
}
