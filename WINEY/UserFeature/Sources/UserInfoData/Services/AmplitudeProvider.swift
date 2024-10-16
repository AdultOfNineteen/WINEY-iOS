//
//  AmplitudeProvider.swift
//  Winey
//
//  Created by 정도현 on 7/14/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import AmplitudeSwift
import Foundation

/// Ampltiude Event에 필요한 case를 정의합니다.
public enum AmplitudeEvent: String {
  
  // Home Event
  case HOME_ENTER
  case WINE_DETAIL_CLICK
  case ANALYZE_BUTTON_CLICK
  case TIP_POST_CLICK
  
  // Map event
  case MAP_ENTER
  
  // Note Event
  case NOTE_CREATE_BUTTON_CLICK
  case WINE_SELECT_BUTTON_CLICK
  case ALCOHOL_INPUT_SKIP_CLICK
  case ALCOHOL_INPUT_NEXT_CLICK
  case VINTAGE_PRICE_INPUT_SKIP_CLICK
  case VINTAGE_PRICE_INPUT_NEXT_CLICK
  case COLOR_SCENT_INPUT_NEXT_CLICK
  case COLOR_SCENT_INPUT_BACK_CLICK
  case SCENT_HELP_CLICK
  case TASTE_INPUT_NEXT_CLICK
  case TASTE_INPUT_BACK_CLICK
  case TASTE_HELP_CLICK
  case REVIEW_COMPLETE_CLICK
  case REVIEW_COMPLETE_BACK_CLICK
  
  // MyPage Event
  case MYPAGE_ENTER
  case WINEY_BADGE_CLICK
  case YOUNG_BADGE_CLICK
}

public final class AmplitudeProvider: ObservableObject {
  
  /// AmplitudeProvider의 싱글톤 객체. AmplitudeProvider를 사용하기 전 우선적으로 초기화되어야 합니다.
  public static let shared = AmplitudeProvider()
  
  private var amplitude: Amplitude?
  
  private init() {
    amplitude = nil
  }
  
  /// Amplitude 싱글톤 객체를 초기화 합니다. (Amplitude APIKey 사용)
  public static func initProvider(apiKey: String) {
    AmplitudeProvider.shared.initialize(apiKey: apiKey)
  }
  
  private func initialize(apiKey: String) {
    amplitude = Amplitude(
      configuration: Configuration(
        apiKey: apiKey,
        defaultTracking: .ALL
      )
    )
  }
  
  /// 특정 이벤트를 호출합니다.
  public func track(event: AmplitudeEvent) {
    self.amplitude?.track(eventType: event.rawValue)
  }
}
