//
//  UserInfoView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/13.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import Messages
import SwiftUI
import WineyKit

public struct UserInfoView: View {
  private let store: StoreOf<UserInfo>
  @ObservedObject var viewStore: ViewStoreOf<UserInfo>
  @State private var sliderValue: Double = 0.5
  private let infoListTitles = ["서비스 이용약관", "개인정보 처리방침"]
  private let questionListTitles = ["1:1 문의", "FAQ"]
  
  public init(store: StoreOf<UserInfo>) {
    self.store = store
    self.viewStore = ViewStore(
      self.store,
      observe: { $0 }
    )
  }
  
  public var body: some View {
    ZStack {
      WineyKitAsset.mainBackground.swiftUIColor.ignoresSafeArea()
      
      VStack(alignment: .leading, spacing: 0) {
        
        navigationTitleSpace
          .padding(.top, 17)
          .padding(.bottom, 38)
        
        userInfoSpace
          .padding(.bottom, 22)
        
        degreeGraphSpace
          .padding(.horizontal, 20)
          .padding(.bottom, 20)
        
        badgeSpace
          .padding(.bottom, 15)
        
        VStack(spacing: 0) {
          infoListSpace
          
          Divider()
            .background(Color.gray)
            .padding(.top, 21)
            .padding(.bottom, 7)
            .padding(
              .horizontal,
              -WineyGridRules.globalHorizontalPadding
            )
          
          questionListSpace
        }
        .padding(.bottom, 13)
        
        appVersionSpace
        
        Spacer()
      }
      .padding(
        .horizontal,
        WineyGridRules
          .globalHorizontalPadding
      )
      
      if viewStore.state.isPresentedBottomSheet {
        WineyRatingView(
          isPresented: viewStore.binding(
            get: \.isPresentedBottomSheet,
            send: .wineyRatingClosedTapped
          )
        )
      }
    }
    .onAppear {
      viewStore.send(._viewWillAppear)
    }
  }
  
  private var navigationTitleSpace: some View {
    HStack(spacing: 0) {
      Text("마이페이지")
        .wineyFont(.title1)
        .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
    }
  }
  
  private var userInfoSpace: some View {
    HStack(spacing: 12) {
      Circle()
        .frame(width: 101)
        .foregroundColor(WineyKitAsset.gray900.swiftUIColor)
        .overlay{
          Image("UserIcon")
            .offset(y: 4)
        }
      
      VStack(spacing: 0) {
        HStack(spacing: 0) {
          Text("김희연")
            .foregroundColor(WineyKitAsset.main3.swiftUIColor)
          Text("님")
            .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
          Spacer()
          Button(
            action: { viewStore.send(.userSettingTapped(viewStore.userId)) },
            label: {
              Image(systemName: "chevron.right")
                .foregroundColor(.white)
            }
          )
        }
        .wineyFont(.title2)
        
        Spacer()
        
        Button(
          action: {
            viewStore.send(.userBadgeButtonTapped(viewStore.userId))
          },
          label: {
            RoundedRectangle(cornerRadius: 24) //
              .stroke(WineyKitAsset.gray800.swiftUIColor, lineWidth: 1)
              .frame(height: 39)
              .overlay{
                Text("WINEY 뱃지")
                  .wineyFont(.captionB1)
                  .foregroundColor(WineyKitAsset.gray400.swiftUIColor)
              }
          }
        )
      }
      .frame(height: 88)
    }
  }
  
  private var degreeGraphSpace: some View {
    VStack(spacing: 7) {
      if let userWineGrade = viewStore.userWineGrade {
        GeometryReader { lineGeometry in
          ZStack(alignment: .leading) {
            Rectangle() // 슬라이더의 바
              .frame(
                width: lineGeometry.size.width,
                height: 1.26
              )
              .foregroundColor(WineyKitAsset.gray800.swiftUIColor)
            
            Circle() // 슬라이더의 원
              .frame(width: 14)
              .foregroundColor(WineyKitAsset.main2.swiftUIColor)
              .offset(x: CGFloat(userWineGrade.threeMonthsNoteCount)/12 * lineGeometry.size.width - 7)
          }
          .overlay(alignment: .topLeading) {
            ForEach(WineyRating.allCases, id: \.title) { item in
              VStack(alignment: .center, spacing: 7) {
                Circle() // 슬라이더의 원
                  .frame(width: 14, height: 14)
                
                Text(item.title)
                  .wineyFont(.captionM2)
              }
              .offset(x: item.degree * lineGeometry.size.width - 21)
              .foregroundColor(
                self.sliderValue == item.degree ? WineyKitAsset.main2.swiftUIColor :
                  WineyKitAsset.gray800.swiftUIColor
              )
            }
          }
        }
      } else {
        Text("유저 등급 정보를 가져오지 못했습니다.")
          .wineyFont(.bodyB1)
      }
    }
    .frame(height: 39)
  }
  
