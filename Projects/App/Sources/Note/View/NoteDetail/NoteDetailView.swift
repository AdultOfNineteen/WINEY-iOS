//
//  NoteDetailView.swift
//  Winey
//
//  Created by 정도현 on 10/19/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct NoteDetailView: View {
  private let store: StoreOf<NoteDetail>
  @ObservedObject var viewStore: ViewStoreOf<NoteDetail>
  
  public init(store: StoreOf<NoteDetail>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      // MARK: Navigation Bar
      NavigationBar(
        leftIcon: WineyAsset.Assets.navigationBackButton.swiftUIImage,
        leftIconButtonAction: {
          viewStore.send(.tappedBackButton)
        },
        rightIcon: WineyAsset.Assets.settingIcon.swiftUIImage,
        rightIconButtonAction: {
          viewStore.send(.tappedSettingButton)
        },
        backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
      )
      
      if let noteData = viewStore.noteCardData {
        noteDetail(noteData: noteData)
      } else {
        VStack {
          Spacer()
          Text("네트워크 오류")
          Spacer()
        }
      }
    }
    .onAppear {
      viewStore.send(._viewWillAppear)
    }
    .sheet(
      isPresented: viewStore.binding(
        get: \.isPresentedBottomSheet,
        send: .tappedOutsideOfBottomSheet
      ), content: {
        ZStack {
          WineyKitAsset.gray950.swiftUIColor.ignoresSafeArea(edges: .all)
          selectOptionView()
        }
        .presentationDetents([.height(187)])
        .presentationDragIndicator(.visible)
      }
    )
    .bottomSheet(
      backgroundColor: WineyKitAsset.gray950.swiftUIColor,
      isPresented: viewStore.binding(
        get: \.isPresentedRemoveSheet,
        send: .tappedOutsideOfBottomSheet
      ),
      headerArea: {
        WineyAsset.Assets.noteColorImage.swiftUIImage
      },
      content: {
        bottomSheetContent()
      },
      bottomArea: {
        bottomSheetFooter()
      }
    )
    .background(WineyKitAsset.background1.swiftUIColor)
    .navigationBarHidden(true)
  }
}

extension NoteDetailView {
  
  @ViewBuilder
  private func noteDetail(noteData: NoteDetailDTO) -> some View {
    ScrollView {
      VStack(spacing: 0) {
        // MARK: Note Number & Date
        noteHeader(noteData: noteData)
        
        // MARK: WINE TYPE, NAME
        noteWineType(noteData: noteData)
        
        Divider()
          .overlay(WineyKitAsset.gray900.swiftUIColor)
          .padding(.top, 20)
          .padding(.bottom, 40)
        
        // MARK: Wine Info
        WineDetailInfoMiddle(
          illustImage: WineType.changeType(at: noteData.wineType).illustImage,
          circleBorderColor: WineType.changeType(at: noteData.wineType).cirlcleBorderColor,
          secondaryColor: WineType.changeType(at: noteData.wineType).backgroundColor.secondCircle,
          nationalAnthems: noteData.region,
          varities: noteData.varietal,
          abv: noteData.officialAlcohol,
          purchasePrice: noteData.price,
          vintage: noteData.vintage,
          star: noteData.star,
          buyAgain: noteData.buyAgain,
          mode: .note
        )
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
        
        Divider()
          .overlay(WineyKitAsset.gray900.swiftUIColor)
          .padding(.top, 40)
          .padding(.bottom, 30)
        
        // MARK: FEATURE
        NoteDetailSmellFeatureView(
          circleColor: noteData.color,
          smellKeywordList: Array(noteData.smellKeywordList)
        )
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
        
        Divider()
          .overlay(WineyKitAsset.gray900.swiftUIColor)
          .padding(.vertical, 20)
        
        // MARK: Note Card Graph
        NoteDetailGraphTabView(
          noteCardData: noteData
        )
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
        
        Divider()
          .overlay(WineyKitAsset.gray900.swiftUIColor)
          .padding(.top, 10)
          .padding(.bottom, 30)
        
        // MARK: Image, memo
        noteImageMemo(noteData: noteData)
      }
    }
  }
  
