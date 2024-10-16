//
//  BottomSheet.swift
//  WineyKit
//
//  Created by 박혜운 on 2023/08/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

public extension View {
  func bottomSheet<
    BackgroundColor: View,
    HeaderArea: View,
    Content: View,
    BottomArea: View
  >(
    backgroundColor: BackgroundColor = Color.black,
    isPresented: Binding<Bool>,
    activeOutsideTouch: Bool = false,
    @ViewBuilder headerArea: () -> HeaderArea,
    @ViewBuilder content: () -> Content,
    @ViewBuilder bottomArea: () -> BottomArea
  ) -> some View {
    ZStack {
      self
      ZStack(alignment: .bottom) {
        if isPresented.wrappedValue {
          Color.wineyMainBackground.opacity(0.85)
            .ignoresSafeArea(.container, edges: .all)
            .zIndex(1)
            .onTapGesture {
              if activeOutsideTouch {
                isPresented.wrappedValue = false
              }
            }
            .transition(.opacity)
          
          BottomSheet(
            backgroundColor: backgroundColor,
            isPresented: isPresented,
            headerArea: headerArea,
            content: content,
            bottomArea: bottomArea
          )
          .zIndex(2)
          .transition(.move(edge: .bottom))
        }
      }
      .ignoresSafeArea()
      .animation(.easeInOut(duration: 0.3), value: isPresented.wrappedValue)
    }
  }
}

public struct BottomSheet<
  BackgroundColor: View,
  HeaderArea: View,
  Content: View,
  BottomArea: View
>: View {
  private var backgroundColor: BackgroundColor
  @Binding private var isPresented: Bool
  private var headerArea: HeaderArea
  private var spacingBottomSafeArea: Bool
  private var content: Content
  private var bottomArea: BottomArea
  private let activeOutsideTouch: Bool
  
  private let keyWindow = UIApplication.shared.connectedScenes
    .compactMap { $0 as? UIWindowScene }
    .flatMap { $0.windows }
    .first { $0.isKeyWindow }
  
  public init(
    backgroundColor: BackgroundColor,
    isPresented: Binding<Bool>,
    spacingBottomSafeArea: Bool = true,
    activeOutsideTouch: Bool = false,
    @ViewBuilder headerArea: () -> HeaderArea,
    @ViewBuilder content: () -> Content,
    @ViewBuilder bottomArea: () -> BottomArea
  ) {
    self.backgroundColor = backgroundColor
    self._isPresented = isPresented
    self.spacingBottomSafeArea = spacingBottomSafeArea
    self.activeOutsideTouch = activeOutsideTouch
    self.headerArea = headerArea()
    self.content = content()
    self.bottomArea = bottomArea()
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      RoundedRectangle(cornerRadius: 6)
        .frame(width: 66, height: 5)
        .foregroundColor(.wineyGray900)
        .padding(.top, 10)
        .padding(.bottom, 20)
      
      headerArea
        .padding(.bottom, 16)
      
      content
      
      Spacer()
      
      bottomArea
        .padding(.bottom, 20)
      
      if self.spacingBottomSafeArea {
        Spacer()
          .frame(height: keyWindow?.safeAreaInsets.bottom)
      }
    }
    .frame(maxHeight: 393)
    .background(backgroundColor)
    .cornerRadius(12, corners: .topLeft)
    .cornerRadius(12, corners: .topRight)
  }
}

private struct RoundCorners: Shape {
  var radius: CGFloat = 20
  var corners: UIRectCorner = [.topLeft, .topRight]
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}
