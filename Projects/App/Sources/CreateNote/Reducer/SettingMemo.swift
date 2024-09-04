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
    public var rating: Int = 0
    public var buyAgain: Bool? = nil
    public var isPublic: Bool? = nil
    
    public var maxPhoto: Int = 3
    public var displayImages: [UIImage] = []
    public var isShowGallery: Bool = false
    
    public var maxCommentLength: Int = 200
    public var ratingRange: ClosedRange<Int> = 1...5
    
    public var customGallery: CustomGallery.State?
  }
  
  public enum Action {
    
    // MARK: - User Action
    case tappedBackButton
    case tappedAttachPictureButton
    case tappedOutsideOfBottomSheet
    case tappedDoneButton
    case tappedWineStar(Int)
    case tappedBuyAgain(Bool)
    case writingMemo(String)
    case tappedDelImage(UIImage)
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _makeNotes
    case _moveNextPage
    case _moveBackPage
    case _backToNoteDetail
    case _requestAuthorizationAndFetchPhotos
    
    // MARK: - Inner SetState Action
    case _limitMemo(String)
    case _setRating(Int)
    case _setBuyAgain(Bool)
    case _setIsPublic(Bool)
    case _setSheetState(Bool)
    case _failureSocialNetworking(Error) // 후에 경고창 처리
    
    // MARK: - Child Action
    case customGallery(CustomGallery.Action)
  }
  
  @Dependency(\.note) var noteService
  @Dependency(\.alert) var alertService
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case ._viewWillAppear:
        state.memo = CreateNoteManager.shared.memo ?? ""
        state.rating = CreateNoteManager.shared.rating ?? 0
        state.buyAgain = CreateNoteManager.shared.buyAgain
        state.displayImages = CreateNoteManager.shared.userSelectImages ?? []
        return .none
        
      case .tappedBackButton:
        CreateNoteManager.shared.memo = state.memo
        CreateNoteManager.shared.rating = state.rating
        CreateNoteManager.shared.buyAgain = state.buyAgain
        CreateNoteManager.shared.userSelectImages = state.displayImages
        
        if CreateNoteManager.shared.mode == .create {
          AmplitudeProvider.shared.track(event: .REVIEW_COMPLETE_BACK_CLICK)
        }
        
        return .send(._moveBackPage)
        
      case ._limitMemo(let value):
        state.memo = String(value.prefix(state.maxCommentLength))
        return .none
        
      case .writingMemo(let value):
        state.memo = value
        return .none
        
      case .tappedAttachPictureButton:
        state.customGallery = CustomGallery.State(availableSelectCount: state.maxPhoto - state.displayImages.count)
        return .send(._requestAuthorizationAndFetchPhotos)
        
      case .tappedOutsideOfBottomSheet:
        return .send(._setSheetState(false))
        
      case ._setSheetState(let bool):
        state.isShowGallery = bool
        return .none
        
      case .tappedDoneButton:
        CreateNoteManager.shared.memo = state.memo
        CreateNoteManager.shared.rating = state.rating
        CreateNoteManager.shared.buyAgain = state.buyAgain
        CreateNoteManager.shared.isPublic = state.isPublic
        CreateNoteManager.shared.userSelectImages = state.displayImages
        
        if CreateNoteManager.shared.mode == .create {
          AmplitudeProvider.shared.track(event: .REVIEW_COMPLETE_CLICK)
        }
        
        return .send(._makeNotes)
        
      case ._makeNotes:
        NoteManager.shared.noteList = nil
        if CreateNoteManager.shared.mode == .create {
          let createNoteData = CreateNoteManager.shared.createNote()
          
          return .run { send in
            switch await noteService.createNote(
              createNoteData.0,
              createNoteData.1
            ) {
            case .success:
              CreateNoteManager.shared.initData()
              await send(._moveNextPage)
            case let .failure(error):
              await send(._failureSocialNetworking(error))
            }
          }
        } else {
          let patchNoteData = CreateNoteManager.shared.patchNote()
          
          return .run { send in
            switch await noteService.patchNote(
              patchNoteData.0,
              patchNoteData.1
            ) {
            case .success:
              CreateNoteManager.shared.initData()
              await send(._backToNoteDetail)
            case let .failure(error):
              await send(._failureSocialNetworking(error))
            }
          }
        }
        
      case .tappedWineStar(let value):
        return .send(._setRating(value))
        
      case .tappedBuyAgain(let value):
        return .send(._setBuyAgain(value))
        
      case .tappedDelImage(let image):
        state.displayImages.removeAll(where: { $0 == image })
        return .none
        
      case ._setRating(let value):
        state.rating = value
        return .none
        
      case ._setBuyAgain(let value):
        state.buyAgain = value
        return .none
        
      case ._setIsPublic(let value):
        state.isPublic = value
        return .none
        
      case ._requestAuthorizationAndFetchPhotos:
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
          return .send(._setSheetState(true))
          
        case .denied, .restricted:
          alertService.showAlert("설정에서 갤러리 접근을 허용해주세요.")
          return .none
          
        case .notDetermined:
          break
          
        @unknown default:
          alertService.showAlert("설정에서 갤러리 접근을 허용해주세요.")
          return .none
        }
        
        // Semaphore을 통한 동기 처리
        let semaphore = DispatchSemaphore(value: 0)
        
        PHPhotoLibrary.requestAuthorization { _ in
          semaphore.signal()
        }
        
        semaphore.wait()
        
        let newStatus = PHPhotoLibrary.authorizationStatus()
        
        switch newStatus {
        case .authorized, .limited:
          return .send(._setSheetState(true))
          
        case .denied, .restricted:
          alertService.showAlert("설정에서 갤러리 접근을 허용해주세요.")
          return .none
          
        default:
          alertService.showAlert("설정에서 갤러리 접근을 허용해주세요.")
          return .none
        }
        
      case let .customGallery(._sendParentViewImage(images)):
        state.displayImages.append(contentsOf: images)
        return .send(.customGallery(._dismissWindow))
        
      case .customGallery(._dismissWindow):
        return .send(._setSheetState(false))
        
      default:
        return .none
      }
    }
    .ifLet(\.customGallery, action: /Action.customGallery) {
      CustomGallery()
    }
  }
}
