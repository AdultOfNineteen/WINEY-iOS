//
//  CustomGallery.swift
//  Winey
//
//  Created by 정도현 on 3/8/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import Photos
import SwiftUI

public struct CustomGallery: Reducer {
  public struct State: Equatable {
    
    public let availableSelectCount: Int
    
    public var selectedImage: [UIImage] = []
    public var userGalleryImage: [UIImage] = []

    public init(availableSelectCount: Int) {
      self.availableSelectCount = availableSelectCount
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedDismissButton
    case tappedConfirmButton
    case tappedImage(UIImage)
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _fetchPhotos
    case _dismissWindow
    case _sendParentViewImage([UIImage])
    
    // MARK: - Inner SetState Action
    case _appendImage(UIImage)
    case _deleteImage(UIImage)
    
    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case ._viewWillAppear:
        return .run { send in
          await send(._fetchPhotos)
        }
        
      case .tappedDismissButton:
        return .send(._dismissWindow)
        
      case let .tappedImage(image):
        if state.selectedImage.contains(image) {
          return .send(._deleteImage(image))
        } else {
          return .send(._appendImage(image))
        }
        
      case let ._appendImage(image):
        state.selectedImage.append(image)
        return .none
        
      case let ._deleteImage(image):
        state.selectedImage.removeAll(where: { $0 == image })
        return .none
        
      case ._fetchPhotos:
        let imageManaer = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        var fetchedImage: [UIImage] = []
        
        for i in 0..<fetchResult.count {
          imageManaer.requestImage(
            for: fetchResult.object(at: i),
            targetSize: .init(),
            contentMode: .aspectFit,
            options: requestOptions) { image, _ in
              if let image = image {
                fetchedImage.append(image)
              }
            }
        }
        
        state.userGalleryImage = fetchedImage
        return .none
        
      default:
        return .none
      }
    }
  }
}
