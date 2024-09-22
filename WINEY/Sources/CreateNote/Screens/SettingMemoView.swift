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
  
  @FocusState private var isFocused: Bool
  
  public init(store: StoreOf<SettingMemo>) {
    self.store = store
  }
  
  public var columns: [GridItem] = [
    GridItem(.flexible(), spacing: 9),
    GridItem(.flexible(), spacing: 4),
    GridItem(.flexible())
  ]
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      navigation()
      
      ScrollView {
        LazyVStack(alignment: .leading, spacing: 0) {
          header()
          
          attachPhotoButton()
          
          userCommentView()
          
          checkView()
        }
      }
      
      bottomButton()
    }
    .fullScreenCover(
      isPresented: .init(
        get: { store.isShowGallery },
        set: { _ in store.send(.tappedOutsideOfBottomSheet) }
      ), content: {
        IfLetStore(
          self.store.scope(
            state: \.customGallery,
            action: \.customGallery
          )
        ) {
          CustomGalleryView(store: $0)
        }
      }
    )
    .background(
      .wineyMainBackground
    )
    .onTapGesture {
      isFocused = false
    }
    .onAppear {
      store.send(._viewWillAppear)
    }
    .navigationBarHidden(true)
  }
}

extension SettingMemoView {
  
  @ViewBuilder
  private func navigation() -> some View {
    NavigationBar(
      title: "와인 정보 입력",
      leftIcon: Image(.navigationBack_buttonW),
      leftIconButtonAction: {
        store.send(.tappedBackButton)
      },
      backgroundColor: .clear
    )
  }
  
  @ViewBuilder
  private func header() -> some View {
    VStack(alignment: .leading, spacing: 4) {
      Text("마지막이에요!")
        .wineyFont(.bodyB1)
        .foregroundStyle(.wineyMain2)
      
      HStack(spacing: 2) {
        Text("와인에 대한 메모를 작성해주세요")
          .wineyFont(.bodyB1)
          .foregroundStyle(.wineyGray50)
        
        Text("(선택)")
          .wineyFont(.bodyB2)
          .foregroundStyle(.wineyGray600)
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
        ForEach(store.displayImages, id: \.self) { image in
          ZStack {
            Image(uiImage: image)
              .resizable()
              .scaledToFill()
              .frame(width: (UIScreen.main.bounds.width - 48 - 18)/3, height: (UIScreen.main.bounds.width - 48 - 18)/3)
              .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .trailing) {
              HStack {
                Spacer()
                
                Button(action: {
                  store.send(.tappedDelImage(image))
                }, label: {
                  Image(.imageXW)
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
        store.send(.tappedAttachPictureButton)
      } label: {
        HStack(alignment: .center, spacing: 4) {
          Text("사진 첨부하기")
          Image(systemName: "camera")
        }
        .wineyFont(.bodyM2)
        .foregroundStyle(.wineyMain2)
        .frame(maxWidth: .infinity)
        .frame(height: 47)
        .background(
          RoundedRectangle(cornerRadius: 10)
            .stroke(.wineyMain2)
        )
        .tint(.wineyMain2)
      }
    }
    .padding(.top, store.displayImages.isEmpty ? 30 : 15)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
  
  @ViewBuilder
  private func userCommentView() -> some View {
    VStack(alignment: .trailing, spacing: 10) {
      TextField(
        "와인에 대한 생각을 작성해주세요 :)",
        text: .init(
          get: { store.memo },
          set: { memo in store.send(.writingMemo(memo)) }
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
          .stroke(isFocused ? .white : .wineyGray800)
      )
      .onChange(of: store.memo, perform: { value in
        if value.count > store.maxCommentLength {
          store.send(._limitMemo(value))
        }
      })
      .tint(.white)
      .focused($isFocused)
      
      Text("\(store.memo.count)/\(store.maxCommentLength)")
        .wineyFont(.bodyM2)
        .foregroundStyle(.wineyGray500)
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
        
        ForEach(store.ratingRange, id: \.self) { index in
          if index <= store.rating {
            Image(.activeWineIconW)
              .onTapGesture {
                isFocused = false
                store.send(.tappedWineStar(index))
              }
          } else {
            Image(.defaultWineIconW)
              .onTapGesture {
                isFocused = false
                store.send(.tappedWineStar(index))
              }
          }
        }
      }
      
      YesOrNoButton(
        title: "재구매 의사",
        validation: .init(
          get: {
            store.buyAgain
          },
          set: { state in
            guard let state else { return }
            store.send(._setBuyAgain(state))
          }
        )
      )
      
      YesOrNoButton(
        title: "노트 공개 여부",
        validation: .init(
          get: {
            store.isPublic
          },
          set: { state in
            guard let state else { return }
            store.send(._setIsPublic(state)) // 수정
          }
        )
      )
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
      validBy: store.buyAgain != nil && store.rating > 0
    ) {
      store.send(.tappedDoneButton)
    }
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .padding(.bottom, WineyGridRules.bottomButtonPadding)
  }
}

struct YesOrNoButton: View {
  @Binding var validation: Bool?
  let title: String
  
  init(
    title: String,
    validation: Binding<Bool?>
  ) {
    self.title = title
    self._validation = validation
  }
  
  var body: some View {
    HStack(spacing: 8) {
      Text(title)
        .foregroundStyle(.white)
        .wineyFont(.bodyB1)
      
      Spacer()
      
      CapsuleButton(
        title: "있어요",
        validation: validation ?? false,
        action: {
          validation = true
        }
      )
      
      CapsuleButton(
        title: "없어요",
        validation: !(validation ?? true),
        action: {
          validation = false
        }
      )
    }
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
