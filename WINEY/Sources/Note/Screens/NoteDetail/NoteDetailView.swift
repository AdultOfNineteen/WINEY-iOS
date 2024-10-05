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
  @Bindable var store: StoreOf<NoteDetail>
  
  public init(store: StoreOf<NoteDetail>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      // MARK: Navigation Bar
      if store.noteMode != .openOtherNote {
        NavigationBar(
          leftIcon: Image(.navigationBack_buttonW),
          leftIconButtonAction: {
            store.send(.tappedBackButton)
          },
          rightIcon: Image(.settingIconW),
          rightIconButtonAction: {
            store.send(.tappedSettingButton)
          },
          backgroundColor: Color.wineyMainBackground
        )
      } else {
        NavigationBar(
          leftIcon: Image(.navigationBack_buttonW),
          leftIconButtonAction: {
            store.send(.tappedBackButton)
          },
          backgroundColor: Color.wineyMainBackground
        )
      }
      
      if let noteData = store.noteCardData {
        noteDetail(noteData: noteData)
      } else {
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .sheet(item: $store.scope(state: \.sheetDestination?.tripleSectionSheet, action: \.sheetDestination.tripleSectionSheet), content: { store in
      TripleSectionBottomSheetView(store: store)
    })
    .task {
      store.send(._viewWillAppear)
    }
    .background(.wineyMainBackground)
    .navigationBarHidden(true)
  }
}

extension NoteDetailView {
  
  @ViewBuilder
  private func noteDetail(noteData: NoteDetailDTO) -> some View {
    ScrollView {
      LazyVStack(spacing: 0) {
        // MARK: Note Number & Date
        noteHeader(noteData: noteData)
        
        // MARK: WINE TYPE, NAME
        noteWineType(noteData: noteData)
        
        Divider()
          .overlay(.wineyGray900)
          .padding(.top, 20)
          .padding(.bottom, 40)
        
        // MARK: Wine Info
        WineDetailInfoMiddleView(
          wineType: WineType.changeType(at: noteData.wineType),
          nationalAnthems: store.country,
          varities: noteData.varietal,
          abv: noteData.officialAlcohol,
          purchasePrice: noteData.price,
          vintage: noteData.vintage,
          star: noteData.star,
          buyAgain: noteData.buyAgain,
          mode: .note
        )
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
        
        if store.noteMode == .mynote || store.noteMode == .otherNotes {
          noteDetailSection()
        }
        
        if store.noteMode != .otherNotes {
          NoteDetailSmellFeatureView(
            circleColor: noteData.color,
            smellKeywordList: Array(noteData.smellKeywordList)
          )
          .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
          
          Divider()
            .frame(height: 0.8)
            .overlay(.wineyGray900)
            .padding(.vertical, 20)
          
          NoteDetailGraphTabView(
            noteCardData: noteData
          )
          .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
          
          Divider()
            .overlay(.wineyGray900)
            .padding(.top, 10)
            .padding(.bottom, 30)
          
          // MARK: Image, memo
          noteImageMemo(noteData: noteData)
        } else {
          otherNoteList()
        }
      }
    }
  }
  
  @ViewBuilder
  private func noteDetailSection() -> some View {
    VStack(spacing: 0) {
      Divider()
        .frame(height: 0.8)
        .overlay(.wineyGray900)
      
      HStack(spacing: 0) {
        noteDetailSectionButton(mode: .mynote)
        noteDetailSectionButton(mode: .otherNotes)
      }
      
      Divider()
        .frame(height: 0.8)
        .overlay(.wineyGray900)
    }
    .padding(.top, 38)
    .padding(.bottom, 30)
  }
  
  @ViewBuilder
  private func noteDetailSectionButton(mode: NoteDetailSection) -> some View {
    Text(mode.rawValue)
      .wineyFont(.bodyM2)
      .frame(maxWidth: .infinity)
      .padding(.top, 11)
      .padding(.bottom, 10)
      .foregroundStyle(store.noteMode == mode ? .white : .wineyGray700)
      .background(.wineyMainBackground)
      .onTapGesture {
        store.send(.tappedNoteMode(mode))
      }
  }
  
