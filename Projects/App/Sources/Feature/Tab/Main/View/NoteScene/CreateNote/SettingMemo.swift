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
    public var wineId: Int
    public var officialAlcohol: Int
    public var vintage: Int
    public var price: Int
    public var color: String
    public var smellKeywordList: [String]
    public var sweetness: Int
    public var acidity: Int
    public var alcohol: Int
    public var body: Int
    public var tannin: Int
    public var finish: Int
    
    public var memo: String = ""
    public var star: Int = 0
    public var buyAgain: Bool? = nil
    
    public var maxPhoto: Int = 3
    public var selectedPhoto: [PhotosPickerItem] = []
    public var displayPhoto: [UIImage] = []
    public var deleteImage: [PhotosPickerItem] = []
    
    public var maxCommentLength: Int = 200
    public var starRange: ClosedRange<Int> = 1...5
    
    public var isPresentedBottomSheet: Bool = false
    
    public init(
      wineId: Int,
      officialAlcohol: Int,
      vintage: Int,
      price: Int,
      color: String,
      smellKeywordList: [String],
      sweetness: Int,
      acidity: Int,
      alcohol: Int,
      body: Int,
      tannin: Int,
      finish: Int
    ) {
      self.wineId = wineId
      self.officialAlcohol = officialAlcohol
      self.vintage = vintage
      self.price = price
      self.color = color
      self.smellKeywordList = smellKeywordList
      self.sweetness = sweetness
      self.acidity = acidity
      self.alcohol = alcohol
      self.body = body
      self.tannin = tannin
      self.finish = finish
    }
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
    case tappedOutsideOfBottomSheet
    
    // MARK: - Inner Business Action
    case _makeNotes(
      wineId: Int,
      vintage: Int,
      officialAlcohol: Int,
      price: Int,
      color: String,
      sweetness: Int,
      acidity: Int,
      alcohol: Int,
      body: Int,
      tannin: Int,
      finish: Int,
      memo: String,
      buyAgain: Bool,
      rating: Int,
      smellKeywordList: [String],
      images: [UIImage]
    )
    
    case _moveNextPage

    // MARK: - Inner SetState Action
    case _limitMemo(String)
    case _setStar(Int)
    case _setBuyAgain(Bool)
    case _pickPhoto([PhotosPickerItem])
    case _delDisplayPhoto
    case _delPickPhoto
    case _addPhoto(UIImage)
    case _backToFirstView
    case _presentBottomSheet(Bool)
    case _failureSocialNetworking(Error) // 후에 경고창 처리
    
    // MARK: - Child Action
  }
  
  @Dependency(\.note) var noteService
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case ._limitMemo(let value):
        state.memo = String(value.prefix(state.maxCommentLength))
        return .none
        
      case .writingMemo(let value):
        state.memo = value
        return .none
        
      case .tappedBackButton:
        return .send(._presentBottomSheet(true))
        
      case .tappedAttachPictureButton:
        return .none
        
      case .tappedDoneButton:
        return .send(
          ._makeNotes(
            wineId: state.wineId,
            vintage: state.vintage,
            officialAlcohol: state.officialAlcohol,
            price: state.price,
            color: state.color,
            sweetness: state.sweetness,
            acidity: state.acidity,
            alcohol: state.alcohol,
            body: state.body,
            tannin: state.tannin,
            finish: state.finish,
            memo: state.memo,
            buyAgain: state.buyAgain!,
            rating: state.star,
            smellKeywordList: state.smellKeywordList,
            images: state.displayPhoto
          )
        )
        
      case let ._makeNotes(wineId, vintage, officialAlcohol, price, color, sweetness, acidity, alcohol, body, tannin, finish, memo, buyAgain, rating, smellKeywordList, images):
        return .run(operation: { send in
          switch await noteService.createNote(wineId, vintage, officialAlcohol, price, color, sweetness, acidity, alcohol, body, tannin, finish, memo, buyAgain, rating, smellKeywordList, images) {
          case let .success(data):
            await send(._moveNextPage)
          case let .failure(error):
            await send(._failureSocialNetworking(error))
          }
        })
        
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
        
      case ._presentBottomSheet(let bool):
        state.isPresentedBottomSheet = bool
        return .none
        
      default:
        return .none
      }
    }
  }
}
