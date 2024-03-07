//
//  UIPageControl.swift
//  WineyKit
//
//  Created by 정도현 on 3/7/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Foundation
import UIKit

public func setupAppearance() {
  UIPageControl.appearance()
    .currentPageIndicatorTintColor = WineyKitAsset.point1.color
  UIPageControl.appearance()
    .pageIndicatorTintColor = WineyKitAsset.gray900.color
}
