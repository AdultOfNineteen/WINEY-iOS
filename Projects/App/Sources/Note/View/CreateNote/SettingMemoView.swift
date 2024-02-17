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
    .ignoresSafeArea(edges: .bottom)
    .sheet(
      isPresented: viewStore.binding(
        get: \.isShowBottomSheet,
        send: .tappedOutsideOfBottomSheet
      ), content: {
        bottomSheetOptions()
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
  private func bottomSheetOptions() -> some View {
    ZStack {
      WineyKitAsset.gray950.swiftUIColor.ignoresSafeArea(edges: .all)
      
      VStack(spacing: 0) {
        HStack {
          Text("카메라")
            .wineyFont(.bodyB1)
            .foregroundStyle(.white)
        }
        .padding(.vertical, 20)
        .frame(height: 64)
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
        .onTapGesture {
          // TODO: Camera
        }
        
        Divider()
          .overlay(
            WineyKitAsset.gray900.swiftUIColor
          )
        
        PhotosPicker(
          selection: viewStore.binding(
            get: { $0.selectedPhoto },
            send: SettingMemo.Action._pickPhoto
          ),
          maxSelectionCount: viewStore.maxPhoto,
          matching: .any(of: [.images, .not(.videos)])
        ) {
          HStack {
            Text("앨범에서 가져오기")
              .wineyFont(.bodyB1)
              .foregroundStyle(.white)
          }
          .padding(.vertical, 20)
          .frame(height: 64)
          .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
        }
      }
    }
    .presentationDetents([.height(187)])
    .presentationDragIndicator(.visible)
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
        ForEach(0..<viewStore.displayPhoto.count, id: \.self) { idx in
          ZStack {
            Image(uiImage: viewStore.displayPhoto[idx])
              .resizable()
              .clipShape(RoundedRectangle(cornerRadius: 10))
              .frame(height: 100)
            
            VStack(alignment: .trailing) {
              HStack {
                Spacer()
                
                Button(action: {
                  viewStore.send(.tappedDelImage(idx))
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
      .onChange(of: viewStore.selectedPhoto, perform: { value in
        Task {
          viewStore.send(._delDisplayPhoto)
          
          for item in viewStore.selectedPhoto {
            if let data = try? await item.loadTransferable(type: Data.self) {
              if let image = UIImage(data: data) {
                viewStore.send(._addPhoto(image))
              }
            }
          }
        }
      })
      
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
//        .simultaneousGesture(
//          TapGesture().onEnded({ tap in
//            viewStore.send(._delPickPhoto)
//          })
//        )
      }
    }
    .padding(.top, viewStore.displayPhoto.isEmpty ? 30 : 15)
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
        
        ForEach(viewStore.starRange, id: \.self) { index in
          if index <= viewStore.star {
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
    .onTapGesture {
      isFocused = false
    }
  }
  
  @ViewBuilder
  private func bottomButton() -> some View {
    WineyConfirmButton(
      title: "작성완료",
      validBy: viewStore.buyAgain != nil && viewStore.star > 0
    ) {
      viewStore.send(.tappedDoneButton)
    }
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .padding(.bottom, 54)
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
