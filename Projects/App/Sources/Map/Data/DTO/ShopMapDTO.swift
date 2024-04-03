//
//  ShopMapDTO.swift
//  Winey
//
//  Created by 박혜운 on 2/1/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Foundation

// MARK: - ShopMapDTO

public struct ShopMapDTO: Codable, Equatable, Hashable {
  let shopId: Int
  let latitude, longitude, meter: Double
  let businessHour, imgUrl, address, phone: String
  let name: String
  let shopType: String
  let shopMoods: [String]
  var like: Bool
}

struct ShopInfoModel: Identifiable, Hashable, Equatable {
  init(info: ShopMapDTO) {
    self.id = info.shopId
    self.info = info
  }
  
  var id: Int
  var info: ShopMapDTO
  
  func changeBookMarkState() -> Self {
    return Self(
      info: .init(
        shopId: self.info.shopId,
        latitude: self.info.latitude,
        longitude: self.info.longitude,
        meter: self.info.meter,
        businessHour: self.info.businessHour,
        imgUrl: self.info.imgUrl,
        address: self.info.address,
        phone: self.info.phone,
        name: self.info.name,
        shopType: self.info.shopType,
        shopMoods: self.info.shopMoods,
        like: !self.info.like
      )
    )
  }
}

extension ShopInfoModel {
  static let dummy: Self = .init(info: .dummy)
  static let dummy2: Self = .init(info: .dummy2)
}

extension ShopMapDTO {
  static let dummy: Self = .init(
    shopId: 0,
    latitude: 0,
    longitude: 0,
    meter: 0,
    businessHour: "월~화 10:00~19:00",
    imgUrl: "https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAyMjBfOTkg%2FMDAxNjc2ODc4OTMyMzQ5.hHZFajUN67R10cw5VrxQgYKUUwyUcqPzKEP9pLc95Mkg.IJHhwoxa3Z_z5wIjb2iR1sKHVQdr3auhVO90KrkY5ysg.JPEG.sky_planet%2F013.jpg&type=sc960_832",
    address: "송파구 올림픽로 37길 2층",
    phone: "000-000-0000",
    name: "모이니 와인바1",
    shopType: "와인바",
    shopMoods: ["양식", "프랑스", "파스타", "파스타", "파스타"],
    like: true
  )
  
  static let dummy2: Self = .init(
    shopId: 1,
    latitude: 0,
    longitude: 0,
    meter: 0,
    businessHour: "월~화 10:00~19:00",
    imgUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyjn5g4wLxv0R34DHw4RpE0mu266VgLXtWgSEJxmYA6R2RhYPxifPyN1oth2AhdJDrGnQ&usqp=CAU",
    address: "송파구 올림픽로 37길 2층",
    phone: "000-000-0000",
    name: "모이니 와인바2",
    shopType: "와인바",
    shopMoods: ["양식", "프랑스", "파스타", "파스타", "파스타"],
    like: false
  )
}
