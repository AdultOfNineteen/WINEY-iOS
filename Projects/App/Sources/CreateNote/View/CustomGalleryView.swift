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
    .sheet(
      isPresented: viewStore.binding(
        get: \.isOpenCamera,
        send: .tappedOutsideOfBottomSheet
      ), content: {
        // CustomCameraView()
      }
    )
    .background(WineyKitAsset.mainBackground.swiftUIColor)
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
            viewStore.send(.tappedDismissButton)
          }
        
        Spacer()
        
        Button(action: {
          viewStore.send(.tappedAttachButton)
        }, label: {
          Text("첨부하기 (\(viewStore.selectedImage.count)/\(viewStore.availableSelectCount))")
            .wineyFont(.subhead)
            .bold()
        })
        .tint(WineyKitAsset.main2.swiftUIColor)
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
        
        ForEach(viewStore.userGalleryImage, id: \.self) { image in
          ZStack {
            Image(uiImage: image)
              .resizable()
              .frame(height: 126)
            
            VStack {
              HStack {
                Spacer()
                
                Circle()
                  .stroke(
                    viewStore.selectedImage.contains(image) ? WineyKitAsset.main2.swiftUIColor : Color(.systemGray4),
                    lineWidth: 2
                  )
                  .frame(width: 24, height: 24)
                  .overlay(
                    Circle()
                      .fill(viewStore.selectedImage.contains(image) ? WineyKitAsset.main2.swiftUIColor : .clear)
                      .frame(width: 22, height: 22)
                  )
                  .overlay(
                    Text(viewStore.selectedImage.firstIndex(of: image) != nil ? "\(viewStore.selectedImage.firstIndex(of: image)! + 1)" : "")
                      .wineyFont(.bodyM2)
                      .foregroundStyle(.black)
                  )
              }
              
              Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 9)
            .background(
              viewStore.selectedImage.contains(image) ? Color(.systemGray2).opacity(0.4) : .clear
            )
          }
          .onTapGesture {
            viewStore.send(.tappedImage(image))
          }
          .border(
            viewStore.selectedImage.contains(image) ? WineyKitAsset.main2.swiftUIColor : .clear,
            width: 2
          )
        }
      }
    }
  }
  
  @ViewBuilder
  private func cameraButton() -> some View {
    Image(systemName: "camera")
      .wineyFont(.bodyB1)
      .foregroundStyle(WineyKitAsset.main2.swiftUIColor)
      .onTapGesture {
        print("tap Camera")
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
