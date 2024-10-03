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
  @Bindable public var store: StoreOf<UserInfo>
  
  @State private var sliderValue: Double = 0.5
  private let questionListTitles = ["1:1 문의", "FAQ"]
  
  public init(store: StoreOf<UserInfo>) { self.store = store }
  
  public var body: some View {
    content
      .navigationBarBackButtonHidden()
      .navigationDestination(
        item: $store.scope(state: \.destination?.userBadge, action: \.destination.userBadge),
        destination: { store in
          UserBadgeView(store: store)
        }
      )
      .navigationDestination(
        item: $store.scope(state: \.destination?.wineyPolicy , action: \.destination.wineyPolicy),
        destination: { store in
          WineyPolicyView(store: store)
        }
      )
  }
  
  private var content: some View {
    ZStack {
      Color.wineyMainBackground.ignoresSafeArea()
      
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
          policySection(viewType: .termsPolicy)
          policySection(viewType: .personalPolicy)
          
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
      
      if store.isPresentedBottomSheet {
        WineyRatingView(
          isPresented: .init(
            get: {
              store.isPresentedBottomSheet
            }, set: { _ in
              store.send(.wineyRatingClosedTapped)
            }),
          gradeListInfo: store.gradeListInfo
        )
      }
    }
    .onAppear {
      store.send(._viewWillAppear)
    }
  }
  
  private var navigationTitleSpace: some View {
    HStack(spacing: 0) {
      Text("마이페이지")
        .wineyFont(.title1)
        .foregroundColor(.wineyGray50)
    }
  }
  
  private var userInfoSpace: some View {
    HStack(spacing: 12) {
      Circle()
        .frame(width: 101)
        .foregroundColor(.wineyGray900)
        .overlay{
          Image(.UserIconW)
            .offset(y: 4)
        }
      
      VStack(spacing: 0) {
        if let nickname = store.userNickname {
          HStack(spacing: 0) {
            Text(nickname)
              .foregroundColor(.wineyMain3)
            Text("님")
              .foregroundColor(.wineyGray50)
            Spacer()
            Button(
              action: { store.send(.userSettingTapped(store.userId)) },
              label: {
                Image(systemName: "chevron.right")
                  .foregroundColor(.white)
              }
            )
          }
          .wineyFont(.title2)
        }
        
        Spacer()
        
        Button(
          action: {
            store.send(.userBadgeButtonTapped(store.userId))
          },
          label: {
            RoundedRectangle(cornerRadius: 24)
              .stroke(.wineyGray800, lineWidth: 1)
              .frame(height: 39)
              .overlay{
                Text("WINEY 뱃지")
                  .wineyFont(.captionB1)
                  .foregroundColor(.wineyGray400)
              }
          }
        )
      }
      .frame(height: 82)
    }
  }
  
  private var degreeGraphSpace: some View {
    VStack(spacing: 7) {
      if let userWineGrade = store.userWineGrade, let gradeListInfo = store.gradeListInfo {
        GeometryReader { lineGeometry in
          ZStack(alignment: .topLeading) {
            Rectangle() // 슬라이더의 바
              .frame(
                width: lineGeometry.size.width,
                height: 1.26
              )
              .foregroundColor(.wineyGray800)
              .padding(.top, 7)
            
            ForEach(gradeListInfo) { grade in
              VStack(alignment: .center, spacing: 7) {
                Circle() // 슬라이더의 원
                  .frame(width: 14, height: 14)
                
                Text(grade.name)
                  .wineyFont(.captionM2)
              }
              .offset(x: CGFloat(grade.minCount)/CGFloat(store.hightestGradeCount) * lineGeometry.size.width - 21)
              .foregroundColor(
                self.sliderValue == CGFloat(grade.minCount)/CGFloat(store.hightestGradeCount) ? .wineyMain2 :
                    .wineyGray800
              )
            }
            
            Circle() // 슬라이더의 원
              .frame(width: 14)
              .foregroundColor(.wineyMain2)
              .offset(
                x: userWineGrade.threeMonthsNoteCount > store.hightestGradeCount ? lineGeometry.size.width - 8 :
                  CGFloat(userWineGrade.threeMonthsNoteCount)/CGFloat(store.hightestGradeCount) * lineGeometry.size.width - 8
              )
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
      VStack(alignment: .leading, spacing: 2) {
        Text(store.userWineGrade?.expectedNextMonthGrade ?? "등급 정보를 불러올 수 없습니다.")
          .wineyFont(.bodyB2)
          .foregroundColor(.wineyGray400)
        
        HStack(spacing: 0) {
          Text("\(store.nextWineGrade)까지 테이스팅 ")
            .foregroundColor(.wineyGray700)
          Text("노트 \(store.needWriteNoteToNextGrade)번")
            .foregroundColor(.wineyMain3)
        }
        .wineyFont(.captionM2)
        .frame(height: 18)
      }
      
      Spacer()
      
      Button(
        action: {
          store.send(.wineyRatingButtonTapped)
        },
        label: {
          ZStack {
            Capsule()
              .fill(.wineyGray900)
              .frame(width: 65, height: 32)
            
            Text("등급기준")
              .wineyFont(.captionB1)
              .foregroundColor(.wineyGray400)
          }
        }
      )
    }
    .padding(.horizontal, 18)
    .frame(height: 93)
    .background {
      RoundedRectangle(cornerRadius: 12)
        .stroke(
          .wineyGray900,
          lineWidth: 1
        )
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(.wineyGray950)
        )
    }
  }
  
  private func policySection(viewType: WineyPolicyViewType) -> some View {
    HStack {
      Text(viewType.navTitle)
        .wineyFont(.bodyM1)
        .foregroundColor(.wineyGray400)
      Spacer()
      Image(systemName: "chevron.right")
        .foregroundColor(.wineyGray400)
        .wineyFont(.title2)
    }
    .background(.wineyMainBackground)
    .padding(.vertical, 12)
    .onTapGesture {
      store.send(.tappedPolicySection(viewType))
    }
  }
  
  private var questionListSpace: some View {
    ForEach(questionListTitles, id: \.self) { title in
      HStack {
        Text(title)
          .wineyFont(.bodyM1)
          .foregroundColor(.wineyGray400)
        
        Spacer()
        
        Image(systemName: "chevron.right")
          .foregroundColor(.wineyGray400)
          .wineyFont(.title2)
      }
      .background(.wineyMainBackground)
      .padding(.vertical, 12)
      .onTapGesture {
        if title == "FAQ" {
          UIApplication.shared.open( URL(string: "https://holy-wax-3be.notion.site/FAQ-1671bf54033440d2aef23189c4754a45")!)
        } else if title == "1:1 문의" {
          store.send(.tappedEmailSendButton)
        }
      }
    }
  }
  
  private var appVersionSpace: some View {
    HStack {
      Text("앱버전")
      Spacer()
      // TODO: - Config 수정
      Text("v 1.0.5")
    }
    .wineyFont(.captionB1)
    .foregroundColor(.wineyGray800)
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
