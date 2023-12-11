//
//  SettingMemo.swift
//  Winey
//
//  Created by 정도현 on 11/29/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import PhotosUI
import SwiftUI

public struct SettingMemo: Reducer {
  public struct State: Equatable {
    public var memo: String = ""
    public var star: Int = 0
    public var buyAgain: Bool? = nil
    
    public var maxPhoto: Int = 3
    public var selectedPhoto: [PhotosPickerItem] = []
    public var displayPhoto: [Image] = []
    public var deleteImage: [PhotosPickerItem] = []
    
    public var maxCommentLength: Int = 200
    public var starRange: ClosedRange<Int> = 1...5
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedAttachPictureButton
    case tappedDoneButton
    case tappedWineStar(Int)
    case tappedBuyAgain(Bool)
    case writingMemo(String)
    case tappedDelImage(Int)
  
    // MARK: - Inner Business Action

    // MARK: - Inner SetState Action
    case _limitMemo(String)
    case _setStar(Int)
    case _setBuyAgain(Bool)
    case _pickPhoto([PhotosPickerItem])
    case _delDisplayPhoto
    case _delPickPhoto
    case _addPhoto(Image)
    
    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case ._limitMemo(let value):
        state.memo = String(value.prefix(state.maxCommentLength))
        return .none
        
      case .writingMemo(let value):
        state.memo = value
        return .none
        
      case .tappedAttachPictureButton:
        return .none
        
      case .tappedDoneButton:
        return .none
        
      case .tappedWineStar(let value):
        return .send(._setStar(value))
        
      case .tappedBuyAgain(let value):
        return .send(._setBuyAgain(value))
        
      case .tappedDelImage(let idx):
        let image = state.displayPhoto[idx]
        state.displayPhoto.removeAll(where: { $0 == image })
        state.deleteImage.append(state.selectedPhoto[idx])
        return .none
        
      case ._setStar(let value):
        state.star = value
        return .none
        
      case ._setBuyAgain(let value):
        state.buyAgain = value
        return .none
        
      case ._pickPhoto(let item):
        state.selectedPhoto = item
        return .none
        
      case ._delPickPhoto:
        if state.deleteImage.count == 3 {
          state.selectedPhoto.removeAll()
        } else {
          for photo in state.deleteImage {
            state.selectedPhoto.removeAll(where: { $0 == photo })
          }
        }
        return .none
        
      case ._delDisplayPhoto:
        state.displayPhoto.removeAll()
        return .none
        
      case ._addPhoto(let image):
        state.displayPhoto.append(image)
        return .none
        
      default:
        return .none
      }
    }
  }
}
