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
  public let isInputTextCompleteCondition: (String) -> Bool
  public var onEditingChange: () -> Void = {}
  @Binding public var inputText: String
  @Binding public var rightAccessoryText: String?
    
  public init(
    mainTitle: String,
    rightAccessoryText: Binding<String?> = .constant(nil),
    errorMessage: String,
    inputText: Binding<String>,
    textStyle: @escaping (String) -> String,
    maximumInputCount: Int,
    isInputTextCompleteCondition: @escaping (String) -> Bool,
    onEditingChange: @escaping () -> Void = {}
  ) {
    self.mainTitle = mainTitle
    self._rightAccessoryText = rightAccessoryText
    self.errorMessage = errorMessage
    self._inputText = inputText
    self.textStyle = textStyle
    self.maximumInputCount = maximumInputCount
    self.isInputTextCompleteCondition = isInputTextCompleteCondition
    self.onEditingChange = onEditingChange
  }
    
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      
      Text(
        inputText.isEmpty || isInputTextCompleteCondition(inputText) ?
        mainTitle : errorMessage

      )
      .foregroundColor(
        inputText.isEmpty || isInputTextCompleteCondition(inputText) ?
        .gray : .red
      )
          
      HStack {
        TextField("", text: $inputText)
          .keyboardType(.numberPad)
          .onChange(of: inputText) { newValue in
            inputText =
            textStyle(String(newValue.prefix(maximumInputCount)))
            onEditingChange()
          }
              
        if let accessoryText = rightAccessoryText {
          Text(accessoryText)
        }
      }
          
      Rectangle()
        .frame(height: 1)
        .foregroundColor(
          isInputTextCompleteCondition(inputText) ?
            .white :
            inputText.isEmpty ? .gray : .red
        )
    }
    .padding(.bottom, 10)
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
        errorMessage: "올바른 번호를 입력해주세요",
        inputText: $phoneNumber,
        textStyle: formatPhoneNumber(_:),
        maximumInputCount: 13,
        isInputTextCompleteCondition: { text in
          text.count == 13
        },
        onEditingChange: { }
      )
            
      CustomTextField(
        mainTitle: "인증번호",
        rightAccessoryText: $timerText,
        errorMessage: "인증번호를 입력해주세요",
        inputText: $authCode,
        textStyle: { $0 },
        maximumInputCount: 6,
        isInputTextCompleteCondition: { text in
          text.count == 6
        },
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
