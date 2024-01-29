//
//  WineyRatingModalView.swift
//  MyPageFeature
//
//  Created by 박혜운 on 12/27/23.
//

import SwiftUI
import WineyKit

struct WineyRatingView: View {
  @Binding private var isPresented: Bool
  
  init(isPresented: Binding<Bool>) {
    self._isPresented = isPresented
  }
  
  var body: some View {
    ZStack {
      WineyKitAsset.mainBackground.swiftUIColor.opacity(0.85).ignoresSafeArea()
      
      VStack(alignment: .center, spacing: 0) {
        HStack {
          Spacer()
          Button(
            action: {
              $isPresented.wrappedValue = false
            },
            label: {
              Image(systemName: "xmark")
                .wineyFont(.title2)
                .foregroundColor(.white)
                .frame(
                  width: 40,
                  height: 40
                )
            }
          )
        }
        .padding(.top, 15)
        .padding(.trailing, 15)
        .padding(.bottom, -16)
        
        Text("WINEY 등급")
          .wineyFont(.title1)
          .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
          .padding(.bottom, 10)
        
        Text("직전 3개월의 테이스팅 노트 작성 개수로\n매월 1일 오전 9시에 업데이트 됩니다.")
          .frame(height: 35)
          .multilineTextAlignment(.center)
          .wineyFont(.captionM2)
          .foregroundColor(WineyKitAsset.gray500.swiftUIColor)
        
        VStack(alignment: .leading, spacing: 18) {
          ForEach(WineyRating.allCases, id: \.self) { item in
            HStack(spacing: 37) {
              Circle()
                .stroke(
                  LinearGradient(
                    colors: [WineyKitAsset.main3.swiftUIColor, WineyKitAsset.main3.swiftUIColor.opacity(0.0)],
                    startPoint: .top,
                    endPoint: .bottom
                  ),
                  lineWidth: 1
                )
                .frame(width: 46, height: 46)
              
              VStack(alignment: .leading, spacing: 10) {
                Text(item.title)
                  .wineyFont(.captionB1)
                  .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
                
                Text(item.description)
                  .wineyFont(.captionM2)
                  .foregroundColor(WineyKitAsset.gray500.swiftUIColor)
              }
            }
          }
        }
        .padding(.vertical, 36)
      }
      .background(WineyKitAsset.gray950.swiftUIColor)
      .cornerRadius(20)
      .frame(width: 301, height: 420)
    }
  }
}

struct WineyRatingView_Previews: PreviewProvider {
  @State static private var isPresented = true

    static var previews: some View {
        // WineyRatingView를 미리보기에 표시하고, isPresented 바인딩을 제공합니다.
      WineyRatingView(isPresented: $isPresented)
    }
}
