//
//  KakaoShareMessage.swift
//  Winey
//
//  Created by 박혜운 on 9/3/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Foundation

struct KakaoShareMessage: Encodable {
  let title: String
  let id: String
  
  enum CodingKeys: String, CodingKey {
    case title
    case id
  }
}
