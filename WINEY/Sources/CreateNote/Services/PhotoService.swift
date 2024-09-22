//
//  PhotoService.swift
//  Winey
//
//  Created by 정도현 on 3/12/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct PhotoService {
  public let getPhResult: () async -> Void
  public let fetchPhotos: () async -> [UIImage]
}

extension PhotoService: DependencyKey {
  
  static let liveValue: PhotoService = {
    
    let photoManager = PhotoManager()
    
    return Self {
      photoManager.getPHResult()
    } fetchPhotos: {
      photoManager.fetchImages()
    }
  }()
}

extension DependencyValues {
  var photoService: PhotoService {
    get { self[PhotoService.self] }
    set { self[PhotoService.self] = newValue }
  }
}
