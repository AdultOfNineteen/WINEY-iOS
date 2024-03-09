//
//  ImageCacheManager.swift
//  WineyKit
//
//  Created by 정도현 on 3/9/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Foundation
import SwiftUI

public class ImageCacheManager {
  public static let shared = ImageCacheManager()
  
  private init() {}
  
  private let cachedImages = NSCache<NSString, UIImage>()
  
  public func setCachedImage(_ image: UIImage, forKey key: String) {
    cachedImages.setObject(image, forKey: key as NSString)
  }
  
  public func getCachedImage(forKey key: String) -> UIImage? {
    return cachedImages.object(forKey: key as NSString)
  }
}