  private var badgeSpace: some View {
    HStack(spacing: 0) {
      Spacer() // 뱃지 들어갈 공간
      
      VStack(alignment: .leading, spacing: 1) {
        Text("BOTTLE") // 임시
          .wineyFont(.bodyB2)
          .foregroundColor(WineyKitAsset.gray400.swiftUIColor)
        HStack(spacing: 0) {
          Text("OAK까지 테이스팅 ")
            .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
          Text("노트 2번")
            .foregroundColor(WineyKitAsset.main3.swiftUIColor)
        }
        .wineyFont(.captionM2)
      }
      .padding(.trailing, 20)
      
      Button(
        action: {
          viewStore.send(.wineyRatingButtonTapped)
          //          isPresentedRatingView = true
        },
        label: {
          ZStack {
            RoundedRectangle(cornerRadius: 24)
              .fill(WineyKitAsset.gray900.swiftUIColor)
              .frame(width: 65, height: 32)
            
            Text("등급기준")
              .wineyFont(.captionB1)
              .foregroundColor(WineyKitAsset.gray400.swiftUIColor)
          }
        }
      )
    }
    .padding(.horizontal, 18)
    .frame(height: 93)
    .background {
      RoundedRectangle(cornerRadius: 12)
        .stroke(
          WineyKitAsset.gray700.swiftUIColor,
          lineWidth: 1
        )
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(WineyKitAsset.gray950.swiftUIColor)
        )
    }
  }
  
  private var infoListSpace: some View {
    ForEach(infoListTitles, id: \.self) { title in
      HStack {
        Text(title)
          .wineyFont(.bodyM1)
          .foregroundColor(WineyKitAsset.gray400.swiftUIColor)
        Spacer()
        Image(systemName: "chevron.right")
          .foregroundColor(WineyKitAsset.gray400.swiftUIColor)
          .wineyFont(.title2)
      }
      .background(WineyKitAsset.mainBackground.swiftUIColor)
      .padding(.vertical, 12)
      .onTapGesture {
        if title == "서비스 이용약관" {
          viewStore.send(.tappedTermsPolicy)
        } else if title == "개인정보 처리방침" {
          viewStore.send(.tappedPersonalInfoPolicy)
        }
      }
    }
  }
  
  private var questionListSpace: some View {
    ForEach(questionListTitles, id: \.self) { title in
      HStack {
        Text(title)
          .wineyFont(.bodyM1)
          .foregroundColor(WineyKitAsset.gray400.swiftUIColor)
        
        Spacer()
        
        Image(systemName: "chevron.right")
          .foregroundColor(WineyKitAsset.gray400.swiftUIColor)
          .wineyFont(.title2)
      }
      .background(WineyKitAsset.mainBackground.swiftUIColor)
      .padding(.vertical, 12)
      .onTapGesture {
        if title == "FAQ" {
          UIApplication.shared.open( URL(string: "https://holy-wax-3be.notion.site/FAQ-1671bf54033440d2aef23189c4754a45")!)
        } else if title == "1:1 문의" {
          EmailController.shared.sendEmail(subject: "Hello", body: "Hello From ishtiz.com", to: "recipient@example.com")
        }
      }
    }
  }
  
  private var appVersionSpace: some View {
    HStack {
      Text("앱버전")
      Spacer()
      Text("v 0.0.1") // 추후 config 수정
    }
    .wineyFont(.captionB1)
    .foregroundColor(WineyKitAsset.gray800.swiftUIColor)
  }
}

#Preview {
  UserInfoView(
    store: .init(
      initialState: .init(),
      reducer: {
        UserInfo()
      }
    )
  )
}
