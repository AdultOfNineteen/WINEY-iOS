//
//  CachedImageLoader.swift
//  WineyKit
//
//  Created by 정도현 on 3/9/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import UIKit

final class CachedImageLoader: ObservableObject {
  @Published var image: UIImage?
  
  private var url: String
  private var task: URLSessionDataTask?
  
  init(url: String) {
    self.url = url
    loadImage()
  }
  
  private func loadImage() {
    if let cachedImage = ImageCacheManager.shared.getCachedImage(forKey: url) {
      self.image = cachedImage
      return
    }
    
    guard let url = URL(string: url) else { return }
    
    task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, error == nil else { return }
      
      DispatchQueue.main.async {
        if let image = UIImage(data: data) {
          self.image = image
          ImageCacheManager.shared.setCachedImage(image, forKey: self.url)
        }
      }
    }
    task?.resume()
  }
}
