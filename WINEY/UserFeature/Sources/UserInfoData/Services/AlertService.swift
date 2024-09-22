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

public extension AlertService {
  static let live = {
    return Self(
      showAlert: { message in
        let toastView = ToastAlertView(message: message)

        DispatchQueue.main.async {
          if let windowScenes = UIApplication.shared.connectedScenes.first,
          let windowScene = windowScenes as? UIWindowScene {
            AlertToastManager.shared.showToast(message: message, in: windowScene)
          }
        }
      }
    )
  }()
}

extension AlertService: DependencyKey {
  public static var liveValue = Self.live
}

public extension DependencyValues {
  var alert: AlertService {
    get { self[AlertService.self] }
    set { self[AlertService.self] = newValue }
  }
}

class AlertToastManager {
  private weak var toastHostingController: UIHostingController<ToastAlertView>?
  
  static let shared = AlertToastManager()
  private init() {}
  
  func showToast(message: String, in windowScene: UIWindowScene) {
    DispatchQueue.main.async {
      if let existingToast = self.toastHostingController {
        // 이미 토스트 뷰가 표시중인 경우, 뷰만 교체
        existingToast.rootView = ToastAlertView(message: message)
        existingToast.view.setNeedsLayout()
      } else {
        
        // 새 토스트 뷰를 생성 / 표시
        let toastView = ToastAlertView(message: message)
        let hostingController = UIHostingController(rootView: toastView)
        if let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
          hostingController.view.frame = CGRect(
            x: 20, 
            y: window.safeAreaInsets.top + 520,
            width: window.frame.width - 40, 
            height: 60
          )
          hostingController.view.backgroundColor = .clear
          window.addSubview(hostingController.view)
          self.toastHostingController = hostingController
          
          // 지정된 시간 후에 토스트 메시지 뷰 제거
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            hostingController.view.removeFromSuperview()
            self.toastHostingController = nil
          }
        }
      }
    }
  }
}
