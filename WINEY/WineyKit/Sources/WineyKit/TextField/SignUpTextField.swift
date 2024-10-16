//
//  SignUpTextField.swift
//  WineyKit
//
//  Created by 박혜운 on 2023/08/17.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

public struct CustomTextField: View {
  public let mainTitle: String
  public let errorMessage: String
  public let textStyle: (String) -> String // Formatter로 만들 지 고민 중
  public let maximumInputCount: Int
  public let completeCondition: Bool
  public var onEditingChange: () -> Void = {}
  public let textDeleteButton: Image?
  public let placeholderText: String
  public var clockIndicator: Int?
  public var keyboardType: UIKeyboardType
  
  @Binding public var inputText: String
    
  public init(
    mainTitle: String,
    placeholderText: String,
    errorMessage: String,
    inputText: Binding<String>,
    textStyle: @escaping (String) -> String,
    maximumInputCount: Int,
    clockIndicator: Int? = nil,
    completeCondition: Bool,
    textDeleteButton: Image? = nil,
    keyboardType: UIKeyboardType,
    onEditingChange: @escaping () -> Void = {}
  ) {
    self.mainTitle = mainTitle
    self.placeholderText = placeholderText
    self.errorMessage = errorMessage
    self._inputText = inputText
    self.textStyle = textStyle
    self.maximumInputCount = maximumInputCount
    self.clockIndicator = clockIndicator
    self.textDeleteButton = textDeleteButton
    self.completeCondition = completeCondition
    self.keyboardType = keyboardType
    self.onEditingChange = onEditingChange
  }
    
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      
      Text(
        inputText.isEmpty || completeCondition ?
        mainTitle : errorMessage

      )
      .foregroundColor(
        inputText.isEmpty || completeCondition ?
        .wineyGray600 : .wineyError
      )
      .wineyFont(.bodyB2)
      .padding(.bottom, 13)
          
      HStack {
        TextField(placeholderText, text: $inputText)
          .keyboardType(keyboardType)
          .onChange(of: inputText) { newValue in
            inputText =
            textStyle(String(newValue.prefix(maximumInputCount)))
            onEditingChange()
          }
          .tint(.wineyMain1)
          .foregroundColor(.white)
          .wineyFont(.bodyB1)
              
        if let textDeleteButton = textDeleteButton {
          textDeleteButton
            .onTapGesture {
              self.inputText = ""
            }
        }
        
        if let clock = clockIndicator {
          let hour = clock / 60
          let minute = clock % 60
          
          Text("\(hour.description):\(minute.description.count == 1 ? "0" : "")\(minute.description)")
            .wineyFont(.captionM1)
        }
      }
      .frame(height: 24)
      .padding(.bottom, 9)
          
      Rectangle()
        .frame(height: 1)
        .foregroundColor(
          completeCondition ?
            .white :
            inputText.isEmpty ? .wineyGray600 : .wineyError
        )
    }
  }
}

// MARK: - 사용 예시

struct CustomTextFieldExample: View {
  @State private var phoneNumber: String = ""
  @State private var authCode: String = ""
  @State private var timerText: String? = nil

  var body: some View {
    VStack(spacing: 20) {
      CustomTextField(
        mainTitle: "휴대폰 번호",
        placeholderText: "11자리 입력",
        errorMessage: "올바른 번호를 입력해주세요",
        inputText: $phoneNumber,
        textStyle: formatPhoneNumber(_:),
        maximumInputCount: 13,
        completeCondition: true,
        keyboardType: .numberPad,
        onEditingChange: { }
      )
            
      CustomTextField(
        mainTitle: "인증번호",
        placeholderText: "",
        errorMessage: "인증번호를 입력해주세요",
        inputText: $authCode,
        textStyle: { $0 },
        maximumInputCount: 6,
        completeCondition: false,
        keyboardType: .numberPad,
        onEditingChange: { }
      )
      
      Button("Start Timer") {
        startTimer()
      }
    }
    .padding()
  }

  func formatPhoneNumber(_ number: String) -> String {
    var digits = number.filter { $0.isNumber }
    if digits.count > 3 {
      digits.insert("-", at: digits.index(digits.startIndex, offsetBy: 3))
    }
    if digits.count > 8 {
      digits.insert("-", at: digits.index(digits.startIndex, offsetBy: 8))
    }
    return String(digits)
  }

  func startTimer() {
    var remainingSeconds = 180
    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
      if remainingSeconds > 0 {
        timerText = "\(remainingSeconds / 60):\(String(format: "%02d", remainingSeconds % 60))"
        remainingSeconds -= 1
      } else {
        timer.invalidate()
        timerText = nil
      }
    }
  }
}

struct CustomTextFieldExample_Previews: PreviewProvider {
  static var previews: some View {
    CustomTextFieldExample()
  }
}
