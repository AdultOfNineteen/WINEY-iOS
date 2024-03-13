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
    
    public var isOpenCamera: Bool = false

    public init(availableSelectCount: Int) {
      self.availableSelectCount = availableSelectCount
    }
  }
  
  public enum Action {
    
    // MARK: - User Action
    case tappedDismissButton
    case tappedAttachButton
    case tappedImage(UIImage)
    case tappedCameraButton
    case tappedOutsideOfBottomSheet
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _viewDisappear
    case _dismissWindow
    case _sendParentViewImage([UIImage])
    case _openCamera
    
    // MARK: - Inner SetState Action
    case _setImageData([UIImage])
    case _paginationImageData
    case _appendImageData([UIImage])
    case _appendImage(UIImage)
    case _deleteImage(UIImage)
    
    // MARK: - Child Action
  }
  
  @Dependency(\.photoService) var photoService
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case ._viewWillAppear:
        return .run { send in
          await photoService.getPhResult()
          let imageData = await photoService.fetchPhotos()
          await send(._setImageData(imageData))
        }
        
      case let ._setImageData(images):
        state.userGalleryImage = images
        return .none
        
      case ._paginationImageData:
        return .run { send in
          let imageData = await photoService.fetchPhotos()
          await send(._appendImageData(imageData))
        }
        
      case let ._appendImageData(images):
        state.userGalleryImage.append(contentsOf: images)
        return .none
        
      case .tappedCameraButton:
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
          return .send(._openCamera)
          
        case .notDetermined:
          break
          
        default:
          // error 발생
          return .none
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        AVCaptureDevice.requestAccess(for: .video) { _ in
          semaphore.signal()
        }
        semaphore.wait()
        
        let newStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch newStatus {
        case .authorized:
          return .send(._openCamera)
          
        default:
          // error 발생
          return .none
        }
        
      case ._openCamera:
        state.isOpenCamera = true
        return .none
        
      case .tappedOutsideOfBottomSheet:
        state.isOpenCamera = false
        return .none
        
      case .tappedDismissButton:
        return .send(._dismissWindow)
        
      case let .tappedImage(image):
        if state.selectedImage.contains(image) {
          return .send(._deleteImage(image))
        } else {
          if state.selectedImage.count < state.availableSelectCount {
            return .send(._appendImage(image))
          } else {
            return .none
          }
        }
        
      case .tappedAttachButton:
        let userSelectImages = state.selectedImage
        state.selectedImage = []
        return .send(._sendParentViewImage(userSelectImages))
        
      case let ._appendImage(image):
        state.selectedImage.append(image)
        return .none
        
      case let ._deleteImage(image):
        state.selectedImage.removeAll(where: { $0 == image })
        return .none
        
      case ._viewDisappear:
        state.userGalleryImage.removeAll()
        return .none
        
      default:
        return .none
      }
    }
  }
}
