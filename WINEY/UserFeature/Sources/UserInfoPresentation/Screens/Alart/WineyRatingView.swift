//
//  WineyRatingModalView.swift
//  MyPageFeature
//
//  Created by 박혜운 on 12/27/23.
//

import SwiftUI
import UserInfoData
import WineyKit

struct WineyRatingView: View {
  @Binding private var isPresented: Bool
  
  public var gradeListInfo: [WineGradeInfoDTO]?
  
  init(isPresented: Binding<Bool>, gradeListInfo: [WineGradeInfoDTO]? = nil) {
    self._isPresented = isPresented
    self.gradeListInfo = gradeListInfo
  }
  
  var body: some View {
    ZStack {
      Color(red: 20/255, green: 20/255, blue: 20/255).opacity(0.85).ignoresSafeArea()
      
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
          .foregroundColor(.wineyGray50)
          .padding(.bottom, 10)
        
        Text("직전 3개월의 테이스팅 노트 작성 개수로\n매월 1일 오전 9시에 업데이트 됩니다.")
          .multilineTextAlignment(.center)
          .wineyFont(.captionM2)
          .foregroundColor(.wineyGray500)
        
        VStack(spacing: 28) {
          if let gradeListInfo = gradeListInfo {
            ForEach(gradeListInfo) { grade in
              VStack(spacing: 10) {
                Text(grade.name)
                  .wineyFont(.captionB1)
                  .foregroundColor(.wineyGray50)
                
                HStack(spacing: 0) {
                  Text("테이스팅 노트 \(grade.minCount)")
                  
                  if grade.maxCount <= 1000 {
                    Text("~\(grade.maxCount)개 작성")
                  } else {
                    Text("개 작성")
                  }
                }
                .wineyFont(.captionM2)
                .foregroundColor(.wineyGray500)
              }
            }
          } else {
            Text("데이터 로딩 실패")
              .wineyFont(.bodyB1)
          }
        }
        .padding(.top, 38)
        .padding(.bottom, 42)
      }
      .background(.wineyGray950)
      .cornerRadius(20)
      .frame(width: 301)
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
