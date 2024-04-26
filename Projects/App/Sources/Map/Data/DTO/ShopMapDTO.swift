//
//  ShopMapDTO.swift
//  Winey
//
//  Created by 박혜운 on 2/1/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Foundation

// MARK: - ShopMapDTO

// 서버로부터 받은 문자열을 처리하는 PropertyWrapper
//@propertyWrapper
//struct DecodedCategory: Codable, Equatable {
//  private var value: ShopCategoryType
//
//  init(wrappedValue: ShopCategoryType) {
//    self.value = wrappedValue
//  }
//
//  init(from decoder: Decoder) throws {
//    let container = try decoder.singleValueContainer()
//    let decodedString = try container.decode(String.self)
//    self.value = {
//      switch decodedString {
//        case "내 장소": return .myPlace
//        case "바틀샵": return .bottleShop
//        case "와인바": return .wineBar
//        case "음식점": return .restaurant
//        case "펍": return .pub
//        case "카페": return .cafe
//      default: return .all
//      }
//    }()
//  }
//
//  var wrappedValue: ShopCategoryType {
//    get {
//      return value
//    }
//    set {
//      value = newValue
//    }
//  }
//
//  // Codable 준수를 위한 encode(to:) 구현
//  func encode(to encoder: Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(wrappedValue.title)
//  }
//}

// 서버로부터 받은 문자열을 처리하는 PropertyWrapper
@propertyWrapper
struct DecodedURL: Codable, Equatable {
  private var value: String
  
  init(wrappedValue: String) {
    self.value = wrappedValue
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let decodedString = try container.decode(String.self)
    self.value = decodedString
  }
  
  var wrappedValue: String {
    get {
      return value
        .replacingOccurrences(of: "\\u003d", with: "=")
        .replacingOccurrences(of: "\\\\", with: "")
    }
    set {
      value = newValue
    }
  }
  
  // Codable 준수를 위한 encode(to:) 구현
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(wrappedValue)
  }
}

public struct ShopMapDTO: Codable, Equatable, Identifiable {
  public let id: Int
  @DecodedURL var imgUrl: String
  let latitude, longitude, meter: Double
  let businessHour, address, phone: String
  let name: String
  let shopType: String
  let shopMoods: [String]
  var like: Bool
  
  enum CodingKeys: String, CodingKey {
    case id = "shopId"
    case latitude, longitude, businessHour
    case imgUrl
    case address, phone, name, meter, shopType, shopMoods, like
  }
  
  init(
    id: Int,
    imgUrl: String, latitude: Double, longitude: Double, meter: Double,
    businessHour: String, address: String, phone: String, name: String,
    shopType: String, shopMoods: [String], like: Bool
  ) {
    self.id = id
    self.imgUrl = imgUrl
    self.latitude = latitude
    self.longitude = longitude
    self.meter = meter
    self.businessHour = businessHour
    self.address = address
    self.phone = phone
    self.name = name
    self.shopType = shopType
    self.shopMoods = shopMoods
    self.like = like
  }
}

extension ShopMapDTO {
  var shopMarkerType: ShopCategoryType {
    switch self.shopType {
    case "내 장소": return .myPlace
    case "바틀샵": return .bottleShop
    case "와인바": return .wineBar
    case "음식점": return .restaurant
    case "펍": return .pub
    case "카페": return .cafe
    default: return .all
    }
  }
}

extension ShopMapDTO {
  func changeBookMarkState() -> Self {
    return .init(
      id: self.id,
      imgUrl: self.imgUrl,
      latitude: self.latitude,
      longitude: self.longitude,
      meter: self.meter,
      businessHour: self.businessHour,
      address: self.address,
      phone: self.phone,
      name: self.name,
      shopType: self.shopType,
      shopMoods: self.shopMoods,
      like: !self.like
    )
  }
}

extension ShopMapDTO {
  static let dummy: Self = .init(
    id: 0,
    imgUrl: "https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAyMjBfOTkg%2FMDAxNjc2ODc4OTMyMzQ5.hHZFajUN67R10cw5VrxQgYKUUwyUcqPzKEP9pLc95Mkg.IJHhwoxa3Z_z5wIjb2iR1sKHVQdr3auhVO90KrkY5ysg.JPEG.sky_planet%2F013.jpg&type=sc960_832",
    latitude: 0,
    longitude: 0,
    meter: 0,
    businessHour: "월~화 10:00~19:00",
    address: "송파구 올림픽로 37길 2층",
    phone: "000-000-0000",
    name: "The 술 세계주류 할인점",
    shopType: "와인바",
    shopMoods: ["양식", "프랑스", "파스타", "랄라", "고라니"],
    like: true
  )
  
  static let dummy2: Self = .init(
    id: 1,
    imgUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyjn5g4wLxv0R34DHw4RpE0mu266VgLXtWgSEJxmYA6R2RhYPxifPyN1oth2AhdJDrGnQ&usqp=CAU",
    latitude: 0,
    longitude: 0,
    meter: 0,
    businessHour: "월~화 10:00~19:00",
    address: "송파구 올림픽로 37길 2층",
    phone: "000-000-0000",
    name: "모이니 와인바2",
    shopType: "와인바",
    shopMoods: ["양식", "프랑스", "파스타", "랄라", "고라니"],
    like: false
  )
}