  @ViewBuilder
  private func noteHeader(noteData: NoteDetailDTO) -> some View {
    HStack(spacing: 0) {
      Text("No.")
      Text(noteData.noteId < 10 ? "0" + noteData.noteId.description : noteData.noteId.description)
        .foregroundColor(WineyKitAsset.main3.swiftUIColor)
      
      Spacer()
      
      Text(noteData.noteDate)
    }
    .wineyFont(.bodyB1)
    .padding(.top, 20)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
  
  @ViewBuilder
  private func noteWineType(noteData: NoteDetailDTO) -> some View {
    VStack(spacing: 0) {
      HStack {
        Text(WineType.changeType(at: noteData.wineType).typeName)
          .wineyFont(.display1)
          .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
          .frame(height: 54, alignment: .topLeading)
        
        Spacer()
      }
      
      HStack {
        Text(noteData.wineName.useNonBreakingSpace())
          .wineyFont(.bodyB2)
          .foregroundColor(WineyKitAsset.gray500.swiftUIColor)
          .frame(width: 271, alignment: .topLeading)
        
        Spacer()
      }
      .padding(.top, 16)
    }
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .padding(.top, 30)
  }
  
  @ViewBuilder
  private func noteImageMemo(noteData: NoteDetailDTO) -> some View {
    VStack(spacing: 0) {
      HStack {
        Text("Feature")
          .wineyFont(.display2)
        
        Spacer()
      }
      
      if !noteData.tastingNoteImage.isEmpty {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 10) {
            ForEach(Array(noteData.tastingNoteImage), id: \.self) { imageData in
              CachedImageView(url: imageData.imgUrl)
                .frame(width: 120, height: 120)
                .cornerRadius(10)
            }
          }
        }
      }
      
      Text(noteData.memo.isEmpty ? "입력한 내용이 없어요!" : noteData.memo)
        .wineyFont(.captionM1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 15)
        .padding(.vertical, 14)
        .background(
          RoundedRectangle(cornerRadius: 10)
            .stroke(WineyKitAsset.gray800.swiftUIColor)
        )
        .padding(.top, 36)
    }
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
  
  @ViewBuilder
  private func selectOptionView() -> some View {
    VStack(spacing: 0) {
      selectOptionListCard(option: .remove)
      
      Divider()
        .overlay(
          WineyKitAsset.gray900.swiftUIColor
        )
      
      selectOptionListCard(option: .modify)
    }
  }
  
  @ViewBuilder
  private func selectOptionListCard(option: NoteDetailOption) -> some View {
    HStack {
      Text(option.rawValue)
        .wineyFont(.bodyB1)
        .foregroundStyle(.white)
      
      Spacer()
    }
    .padding(.vertical, 20)
    .frame(height: 64)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .onTapGesture {
      viewStore.send(.tappedOption(option))
    }
  }
  
  @ViewBuilder
  private func bottomSheetContent() -> some View {
    VStack(spacing: 4) {
      Text("테이스팅 노트를 삭제하시겠어요?")
        .foregroundStyle(WineyKitAsset.gray200.swiftUIColor)
      
      Text("삭제한 노트는 복구할 수 없어요 :(")
        .foregroundStyle(WineyKitAsset.gray600.swiftUIColor)
    }
    .wineyFont(.bodyB1)
  }
  
  @ViewBuilder
  private func bottomSheetFooter() -> some View {
    TwoOptionSelectorButtonView(
      leftTitle: "아니오",
      leftAction: { viewStore.send(._presentRemoveSheet(false)) }
      ,
      rightTitle: "네, 지울래요",
      rightAction: {
        viewStore.send(.tappedNoteDelete(viewStore.noteId))
      }
    )
  }
}

#Preview {
  NoteDetailView(
    store: Store(
      initialState: NoteDetail.State.init(
        noteId: 1
      ),
      reducer: {
        NoteDetail()
      }
    )
  )
}
