//
//  ShopDetailCell.swift
//  Winey
//
//  Created by 박혜운 on 2/3/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import SwiftUI
import WineyKit

struct ShopDetailCell: View {
  @State var presentBusinessHour: Bool = false
  @Binding private var isBookmarked: Bool
  private var shopInfo: ShopMapDTO
  private var presentBusinessHourAction: (
    (_ state: Bool) -> Void
  )
  
  init(
    shopInfo: ShopMapDTO,
    isBookmarked: Binding<Bool>,
    presentBusinessHourAction: @escaping (_ state: Bool) -> Void
  ) {
    self.shopInfo = shopInfo
    self._isBookmarked = isBookmarked
    self.presentBusinessHourAction = presentBusinessHourAction
  }
  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        AsyncImage(url: URL(string: shopInfo.imgUrl)) { phase in
          if let image = phase.image {
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: geometry.size.width, height: 202)
              .clipped()
            
            
          } else if phase.error != nil {
            Image(systemName: "questionmark.diamond")
              .imageScale(.large)
          } else {
            Rectangle()
              .fill(WineyKitAsset.gray800.swiftUIColor)
          }
        }
        .frame(width: geometry.size.width, height: 202)
        .padding(.bottom, 24)
        
        Group {
          ShopMainInfoBlock(
            type: .detail,
            shopId: shopInfo.shopId,
            shopMoods: shopInfo.shopMoods,
            isBookmarked: $isBookmarked
          )
          .padding(.bottom, 21)
          
          VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
              HStack(spacing: 10) {
                WineyAsset.Assets.infoClock.swiftUIImage
                Text(shopInfo.businessHour)
                  .padding(.trailing, 10)
                Button(
                  action: {
                    presentBusinessHour.toggle()
                    presentBusinessHourAction(presentBusinessHour)
                  },
                  label: {
                    WineyAsset.Assets.checkIcon.swiftUIImage
                      .resizable()
                      .frame(width: 15.5, height: 15.5)
                  }
                )
                Spacer()
              }
              
              if presentBusinessHour {
                Group {
                  Text("요기 하드코딩 된 상태입니다")
                  Text("월~화 10:00~19:00")
                  Text("오스틴 시간을 배열로 내려주실 수 있나요...")
                  Text("혹싀..........")
                    .padding(.bottom, 8)
                }
                .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
                .padding(.leading, 35)
              }
            }
            VStack {
              HStack(spacing: 10) {
                WineyAsset.Assets.infoMark.swiftUIImage
                Text(shopInfo.address)
                  .padding(.trailing, 10)
                
                Text("\(shopInfo.meter)m")
                  .foregroundColor(WineyKitAsset.gray800.swiftUIColor)
                Spacer()
              }
            }
            HStack(spacing: 10) {
              WineyAsset.Assets.infoPhone.swiftUIImage
              Text(shopInfo.phone)
              Spacer()
            }
          }
          .wineyFont(.captionM1)
          .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
        }
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
    }
    .frame(height: 89)
  }
}

struct ShopDetailCell_Previews: PreviewProvider {
  @State static var booked = true
  
  static var previews: some View {
    ShopDetailCell(
      shopInfo: .init(
        shopId: 0,
        latitude: 0,
        longitude: 0,
        businessHour: "월~화 10:00~19:00",
        imgUrl: "https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAyMjBfOTkg%2FMDAxNjc2ODc4OTMyMzQ5.hHZFajUN67R10cw5VrxQgYKUUwyUcqPzKEP9pLc95Mkg.IJHhwoxa3Z_z5wIjb2iR1sKHVQdr3auhVO90KrkY5ysg.JPEG.sky_planet%2F013.jpg&type=sc960_832",
        address: "송파구 올림픽로 37길 2층",
        phone: "000-000-0000",
        name: "",
        meter: 0,
        shopType: "",
        shopMoods: ["양식", "프랑스", "파스타"],
        like: true
      ),
      isBookmarked: $booked, 
      presentBusinessHourAction: {_ in }
    )
  }
}
