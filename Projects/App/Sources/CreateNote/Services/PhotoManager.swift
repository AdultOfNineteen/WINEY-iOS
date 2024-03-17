//
//  PhotoManager.swift
//  Winey
//
//  Created by 정도현 on 3/12/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Photos
import SwiftUI

final class PhotoManager: NSObject {
  private let imageManager = PHImageManager.default()
  
  public var fetchResult: PHFetchResult<PHAsset> = .init()
  
  public var startIndex: Int = 0
  public var pagingSize: Int = 50
  
  func getPHResult() {
    self.startIndex = 0

    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
    self.fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
  }
  
  func fetchImages() -> [UIImage] {
    let requestOptions = PHImageRequestOptions()
    requestOptions.isSynchronous = true
    requestOptions.deliveryMode = .highQualityFormat
    
    var imageBuffer: [UIImage] = []
    
    for i in self.startIndex ..< (self.startIndex + self.pagingSize) {
      if fetchResult.count - 1 < i {
        break
      }
      
      imageManager.requestImage(
        for: fetchResult.object(at: i),
        targetSize: CGSize(width: 200, height: 200),
        contentMode: .aspectFit,
        options: requestOptions
      ) { (image, _) in
          if let image = image {
            imageBuffer.append(image)
          }
        }
    }
    
    self.startIndex += self.pagingSize
    
    return imageBuffer
  }
}
