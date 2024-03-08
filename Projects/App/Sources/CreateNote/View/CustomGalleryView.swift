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
  @ObservedObject var viewStore: ViewStoreOf<CustomGallery>
  
  public init(store: StoreOf<CustomGallery>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var columns: [GridItem] = [GridItem(.flexible(), spacing: 4), GridItem(.flexible(), spacing: 4), GridItem(.flexible())]
  
  public var body: some View {
    VStack(spacing: 0) {
      header()
      
      imageList()
    }
    .onAppear {
      viewStore.send(._viewWillAppear)
    }
    .background(WineyKitAsset.mainBackground.swiftUIColor)
    .navigationBarHidden(true)
  }
}

extension CustomGalleryView {
  
  @ViewBuilder
  private func header() -> some View {
    VStack(spacing: 0) {
      HStack {
        Text("X")
          .tint(.white)
          .onTapGesture {
            viewStore.send(.tappedDismissButton)
          }
        
        Spacer()
        
        Button(action: {
          
        }, label: {
          Text("첨부하기(\(viewStore.selectedImage.count)/\(viewStore.availableSelectCount))")
            .wineyFont(.captionM1)
        })
        .tint(WineyKitAsset.main2.swiftUIColor)
      }
      .padding(.vertical, 14)
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      
      Divider()
        .overlay(.black)
    }
  }
  
  @ViewBuilder
  private func imageList() -> some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: 4) {
        ForEach(viewStore.userGalleryImage, id: \.self) { image in
          Image(uiImage: image)
            .resizable()
            .frame(height: 126)
            .onTapGesture {
              viewStore.send(.tappedImage(image))
            }
        }
      }
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
