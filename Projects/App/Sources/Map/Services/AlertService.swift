//
//  AlertService.swift
//  Winey
//
//  Created by 박혜운 on 2/2/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Dependencies
import Foundation
import SwiftUI
import WineyKit

public struct AlertService {
  public var showAlert: (
    _ message: String
  ) -> Void
}

extension AlertService {
  static let live = {
    return Self(
      showAlert: { message in
        
        let toastView = ToastAlertView(message: message)
        let hostingController = UIHostingController(rootView: toastView)
        
        if let window = UIApplication.shared.windows
          .first(where: { $0.isKeyWindow }) {

          hostingController.view.frame = CGRect(
            x: 20, y: window.safeAreaInsets.top + 520, // 520 기기 비율에 맞게 수정할 것 🔥
            width: window.frame.width - 40, height: 60
          )
          hostingController.view.backgroundColor = .clear // 배경을 투명하게 설정
          
          // UIWindow에 뷰 추가
          window.addSubview(hostingController.view)
          
          // 지정된 시간 후에 토스트 메시지 뷰 제거
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            hostingController.view.removeFromSuperview()
          }
          
        }
      }
    )
  }()
  
  //  static let mock = Self(…)
  //  static let unimplemented = Self(…)
}

extension AlertService: DependencyKey {
  public static var liveValue = Self.live
}

extension DependencyValues {
  var alert: AlertService {
    get { self[AlertService.self] }
    set { self[AlertService.self] = newValue }
  }
}
