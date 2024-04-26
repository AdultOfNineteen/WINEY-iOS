//
//  TabBarService.swift
//  Winey
//
//  Created by 박혜운 on 3/14/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Combine
import Dependencies
import UIKit

public struct TabBarService {
  public var adaptivePresentationControl: () -> PassthroughSubject<Void, Never>
}

extension TabBarService {
  static let live = Self(
    adaptivePresentationControl: {
      let manager = AdaptivePresentationManager.shared
      return manager.presentationControllerDidDismiss()
    }
  )
}

public class AdaptivePresentationManager: AdaptivePresentationControllerDelegate {
  public static let shared = AdaptivePresentationManager()
  private var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
  private var disappearSignal = PassthroughSubject<Void, Never>()
  
  private init() {
    self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    self.presentationDelegateProxy.delegate = self
  }
  
  public func presentationControllerDidDismiss() -> PassthroughSubject<Void, Never> {
    return disappearSignal
  }
  
  public func adaptPresentationControllerDidDismiss() {
    disappearSignal.send(())
  }
}

public protocol AdaptivePresentationControllerDelegate: AnyObject {
  func adaptPresentationControllerDidDismiss()
  func presentationControllerDidDismiss() -> PassthroughSubject<Void, Never>
}

// Delegate
public final class AdaptivePresentationControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
  
  public weak var delegate: AdaptivePresentationControllerDelegate?
  
  public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    delegate?.adaptPresentationControllerDidDismiss()
  }
}

extension TabBarService: DependencyKey {
  public static var liveValue = TabBarService.live
}

extension DependencyValues {
  var tap: TabBarService {
    get { self[TabBarService.self] }
    set { self[TabBarService.self] = newValue }
  }
}




// 1. 데이터 스트림 발생 위치는 ?
// 2. Delegate 채택 class의 역할은?
// 3. TabBarService의 역할은?
// 4. Reducer의 요청 사항은?



