//
//  CreateNoteManager.swift
//  Winey
//
//  Created by 정도현 on 2/11/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import SwiftUI
import WineyKit

final class CreateNoteManager: ObservableObject {
  static let shared = CreateNoteManager()
  
  private init() { }
  
  @Published var mode: CreateNoteMode = .create
  @Published var noteId: Int?
  @Published var wineId: Int?
  @Published var vintage: String?
  @Published var officialAlcohol: Int?
  @Published var price: String?
  @Published var color: String?
  @Published var sweetness: Int?
  @Published var acidity: Int?
  @Published var alcohol: Int?
  @Published var body: Int?
  @Published var tannin: Int?
  @Published var finish: Int?
  @Published var memo: String?
  @Published var buyAgain: Bool?
  @Published var rating: Int?
  @Published var smellKeywordList: Set<String>?
  @Published var originalSmellKeywordList: Set<String>?
  @Published var deleteSmellKeywordList: Set<String>?
  @Published var originalImages: [TastingNoteImage]?
  @Published var originalUIImages: [UIImage]?
  @Published var tastingNoteImages: [TastingNoteImage]?
  @Published var userSelectImages: [UIImage]?
  
  func initData() {
    self.mode = .create
    self.noteId = nil
    self.wineId = nil
    self.vintage = nil
    self.officialAlcohol = nil
    self.price = nil
    self.color = nil
    self.sweetness = nil
    self.acidity = nil
    self.alcohol = nil
    self.body = nil
    self.tannin = nil
    self.finish = nil
    self.memo = nil
    self.buyAgain = nil
    self.rating = nil
    self.smellKeywordList = nil
    self.originalSmellKeywordList = nil
    self.deleteSmellKeywordList = nil
    self.originalImages = nil
    self.originalUIImages = nil
    self.tastingNoteImages = nil
    self.userSelectImages = nil
  }
  
  func fetchData(noteData: NoteDetailDTO) {
    self.vintage = noteData.vintage?.description
    self.officialAlcohol = noteData.officialAlcohol != nil ? Int(noteData.officialAlcohol!) : nil
    self.price = noteData.price == nil ? nil : noteData.price! == 0 ? nil : noteData.price?.description
    self.color = noteData.color
    self.sweetness = Int(noteData.myWineTaste.sweetness)
    self.acidity = Int(noteData.myWineTaste.acidity)
    self.alcohol = Int(noteData.myWineTaste.alcohol)
    self.body = Int(noteData.myWineTaste.body)
    self.tannin = Int(noteData.myWineTaste.tannin)
    self.finish = Int(noteData.myWineTaste.finish)
    self.memo = noteData.memo
    self.buyAgain = noteData.buyAgain
    self.rating = noteData.star
    self.originalSmellKeywordList = noteData.smellKeywordList.setmap(transform: ({ getSmellCode(for: $0) ?? "" }))
    self.originalImages = noteData.tastingNoteImage
    self.fetchImage(urls: self.originalImages!.map{ $0.imgUrl })
  }
  
  func fetchImage(urls: [String]) {
    var images: [UIImage] = []
    
    for url in urls {
      images.append(ImageCacheManager.shared.getCachedImage(forKey: url)!)
    }
    
    self.userSelectImages = images
    self.originalUIImages = images
  }
  
  func createNote() -> (CreateNoteRequestDTO, [UIImage]) {
    return (CreateNoteRequestDTO(
      wineId: self.wineId!,
      vintage: self.vintage,
      officialAlcohol: self.officialAlcohol,
      price: self.price,
      color: self.color!,
      sweetness: self.sweetness!,
      acidity: self.acidity!,
      alcohol: self.alcohol!,
      body: self.body!,
      tannin: self.tannin!,
      finish: self.finish!,
      memo: self.memo!,
      buyAgain: self.buyAgain!,
      rating: self.rating!,
      smellKeywordList: self.smellKeywordList
    ), userSelectImages!)
  }
  
  func patchNote() -> (PatchNoteRequestDTO, [UIImage]) {
    var deleteImageIndex: Set<Int> = []
    var updateImage: [UIImage] = []
    
    if let orginalUIImages = originalUIImages, let userSelectImages = userSelectImages, let originalImages = originalImages {
      for (idx, image) in orginalUIImages.enumerated() {
        if !userSelectImages.contains(image) {
          deleteImageIndex.insert(originalImages[idx].imgId)
        }
      }
      
      for image in userSelectImages {
        if !orginalUIImages.contains(image) {
          updateImage.append(image)
        }
      }
    }
    
    return (PatchNoteRequestDTO(
      noteId: self.noteId!,
      vintage: self.vintage,
      officialAlcohol: self.officialAlcohol,
      price: self.price,
      color: self.color!,
      sweetness: self.sweetness!,
      acidity: self.acidity!,
      alcohol: self.alcohol!,
      body: self.body!,
      tannin: self.tannin!,
      finish: self.finish!,
      memo: self.memo!,
      buyAgain: self.buyAgain!,
      rating: self.rating!,
      smellKeywordList: self.smellKeywordList,
      deleteSmellKeywordList: self.deleteSmellKeywordList,
      deleteImgLists: deleteImageIndex
    ), updateImage)
  }
  
  private func getSmellCode(for name: String) -> String? {
    for category in SmellCategory.allCases {
      for smell in category.list {
        if smell.korName == name {
          return smell.codeName
        }
      }
    }
    
    return nil
  }
}

public enum CreateNoteMode {
  case create
  case patch
}

extension Set {
  func setmap<U>(transform: (Element) -> U) -> Set<U> {
    return Set<U>(self.lazy.map(transform))
  }
}
