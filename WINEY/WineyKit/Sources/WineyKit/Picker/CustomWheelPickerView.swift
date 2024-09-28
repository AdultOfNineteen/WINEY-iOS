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
  
  @Binding var selectedValue: T
  @State private var dragValue: Double = 0
  
  let cellAngles = 30.0
  let text: (T) -> String
  
  public init(
    _ options: [T],
    _ selectedValue: Binding<T>,
    _ text: @escaping (T) -> String = {"\($0)"}
  ) {
    self.options = options
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
          angle: Double(index - selectedIndex) * cellAngles + dragValue
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

  init(data: String, angle: Double) {
    self.data = data
    self.angle = angle
  }
  
  var body: some View {
    if abs(angle) > 90 {
      EmptyView()
    }
    
    else {
      let sinValue = sin(radian(angle))
      let cosValue = cos(radian(angle))
      
      Text(data)
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
