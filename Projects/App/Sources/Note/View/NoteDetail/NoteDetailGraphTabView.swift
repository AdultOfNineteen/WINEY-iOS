//
//  NoteDetailGarphTabView.swift
//  Winey
//
//  Created by 정도현 on 10/19/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit

// MARK: 내가 느낀 와인 맛, 와인의 기본 맛
public enum GraphCase {
  case user
  case wineDefault
  
  func graphColor() -> Color {
    switch self {
    case .user:
      return WineyKitAsset.main2.swiftUIColor
    case .wineDefault:
      return WineyKitAsset.point1.swiftUIColor
    }
  }
}

public struct NoteDetailGraphTabView: View {
  public let noteCardData: NoteDetailDTO
  
  public var body: some View {
    TabView {
      WineDetailGraphMyWineTasteView(
        myWineTaste: noteCardData.myWineTaste
      )
      WineDetailGraphMyWineDefaultView(
        defaultTaste: noteCardData.defaultWineTaste
      )
    }
    .tabViewStyle(PageTabViewStyle())
    .onAppear {
      setupAppearance()
    }
    .frame(height: 490)
  }
}

// MARK: 와인의 기본 맛
public struct WineDetailGraphMyWineTasteView: View {
  public let myWineTaste: MyWineTaste
  public let graphColor: Color = WineyKitAsset.main2.swiftUIColor
  
  public var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 6) {
        Circle()
          .fill(graphColor)
          .frame(width: 12)
          .aspectRatio(contentMode: .fit)
        
        Text("내가 느낀 와인의 맛")
          .wineyFont(.captionM2)
        
        Spacer()
      }
      
      Spacer()
        .frame(height: 28)
      
      VStack(spacing: 25) {
        WineInfoDetailSingleGraphView(
          value: myWineTaste.sweetness,
          category: "당도",
          graphColor: graphColor,
          isValid: true
        )
        WineInfoDetailSingleGraphView(
          value: myWineTaste.acidity,
          category: "산도",
          graphColor: graphColor,
          isValid: true
        )
        WineInfoDetailSingleGraphView(
          value: myWineTaste.body,
          category: "바디",
          graphColor: graphColor,
          isValid: true
        )
        WineInfoDetailSingleGraphView(
          value: myWineTaste.tannin,
          category: "탄닌",
          graphColor: graphColor,
          isValid: true
        )
        WineInfoDetailSingleGraphView(
          value: myWineTaste.alcohol,
          category: "알코올",
          graphColor: graphColor,
          isValid: true
        )
        WineInfoDetailSingleGraphView(
          value: myWineTaste.finish,
          category: "여운",
          graphColor: graphColor,
          isValid: true
        )
      }
      
      Spacer()
    }
  }
}

// MARK: 와인의 기본 맛
public struct WineDetailGraphMyWineDefaultView: View {
  public let defaultTaste: DefaultWineTaste
  public let graphColor: Color = WineyKitAsset.point1.swiftUIColor
  
  public var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 6) {
        Circle()
          .fill(graphColor)
          .frame(width: 12)
          .aspectRatio(contentMode: .fit)
        
        Text("와인의 기본 맛")
          .wineyFont(.captionM2)
        
        Spacer()
      }
      
      Spacer()
        .frame(height: 28)
      
      VStack(spacing: 25) {
        WineInfoDetailSingleGraphView(
          value: defaultTaste.sweetness,
          category: "당도",
          graphColor: graphColor,
          isValid: true
        )
        WineInfoDetailSingleGraphView(
          value: defaultTaste.acidity,
          category: "산도",
          graphColor: graphColor,
          isValid: true
        )
        WineInfoDetailSingleGraphView(
          value: defaultTaste.body,
          category: "바디",
          graphColor: graphColor,
          isValid: true
        )
        WineInfoDetailSingleGraphView(
          value: defaultTaste.tannin,
          category: "탄닌",
          graphColor: graphColor,
          isValid: true
        )
        WineInfoDetailSingleGraphView(
          value: 0.3,
          category: "알코올",
          graphColor: graphColor,
          isValid: false
        )
        WineInfoDetailSingleGraphView(
          value: 0.3,
          category: "여운",
          graphColor: graphColor,
          isValid: false
        )
        
        Spacer()
      }
    }
  }
}

#Preview {
  NoteDetailGraphTabView(
    noteCardData: NoteDetailDTO(
      noteId: 1,
      noteDate: "2023.10.11",
      wineType: "RED",
      wineName: "test",
      region: "test",
      star: 4,
      color: "red",
      vintage: 10,
      buyAgain: true,
      varietal: "test",
      officialAlcohol: 24,
      price: 5,
      smellKeywordList: ["test"],
      myWineTaste: MyWineTaste(
        sweetness: 3,
        acidity: 4,
        alcohol: 1,
        body: 3,
        tannin: 4,
        finish: 3
      ),
      defaultWineTaste: DefaultWineTaste(
        sweetness: 2.4,
        acidity: 4.3,
        body: 3.3,
        tannin: 1.4
      ),
      tastingNoteImage: [],
      memo: "test"
    )
  )
}
