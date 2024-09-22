//
//  NavigationDragExtension.swift
//  WineyKit
//
//  Created by 정도현 on 2/18/24.
//  Copyright © 2024 Winey. All rights reserved.
//

// MARK: 슬라이드 제스처 뒤로가기 (임시 보류)
import UIKit

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
  override public func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return UserDefaults.standard.bool(forKey: "isPopGestureEnabled") && viewControllers.count > 1
  }
}
