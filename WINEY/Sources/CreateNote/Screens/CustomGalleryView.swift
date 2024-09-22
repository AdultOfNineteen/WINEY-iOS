//
//  CustomGalleryView.swift
//  Winey
//
//  Created by 정도현 on 3/8/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct CustomGalleryView: View {
  
  private let store: StoreOf<CustomGallery>
  
  public init(store: StoreOf<CustomGallery>) {
    self.store = store
  }
  
  public var columns: [GridItem] = [GridItem(.flexible(), spacing: 4), GridItem(.flexible(), spacing: 4), GridItem(.flexible())]
  
  public var body: some View {
    VStack(spacing: 0) {
      header()
      
      imageList()
    }
    .onAppear {
      store.send(._viewWillAppear)
    }
    .onDisappear {
      store.send(._viewDisappear)
    }
    .fullScreenCover(
      isPresented: .init(
        get: { store.isOpenCamera },
        set: { _ in store.send(.tappedOutsideOfBottomSheet) }
      ), content: {
        CustomCameraView(
          store: self.store.scope(state: \.camera, action: \.camera)
        )
        .ignoresSafeArea()
      }
    )
    .background(.wineyMainBackground)
    .navigationBarHidden(true)
  }
}

extension CustomGalleryView {
  
  @ViewBuilder
  private func header() -> some View {
    VStack(spacing: 0) {
      HStack {
        Image(systemName: "xmark")
          .tint(.white)
          .onTapGesture {
            store.send(.tappedDismissButton)
          }
        
        Spacer()
        
        Button(action: {
          store.send(.tappedAttachButton)
        }, label: {
          Text("첨부하기 (\(store.selectedImage.count)/\(store.availableSelectCount))")
            .wineyFont(.subhead)
            .bold()
        })
        .tint(.wineyMain2)
      }
      .padding(.vertical, 14)
      .padding(.horizontal, 10)
      
      Divider()
        .overlay(.black)
    }
  }
  
  @ViewBuilder
  private func imageList() -> some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: 4) {
        cameraButton()
        
        ForEach(store.userGalleryImage, id: \.self) { image in
          imageBox(image: image)
            .onAppear {
              if image == store.userGalleryImage[store.userGalleryImage.count - 1] {
                store.send(._paginationImageData)
              }
            }
        }
      }
    }
  }
  
  @ViewBuilder
  private func imageBox(image: UIImage) -> some View {
    ZStack {
      Image(uiImage: image)
        .resizable()
        .scaledToFill()
        .frame(maxWidth: UIScreen.main.bounds.width / 3 - 4)
        .frame(height: UIScreen.main.bounds.width / 3 - 8)
        .clipped()
      
      VStack {
        HStack {
          Spacer()
          
          Circle()
            .stroke(
              store.selectedImage.contains(image) ? .wineyMain2 : Color(.systemGray4),
              lineWidth: 2
            )
            .frame(width: 24, height: 24)
            .overlay(
              Circle()
                .fill(store.selectedImage.contains(image) ? .wineyMain2 : .clear)
                .frame(width: 22, height: 22)
            )
            .overlay(
              Text(store.selectedImage.firstIndex(of: image) != nil ? "\(store.selectedImage.firstIndex(of: image)! + 1)" : "")
                .wineyFont(.bodyM2)
                .foregroundStyle(.black)
            )
        }
        
        Spacer()
      }
      .padding(.vertical, 8)
      .padding(.horizontal, 9)
      .background(
        store.selectedImage.contains(image) ? Color(.systemGray2).opacity(0.4) : .clear
      )
    }
    .frame(height: UIScreen.main.bounds.width / 3 - 8)
    .onTapGesture {
      store.send(.tappedImage(image))
    }
    .border(
      store.selectedImage.contains(image) ? .wineyMain2 : .clear,
      width: 2
    )
  }
  
  @ViewBuilder
  private func cameraButton() -> some View {
    Image(systemName: "camera")
      .wineyFont(.bodyB1)
      .foregroundStyle(.wineyMain2)
      .frame(maxWidth: .infinity)
      .frame(height: UIScreen.main.bounds.width / 3 - 8)
      .background(.wineyGray950)
      .onTapGesture {
        store.send(.tappedCameraButton)
      }
  }
}


#Preview {
  CustomGalleryView(
    store: Store(
      initialState: CustomGallery.State(availableSelectCount: 3),
      reducer: {
        CustomGallery()
      }
    )
  )
}
