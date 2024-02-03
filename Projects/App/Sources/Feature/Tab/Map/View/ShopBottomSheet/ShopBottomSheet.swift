//
//  ShopBottomSheet.swift
//  Winey
//
//  Created by 박혜운 on 2/2/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import SwiftUI
import WineyKit

// MARK: - CoverOpacity 주석처리에 따라 바텀시트 높이에 따라 배경 색 변경 미적용

// NavigationView.backgorund(.clear) 불가로 우선 주석처리, 추후 해결

public extension View {
  func shopBottomSheet<
    Content: View
  >(
    height: Binding<ShopSheetHeight>,
    presentProgress: Binding<Bool>,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    ZStack {
      self
      ZStack(alignment: .top) {
        GeometryReader { proxy in
          ShopBottomSheet(
            content: content,
            height: height,
            presentProgress: presentProgress
          )
          .animation(.customSpring, value: height.wrappedValue)
        }
      }
    }
  }
}

fileprivate
extension Animation {
  static var customSpring: Animation {
    self.spring(response: 0.28, dampingFraction: 0.8, blendDuration: 0.86)
  }
}

fileprivate
struct ShopBottomSheet<Content>: View where Content: View {
  @ViewBuilder var content: () -> Content
  @Binding var height: ShopSheetHeight
  @Binding var presentProgress: Bool
  
  @GestureState private var translation: CGFloat = 0
  @State private var coverOpacity: CGFloat = 1
  private let defaultBackGroundColor = WineyKitAsset.gray950.swiftUIColor
  private let closedBackGroundColor = WineyKitAsset.gray900.swiftUIColor
  
  private let limitDragGap: CGFloat = 120
  private var dragGesture: some Gesture {
    DragGesture()
      .updating(self.$translation) { value, state, _ in
        guard abs(value.translation.width) < limitDragGap else { return }
        state = value.translation.height
      }
    //      .onChanged{ value in
    //        guard abs(value.translation.width) < limitDragGap else { return }
    //        let verticalMovement = value.translation.height
    //        let max: CGFloat = ShopSheetHeight.medium.rawValue - ShopSheetHeight.close.rawValue
    //
    //        if height == .close && verticalMovement < 0 {
    //          let delta = 1 - ((value.translation.height * -1) / max)
    //          coverOpacity = delta > 1 ? 1 : (delta < 0 ? 0 : delta)
    //        } else if height == .medium && verticalMovement > 0 {
    //          let delta = (value.translation.height / max)
    //          coverOpacity = delta > 1 ? 1 : (delta < 0 ? 0 : delta)
    //        }
    //      }
      .onEnded { value in
        let verticalMovement = value.translation.height
        
        if verticalMovement > 0 { // Dragging down
          if height == .large {
            height = .medium
          } else {
            height = .close
          }
        } else { // Dragging up
          if height == .close {
            height = .medium
          } else {
            height = .large
          }
        }
        //        coverOpacity = height != .close ? 0 : 1.0
      }
  }
  
  private var offset: CGFloat {
    switch height {
    case .large:
      return 0
    case .medium:
      return ShopSheetHeight.large.rawValue - ShopSheetHeight.medium.rawValue
    case .close:
      return ShopSheetHeight.large.rawValue - ShopSheetHeight.close.rawValue
    }
  }
  
  private var indicator: some View {
    ZStack {
      ZStack {
        Rectangle()
          .fill(defaultBackGroundColor)
        
        Rectangle()
          .fill(closedBackGroundColor)
          .opacity(coverOpacity)
        //          .opacity(presentProgress ? 0 : coverOpacity)
          .disabled(true)
      }
      .frame(height: 25)
      
      RoundedRectangle(cornerRadius: 6)
        .fill(WineyKitAsset.gray800.swiftUIColor)
        .frame(width: 66, height: 5)
    }
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        VStack(spacing: 0) {
          self.indicator
            .cornerRadius(12, corners: .topLeft)
            .cornerRadius(12, corners: .topRight)
          NavigationStack {
            ZStack {
              defaultBackGroundColor
                .edgesIgnoringSafeArea(.bottom)
              
              closedBackGroundColor
                .edgesIgnoringSafeArea(.bottom)
                .opacity(coverOpacity)
              //                  .opacity(presentProgress ? 0 : coverOpacity)
                .disabled(true)
              
              if presentProgress {
                VStack {
                  progressView
                    .padding(.top, 35)
                  Spacer()
                }
              } else {
                self.content()
              }
            }
          }
        }
      }
      .frame(
        width: geometry.size.width,
        height: ShopSheetHeight.large.rawValue
      )
      .frame(height: geometry.size.height, alignment: .bottom)
      .offset(y: max(self.offset + self.translation, 0))
      .onChange(of: height) {
        coverOpacity = height != .close ? 0 : 1
      }
      .onChange(of: presentProgress) {
        height = presentProgress ? .close : .medium
      }
    }
    .highPriorityGesture(
      presentProgress ? nil : dragGesture
    )
  }
  
  var progressView: some View {
    HStack(spacing: 10) {
      Group {
        Circle()
          .fill(WineyKitAsset.gray800.swiftUIColor)
          .padding(.top, 6)
        Circle()
          .fill(WineyKitAsset.main1.swiftUIColor)
          .padding(.bottom, 6)
        Circle()
          .fill(WineyKitAsset.main3.swiftUIColor)
          .padding(.top, 6)
      }
      .frame(width: 13, height: 19)
      
    }
  }
}

public enum ShopSheetHeight: Double, Equatable {
  case close = 115
  case medium = 526
  case large = 676
}
