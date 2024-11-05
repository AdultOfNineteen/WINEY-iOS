//
//  ForeceUpdateView.swift
//  WINEY
//
//  Created by 정도현 on 11/2/24.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct ForeceUpdateView: View {
  private let store: StoreOf<ForeceUpdate>
  
  public init(store: StoreOf<ForeceUpdate>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      VStack(spacing: 0) {
        updateTitle()
          .padding(.top, 70)
          .padding(.bottom, 40)
        
        updateContentBox()
        
        Spacer()
        
        updateHelperDescription()
          .padding(.bottom, 30)
        
        WineyConfirmButton(
          title: "업데이트",
          validBy: true,
          action: { store.send(.tappedUpdateButton) }
        )
        .padding(.bottom, WineyGridRules.bottomButtonPadding)
      }
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    }
    .background(
      ZStack {
        Color.wineyMainBackground.ignoresSafeArea()
        
        RadientCircleBackgroundView(backgroundType: .forceUpdate)
      }
    )
  }
}

private extension ForeceUpdateView {
  
  @ViewBuilder
  func updateTitle() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("WINEY")
        .wineyFont(.display2)
        .foregroundStyle(.white)
      
      HStack(spacing: 8) {
        Text("업데이트 안내")
          .wineyFont(.title1)
          .foregroundStyle(.white)
        
        // TODO: REMOTE CONFIG 데이터 활용
        Text("v 0.0.0")
          .wineyFont(.captionM1)
          .padding(.vertical, 3)
          .padding(.horizontal, 10)
          .background(
            Capsule()
              .fill(.wineyMain1)
          )
        
        Spacer()
      }
    }
  }
  
  @ViewBuilder
  func updateContentBox() -> some View {
    
    // TODO: REMOTE CONFIG 데이터 활용
    VStack(alignment: .leading, spacing: 20) {
      Text("더욱 쉽고 편리한\n테이스팅 노트 기록을 경험해보세요!")
        .wineyFont(.bodyB2)
        .foregroundStyle(.white)
      
      HStack {
        VStack(alignment: .leading, spacing: 8) {
          Text("와인 검색 개선")
          Text("도수 입력 시 소수점 지원")
        }
        
        Spacer()
      }
      .wineyFont(.bodyM2)
      .foregroundStyle(.white)
    }
    .padding(.vertical, 20)
    .padding(.horizontal, 15)
    .background(
      shadowBox()
    )
  }
  
  @ViewBuilder
  func shadowBox() -> some View {
    RoundedRectangle(cornerRadius: 8)
      .stroke(
        LinearGradient(
          colors: [
            Color(red: 204/255, green: 185/255, blue: 1).opacity(0.5),
            Color(red: 150/255, green: 113/255, blue: 1).opacity(0.1)
          ],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        ),
        lineWidth: 1
      )
      .foregroundStyle(.ultraThinMaterial)
      .background(Color(red: 63/255, green: 63/255, blue: 63/255).opacity(0.4))
  }
  
  @ViewBuilder
  func updateHelperDescription() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("업데이트가 원활하지 않을 경우 아래와 같이 시도해보세요")
      
      HStack(alignment: .top) {
        Text(" • ")
        Text("앱 삭제 후 재설치")
      }
      
      HStack(alignment: .top) {
        Text(" • ")
        Text("설정 - 애플리케이션 - AppStore - 저장공간 - 데이터 삭제 및 캐시 삭제 - 업데이트 실행")
      }
    }
    .multilineTextAlignment(.leading)
    .wineyFont(.captionM1)
    .foregroundStyle(.wineyGray700)
  }
}

#Preview {
  ForeceUpdateView(
    store: Store(
      initialState: ForeceUpdate.State(),
      reducer: {
        ForeceUpdate()
      }
    )
  )
}