  @ViewBuilder
  private func noteHeader(noteData: NoteDetailDTO) -> some View {
    HStack(spacing: 0) {
      if store.noteMode != .openOtherNote {
        Text("No.")
          .wineyFont(.bodyB1)
        Text(noteData.tastingNoteNo < 10 ? "0" + noteData.tastingNoteNo.description : noteData.tastingNoteNo.description)
          .wineyFont(.bodyB1)
          .foregroundColor(.wineyMain3)
      } else {
        Text("Tasted by")
          .wineyFont(.captionM3)
          .padding(.trailing, 8)
          .foregroundColor(.wineyGray50)
        
        Text(noteData.userNickname)
          .wineyFont(.bodyB1)
          .foregroundColor(.wineyGray50)
      }
      
      Spacer()
      
      Text(noteData.noteDate)
        .wineyFont(.bodyB1)
    }
    .wineyFont(.bodyB1)
    .padding(.top, 5.34)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
  
  @ViewBuilder
  private func otherNoteList() -> some View {
    VStack(spacing: 0) {
      VStack(alignment: .leading, spacing: 20) {
        Text("Other Notes")
          .wineyFont(.display2)
          .foregroundStyle(.white)
        
        HStack(spacing: 0) {
          Text("\(store.otherNoteCount)개")
            .foregroundStyle(.wineyMain3)
          
          Text("의 테이스팅 노트가 있어요!")
            .foregroundStyle(.white)
          
          Spacer()
        }
        .wineyFont(.title2)
      }
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      
      if store.otherNoteCount > 0 {
        LazyVStack(spacing: 5) {
          ForEachStore(
            store.scope(state: \.otherNotes, action: \.otherNote)
          ) { store in
            OtherNoteView(store: store)
          }
        }
        .padding(.leading, 24)
        .padding(.trailing, 5)
        .padding(.vertical, 20)
      } else {
        VStack(spacing: 13) {
          Image(.emptyNoteIconW)
          
          VStack(spacing: 6) {
            Text("등록된 노트가 없어요 :(")
              .wineyFont(.headLine)
            
            Text("이 와인의 첫 와이너가 되어보세요!")
              .wineyFont(.bodyM2)
          }
          .foregroundStyle(.wineyGray800)
          .padding(.top, 13)
        }
        .padding(.vertical, 58)
      }
      
      HStack(spacing: 0) {
        Text("더 보러가기")
          .wineyFont(.bodyM2)
          .foregroundStyle(.wineyGray400)
        
        Image(.ic_arrow_rightW)
      }
      .background(.wineyMainBackground)
      .onTapGesture {
        store.send(.tappedMoreOtherNote)
      }
      .padding(.bottom, 110)
    }
  }
  
  @ViewBuilder
  private func noteWineType(noteData: NoteDetailDTO) -> some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(WineType.changeType(at: noteData.wineType).typeName)
        .wineyFont(.display1)
        .foregroundColor(.wineyGray50)
        .frame(alignment: .topLeading)
      
      Text(noteData.wineName.useNonBreakingSpace())
        .wineyFont(.bodyB2)
        .foregroundColor(.wineyGray500)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.trailing, 51)
    }
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .padding(.top, 16)
  }
  
  @ViewBuilder
  private func noteImageMemo(noteData: NoteDetailDTO) -> some View {
    VStack(spacing: 0) {
      HStack {
        Text("Feelings")
          .wineyFont(.display2)
        
        Spacer()
      }
      
      if !noteData.tastingNoteImage.isEmpty {
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(spacing: 10) {
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
            .stroke(.wineyGray800)
        )
        .padding(.top, 36)
    }
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
}

#Preview {
  NoteDetailView(
    store: Store(
      initialState: NoteDetail.State.init(
        noteMode: .mynote, noteId: 1, country: "test"
      ),
      reducer: {
        NoteDetail()
      }
    )
  )
}
