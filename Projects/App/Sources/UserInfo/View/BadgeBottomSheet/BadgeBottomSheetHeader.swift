//
//  BadgeBottomSheetHeader.swift
//  MyPageFeature
//
//  Created by 박혜운 on 12/29/23.
//

import SwiftUI
import WineyKit

public struct BadgeBottomSheetHeader: View {
  @State private var appearBlur: Double = 0.0
  
  public let badgeInfo: Badge?
  
  public init(badgeInfo: Badge? = nil) {
    self.badgeInfo = badgeInfo
  }
  
  public var body: some View {
    if let badgeInfo = badgeInfo {
      if badgeInfo.acquiredAt != nil {
        badgeImage(imgUrl: badgeInfo.imgUrl)
      } else {
        badgeImage(imgUrl: badgeInfo.unActivatedImgUrl)
      }
    } else {
      Text("데이터 로드 오류")
        .wineyFont(.captionM1)
        .padding(.horizontal, 10)
        .frame(height: 112)
    }
  }
}

extension BadgeBottomSheetHeader {
  
  @ViewBuilder
  private func badgeImage(imgUrl: String?) -> some View {
    if let imgUrl = imgUrl {
      AsyncImage(url: URL(string: imgUrl)) { image in
        image.resizable()
      } placeholder: {
        ProgressView()
      }
      .aspectRatio(contentMode: .fit)
      .frame(height: 112)
      .opacity(appearBlur)
      .onAppear {
        withAnimation(.easeInOut(duration: 0.5)) {
          appearBlur = 1.0
        }
      }
    } else {
      Text("이미지 로드 오류")
        .wineyFont(.captionM1)
        .padding(.horizontal, 10)
        .frame(height: 112)
    }
  }
}
