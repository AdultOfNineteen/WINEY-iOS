//
//  ShopBottomSheet.swift
//  Winey
//
//  Created by 박혜운 on 2/2/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import SwiftUI
import WineyKit

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

// MARK: - 수정 사항
// prgress 상태에 따라 높이 조절 뷰에서 해 주고 싶은데, 추후 수정, 현재 Map Reducer가 조절 중
// 아래 메서드는 17.0 이상부터 가능
// .onChange(of: presentProgress) {
//   height = presentProgress ? .close : .medium
// }

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
  @State private var isOnAppear: Bool = false
  //  @State private var previousPresentProgress: Bool?
  
  @GestureState private var translation: CGFloat = 0
  //  @State private var coverOpacity: CGFloat = 1
  private let defaultBackGroundColor = Color.wineyGray950
  
  private let limitDragGap: CGFloat = 120
  private var dragGesture: some Gesture {
    DragGesture()
      .updating(self.$translation) { value, state, _ in
        guard abs(value.translation.width) < limitDragGap else { return }
        state = value.translation.height
      }
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
      }
      .frame(height: 30) // 25
      
      RoundedRectangle(cornerRadius: 6)
        .fill(.wineyGray800)
        .frame(width: 66, height: 5)
    }
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .top) {
        VStack(spacing: 0) {
          self.indicator
            .cornerRadius(12, corners: .topLeft)
            .cornerRadius(12, corners: .topRight)
            .offset(y: 5)
          NavigationStack {
            ZStack(alignment: .top) {
              defaultBackGroundColor
                .edgesIgnoringSafeArea(.bottom)
              if presentProgress {
                VStack {
                  progressView
                    .padding(.top, 35)
                  Spacer()
                }
              } else {
                self.content()
                //                  .animation(.none)
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
      //      .offset(y: max(30, 0))
      .highPriorityGesture(
        presentProgress ? nil : dragGesture
      )
    }
  }
  
  var progressView: some View {
    HStack(spacing: 10) {
      Group {
        Circle()
          .fill(.wineyGray800)
          .padding(.top, 6)
        Circle()
          .fill(.wineyMain1)
          .padding(.bottom, 6)
        Circle()
          .fill(.wineyMain3)
          .padding(.top, 6)
      }
      .frame(width: 13, height: 19)
      
    }
  }
}

public enum ShopSheetHeight: Double, Equatable {
  case close = 100 // 120 정도
  case medium = 526
  case large = 660
}
