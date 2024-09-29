//
//  CustomWheelPickerView.swift
//  
//
//  Created by 정도현 on 9/29/24.
//

import Foundation
import SwiftUI

// MARK: WheelPicker 커스텀 (Selection background 제거)
public struct CustomWheelPickerView<T: Equatable>: View {
  
  private let options: [T]
  private let alignment: Alignment
  
  @Binding var selectedValue: T
  @State private var dragValue: Double = 0
  
  let cellAngles = 30.0
  let text: (T) -> String
  
  public init(
    _ options: [T],
    _ alignment: Alignment,
    _ selectedValue: Binding<T>,
    _ text: @escaping (T) -> String = {"\($0)"}
  ) {
    self.options = options
    self.alignment = alignment
    self._selectedValue = selectedValue
    self.text = text
  }
  
  public var body: some View {
    let selectedIndex = getSelectedIndex()
    
    ZStack {
      ForEach(0..<options.count, id: \.self) { index in
        let data: T = options[index]
        
        CustomWheelPickerCell(
          data: text(data),
          angle: Double(index - selectedIndex) * cellAngles + dragValue,
          alignment: alignment
        )
      }
    }
    .frame(height: 160)
    .gesture(
      DragGesture()
        .onChanged { gesture in
          dragValue = gesture.translation.height
        }
        .onEnded { _ in
          var newIdx = selectedIndex - Int(round(dragValue / cellAngles))
          
          if newIdx < 0 {
            newIdx = 0
          }
          
          if newIdx >= options.count - 1 {
            newIdx = options.count - 1
          }
          
          selectedValue = options[newIdx]
          dragValue = 0
        }
    )
  }
  
  private func getSelectedIndex() -> Int {
    return options.firstIndex(of: selectedValue) ?? 0
  }
}


private struct CustomWheelPickerCell: View {
  
  let data: String
  let angle: Double
  let alignment: Alignment

  init(data: String, angle: Double, alignment: Alignment) {
    self.data = data
    self.angle = angle
    self.alignment = alignment
  }
  
  var body: some View {
    if abs(angle) > 90 {
      EmptyView()
    } else {
      let sinValue = sin(radian(angle))
      let cosValue = cos(radian(angle))
      
      Text(data)
        .frame(width: alignment == . trailing ? 36 : nil, alignment: alignment)
        .wineyFont(.title1)
        .foregroundColor(.white)
        .scaleEffect(y: cosValue)
        .offset(y: sinValue * 60)
        .opacity(abs(angle) < 5 ? 1.0 : cosValue/2)
    }
  }
  
  private func radian(_ number: Double) -> Double {
    return number * .pi / 180
  }
}
