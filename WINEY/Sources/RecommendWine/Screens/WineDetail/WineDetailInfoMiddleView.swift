//
//  WineDetailInfoMiddleView.swift
//  Winey
//
//  Created by 정도현 on 10/19/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit

public enum DetailMode {
  case note
  case recommendWine
}

public struct WineDetailInfoMiddleView: View {
  public let wineType: WineType
  public let nationalAnthems: String
  public let varities: String
  public let abv: Double?
  public let purchasePrice: Int?
  public let vintage: Int?
  public let star: Int?
  public let buyAgain: Bool?
  public let mode: DetailMode
  
  public init(
    wineType: WineType,
    nationalAnthems: String,
    varities: String,
    abv: Double? = nil,
    purchasePrice: Int? = nil,
    vintage: Int? = nil,
    star: Int? = nil,
    buyAgain: Bool? = nil,
    mode: DetailMode = .recommendWine
  ) {
    self.wineType = wineType
    self.nationalAnthems = nationalAnthems
    self.varities = varities
    self.abv = abv
    self.purchasePrice = purchasePrice
    self.vintage = vintage
    self.star = star
    self.buyAgain = buyAgain
    self.mode = mode
  }
  
  public var body: some View {
    HStack(alignment: .top) {
      VStack(spacing: 0) {
        WineDetailIllust(wineType: wineType)
        .frame(width: UIScreen.main.bounds.width / 2.5)
        
        Spacer()
          .frame(height: 25)
        
        if let star = star, let buyAgain = buyAgain {
          HStack(spacing: 2) {
            Image(.star_1W)
              .renderingMode(.template)
              .foregroundColor(.wineyMain3)
              .padding(.trailing, 4)
            
            Text(Double(star).description)
              .foregroundColor(.wineyMain3)
              .wineyFont(.title2)
            
            if buyAgain {
              Text("・ 재구매")
                .wineyFont(.captionB1)
            }
          }
        }
      }
      
      Spacer()
        .frame(minWidth: 24)
      
      VStack(spacing: 18) {
        // MARK: NATIONAL ANTHEMS
        wineInfoTable(
          title: "national an thems",
          contents: nationalAnthems
        )
        
        // MARK: Varities
        wineInfoTable(
          title: "Varities",
          contents: varities
        )
        
        // MARK: ABV
        if mode == .note {
          if let abv = abv {
            wineInfoTable(
              title: "ABV",
              contents: Int(abv).description + "%"
            )
          } else {
            wineInfoTable(
              title: "ABV",
              contents: "도수를 알 수 없어요 :("
            )
          }
        }
        
        // MARK: Purchase Price
        if let price = purchasePrice {
          wineInfoTable(
            title: "Purchae price",
            contents: price > 0 ? numberFormatter(number: price) : "구매가를 알 수 없어요 :("
          )
        } else {
          wineInfoTable(
            title: "Purchae price",
            contents: "구매가를 알 수 없어요 :("
          )
        }
        
        // MARK: ABV
        if mode == .note {
          wineInfoTable(
            title: "Vintage",
            contents: vintage?.description ?? "빈티지를 알 수 없어요 :("
          )
        }
      }
      .foregroundColor(.wineyGray50)
      .frame(width: 148)
    }
  }
}

extension WineDetailInfoMiddleView {
  
  @ViewBuilder
  private func wineInfoTable(title: String, contents: String) -> some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack {
        Text(title)
          .wineyFont(.captionM3)
        
        Spacer()
      }
      
      HStack {
        Text(contents.description)
          .wineyFont(.captionB1)
        
        Spacer()
      }
    }
  }
  
  private func numberFormatter(number: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    
    return numberFormatter.string(from: NSNumber(value: number))!
  }
}
