//
//  CustomCameraView.swift
//  Winey
//
//  Created by 정도현 on 3/10/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  private let store: StoreOf<CustomCamera>
  @ObservedObject var viewStore: ViewStoreOf<CustomCamera>
  
  public init(store: StoreOf<CustomCamera>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    if let selectedImage = info[.originalImage] as? UIImage {
      viewStore.send(.savePhoto(selectedImage))
    } else {
      // 에러 띄워야 함.
    }
  }
}

struct CustomCameraView: UIViewControllerRepresentable {
  
  private let store: StoreOf<CustomCamera>
  @ObservedObject var viewStore: ViewStoreOf<CustomCamera>
  
  public init(store: StoreOf<CustomCamera>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  func makeUIViewController(context: Context) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .camera
    imagePicker.allowsEditing = true
    imagePicker.delegate = context.coordinator
    return imagePicker
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(store: store)
  }
}
