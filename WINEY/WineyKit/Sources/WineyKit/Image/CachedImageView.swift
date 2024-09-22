//
//  CachedImageView.swift
//  WineyKit
//
//  Created by 정도현 on 3/9/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import SwiftUI

public struct CachedImageView: View {
  @ObservedObject var cachedImageLoader: CachedImageLoader
  
  public init(url: String) {
    cachedImageLoader = CachedImageLoader(url: url)
  }
  
  public var body: some View {
    if let image = cachedImageLoader.image {
      Image(uiImage: image)
        .resizable()
    } else {
      ProgressView()
    }
  }
}
