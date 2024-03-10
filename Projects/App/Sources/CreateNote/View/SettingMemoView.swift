//
//  SettingMemoView.swift
//  Winey
//
//  Created by 정도현 on 11/14/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import PhotosUI
import SwiftUI
import WineyKit

public struct SettingMemoView: View {
  private let store: StoreOf<SettingMemo>
  @ObservedObject var viewStore: ViewStoreOf<SettingMemo>
  @FocusState private var isFocused: Bool
  
  public init(store: StoreOf<SettingMemo>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      navigation()
      
      ScrollView {
        VStack(alignment: .leading, spacing: 0) {
          header()
          
          attachPhotoButton()
          
          userCommentView()
          
          checkView()
        }
      }
      
      bottomButton()
    }
    .fullScreenCover(
      isPresented: viewStore.binding(
        get: \.isShowGallery,
        send: .tappedOutsideOfBottomSheet
      ), content: {
        IfLetStore(
          self.store.scope(
            state: \.customGallery,
            action: SettingMemo.Action.customGallery
          )
        ) {
          CustomGalleryView(store: $0)
        }
      }
    )
    .background(
      WineyKitAsset.mainBackground.swiftUIColor
    )
    .onTapGesture {
      isFocused = false
    }
    .onAppear {
      viewStore.send(._viewWillAppear)
    }
    .navigationBarHidden(true)
  }
}

extension SettingMemoView {
  
  @ViewBuilder
  private func navigation() -> some View {
    NavigationBar(
      title: "와인 정보 입력",
      leftIcon: Image("navigationBack_button"),
      leftIconButtonAction: {
        viewStore.send(.tappedBackButton)
      },
      backgroundColor: .clear
    )
  }
  
  @ViewBuilder
  private func header() -> some View {
    VStack(alignment: .leading, spacing: 4) {
      Text("마지막이에요!")
        .wineyFont(.bodyB1)
        .foregroundStyle(WineyKitAsset.main2.swiftUIColor)
      
      HStack(spacing: 2) {
        Text("와인에 대한 메모를 작성해주세요")
          .wineyFont(.bodyB1)
          .foregroundStyle(WineyKitAsset.gray50.swiftUIColor)
        
        Text("(선택)")
          .wineyFont(.bodyB2)
          .foregroundStyle(WineyKitAsset.gray600.swiftUIColor)
      }
    }
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .onTapGesture {
      isFocused = false
    }
  }
  
  @ViewBuilder
  private func attachPhotoButton() -> some View {
    VStack(spacing: 15) {
      LazyVGrid(columns: columns) {
        ForEach(viewStore.displayImages, id: \.self) { image in
          ZStack {
            Image(uiImage: image)
              .resizable()
              .clipShape(RoundedRectangle(cornerRadius: 10))
              .frame(height: 100)
            
            VStack(alignment: .trailing) {
              HStack {
                Spacer()
                
                Button(action: {
                  viewStore.send(.tappedDelImage(image))
                }, label: {
                  Image("imageX")
                })
              }
              .padding(.trailing, 9)
              .padding(.top, 7)
              
              Spacer()
            }
          }
        }
      }
      
      Button {
        viewStore.send(.tappedAttachPictureButton)
      } label: {
        HStack(alignment: .center, spacing: 4) {
          Text("사진 첨부하기")
          Image(systemName: "camera")
        }
        .wineyFont(.bodyM2)
        .foregroundStyle(WineyKitAsset.main2.swiftUIColor)
        .frame(maxWidth: .infinity)
        .frame(height: 47)
        .background(
          RoundedRectangle(cornerRadius: 10)
            .stroke(WineyKitAsset.main2.swiftUIColor)
        )
        .tint(WineyKitAsset.main2.swiftUIColor)
      }
    }
    .padding(.top, viewStore.displayImages.isEmpty ? 30 : 15)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
  
  @ViewBuilder
  private func userCommentView() -> some View {
    VStack(alignment: .trailing, spacing: 10) {
      TextField(
        "와인에 대한 생각을 작성해주세요 :)",
        text: viewStore.binding(
          get: \.memo,
          send: SettingMemo.Action.writingMemo
        ),
        axis: .vertical
      )
      .lineLimit(8, reservesSpace: true)
      .wineyFont(.captionM1)
      .padding(.vertical, 14)
      .padding(.horizontal, 15)
      .autocorrectionDisabled()
      .textInputAutocapitalization(.never)
      .background(
        RoundedRectangle(cornerRadius: 10)
          .stroke(isFocused ? .white : WineyKitAsset.gray800.swiftUIColor)
      )
      .onChange(of: viewStore.memo, perform: { value in
        if value.count > viewStore.maxCommentLength {
          viewStore.send(._limitMemo(value))
        }
      })
      .tint(.white)
      .focused($isFocused)
      
      Text("\(viewStore.memo.count)/\(viewStore.maxCommentLength)")
        .wineyFont(.bodyM2)
        .foregroundStyle(WineyKitAsset.gray500.swiftUIColor)
    }
    .padding(.top, 15)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
  
  @ViewBuilder
  private func checkView() -> some View {
    VStack(alignment: .leading, spacing: 28) {
      HStack {
        Text("와인은 어떠셨어요?")
          .foregroundStyle(.white)
          .wineyFont(.bodyB1)
        
        Spacer()
        
        ForEach(viewStore.ratingRange, id: \.self) { index in
          if index <= viewStore.rating {
            WineyAsset.Assets.activeWineIcon.swiftUIImage
              .onTapGesture {
                isFocused = false
                viewStore.send(.tappedWineStar(index))
              }
          } else {
            WineyAsset.Assets.defaultWineIcon.swiftUIImage
              .onTapGesture {
                isFocused = false
                viewStore.send(.tappedWineStar(index))
              }
          }
        }
      }
      
      HStack(spacing: 8) {
        Text("재구매 의사")
          .foregroundStyle(.white)
          .wineyFont(.bodyB1)
        
        Spacer()
        
        CapsuleButton(
          title: "있어요",
          validation: viewStore.buyAgain ?? false,
          action: {
            viewStore.send(._setBuyAgain(true))
          }
        )
        
        CapsuleButton(
          title: "없어요",
          validation: !(viewStore.buyAgain ?? true),
          action: {
            viewStore.send(._setBuyAgain(false))
          }
        )
      }
    }
    .padding(.top, 30)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .padding(.bottom, 10)
    .onTapGesture {
      isFocused = false
    }
  }
  
  @ViewBuilder
  private func bottomButton() -> some View {
    WineyConfirmButton(
      title: "작성완료",
      validBy: viewStore.buyAgain != nil && viewStore.rating > 0
    ) {
      viewStore.send(.tappedDoneButton)
    }
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .padding(.bottom, WineyGridRules.bottomButtonPadding)
  }
}

#Preview {
  SettingMemoView(
    store: Store(
      initialState: SettingMemo.State(),
      reducer: {
        SettingMemo()
      }
    )
  )
}
