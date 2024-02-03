//
//  NaverMapView.swift
//  MapFeature
//
//  Created by 박혜운 on 1/31/24.
//

import NMapsMap
import SwiftUI

public struct NaverMapView: UIViewRepresentable {
  
  public func makeCoordinator() -> NaverMapCoordinator {
    NaverMapCoordinator.shared
  }
  
  public func makeUIView(context: Context) -> NMFNaverMapView {
    // SwiftUI -> UIKit
    context.coordinator.getNaverMapView()
  }
  
  public func updateUIView( // SwiftUI -> UIKit
    _ uiView: NMFNaverMapView,
    context: Context
  ) { }
}
