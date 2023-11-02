//
//  WineDetailInfoMiddle.swift
//  Winey
//
//  Created by 정도현 on 10/19/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit

public struct WineDetailInfoMiddle: View {
  public let illustImage: Image
  public let circleBorderColor: Color
  public let secondaryColor: Color
  public let nationalAnthems: String
  public let varities: String
  public let abv: Double?
  public let purchasePrice: Double
  public let vintage: String?
  public let star: Double?
  public let buyAgain: Bool?
  
  public init(
    illustImage: Image,
    circleBorderColor: Color,
    secondaryColor: Color,
    nationalAnthems: String,
    varities: String,
    abv: Double? = nil,
    purchasePrice: Double,
    vintage: String? = nil,
    star: Double? = nil,
    buyAgain: Bool? = nil
  ) {
    self.illustImage = illustImage
    self.circleBorderColor = circleBorderColor
    self.secondaryColor = secondaryColor
    self.nationalAnthems = nationalAnthems
    self.varities = varities
    self.abv = abv
    self.purchasePrice = purchasePrice
    self.vintage = vintage
    self.star = star
    self.buyAgain = buyAgain
  }
  
  public var body: some View {
    HStack(alignment: .top) {
      VStack {
        WineDetailIllust(
          illustImage: illustImage,
          circleBorderColor: circleBorderColor,
          secondaryColor: secondaryColor
        )
        
        Spacer()
          .frame(height: 25)
        
        if let star = star, let buyAgain = buyAgain {
          HStack(spacing: 2) {
            WineyAsset.Assets.star1.swiftUIImage
              .renderingMode(.template)
              .foregroundColor(WineyKitAsset.main3.swiftUIColor)
              .padding(.trailing, 4)
            
            Text(star.description)
              .foregroundColor(WineyKitAsset.main3.swiftUIColor)
            Text("/")
            Text(buyAgain ? "재구매" : "")
          }
          .wineyFont(.captionB1)
        }
      }
      
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
        
        // MARK: ABV
        if let abv = abv {
          VStack(alignment: .leading, spacing: 4) {
            HStack {
              Text("ABV")
                .wineyFont(.captionM3)
              
              Spacer()
            }
            
            HStack {
              Text(abv.description + "%")
                .wineyFont(.captionB1)
              
              Spacer()
            }
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
        
        // MARK: ABV
        if let vintage = vintage {
          VStack(alignment: .leading, spacing: 4) {
            HStack {
              Text("Vintage")
                .wineyFont(.captionM3)
              
              Spacer()
            }
            
            HStack {
              Text(vintage)
                .wineyFont(.captionB1)
              
              Spacer()
            }
          }
        }

      }
      .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
      .frame(width: 148)
    }
  }
}
#Preview {
  WineDetailInfoMiddle(
    illustImage: WineType.rose.illustImage,
    circleBorderColor: .black,
    secondaryColor: .red,
    nationalAnthems: "test",
    varities: "test",
    purchasePrice: 9.90,
    star: 4.0,
    buyAgain: true
  )
}
