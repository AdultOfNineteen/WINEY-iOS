//
//  UserBadgeView.swift
//  MyPageFeature
//
//  Created by 박혜운 on 12/28/23.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct UserBadgeView: View {
  let store: StoreOf<UserBadge>
  let rows: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        title: "WINEY 뱃지",
        leftIcon: Image(.navigationBack_buttonW),
        leftIconButtonAction: {
          store.send(.tappedBackButton)
        },
        backgroundColor: .wineyMainBackground
      )
      .padding(.bottom, 10)
      
      if !store.errorMsg.isEmpty {
        Text(store.errorMsg)
          .wineyFont(.bodyB1)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .offset(y: -68)
      } else {
        ScrollView {
          LazyVStack(spacing: 20) {
            BadgeSectionTitle(
              title: .sommelier,
              count: store.sommelierBadgeList.filter({ $0.acquiredAt != nil }).count
            )   
            .padding(
              .horizontal,
              WineyGridRules
                .globalHorizontalPadding
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
              LazyHStack(spacing: 14) {
                ForEach(store.sommelierBadgeList, id: \.badgeId) { badge in
                  BadgeBlock(
                    title: badge.name,
                    date: badge.acquiredAt ?? "미취득 뱃지",
                    isRead: badge.isRead ?? true,
                    imgUrl: badge.acquiredAt != nil ? badge.imgUrl : badge.unActivatedImgUrl
                  )
                  .onTapGesture {
                    store.send(.tappedBadge(badge))
                  }
                }
              }
              .padding(.horizontal, 24)
            }
          }
          
          Divider()
            .frame(height: 0.8)
            .overlay(
              .wineyGray900
            )
            .padding(.vertical, 20)
          
          LazyVStack(spacing: 20) {
            BadgeSectionTitle(
              title: .activity,
              count: store.activityBadgeList.filter({ $0.acquiredAt != nil }).count
            )
            .padding(
              .horizontal,
              WineyGridRules
                .globalHorizontalPadding
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
              LazyHGrid(rows: rows, spacing: 14) {
                ForEach(store.activityBadgeList, id: \.badgeId) { badge in
                  BadgeBlock(
                    title: badge.name,
                    date: badge.acquiredAt ?? "미취득 뱃지",
                    isRead: badge.isRead ?? true,
                    imgUrl: badge.acquiredAt != nil ? badge.imgUrl : badge.unActivatedImgUrl
                  )
                  .onTapGesture {
                    store.send(.tappedBadge(badge))
                  }
                }
              }
              .padding(.horizontal, 24)
              .padding(.bottom, 40)
            }
          }
        }
      }
    }
    .background(.wineyMainBackground)
    .bottomSheet(
      backgroundColor: Color.wineyGray950,
      isPresented: .init(
        get: { store.isTappedBadge},
        set: { _ in store.send(.tappedBadgeClosed)}
      ),
      headerArea: {
        BadgeBottomSheetHeader(badgeInfo: store.clickedBadgeInfo)
      },
      content: {
        BadgeBottomSheetContent(
          badgeInfo: store.clickedBadgeInfo
        )
      },
      bottomArea: {
        BadgeBottomSheetFooter(
          tappedYesOption: {
            store.send(.tappedBadgeClosed)
          }
        )
      }
    )
    .onAppear {
      store.send(._viewWillAppear)
    }
    .navigationBarHidden(true)
  }
}

struct BadgeSectionTitle: View {
  enum SectionType: String {
    case sommelier = "소믈리에"
    case activity = "활동뱃지"
  }
  
  let title: String
  let count: Int
  
  init(title: SectionType, count: Int) {
    self.title = title.rawValue
    self.count = count
  }
  
  var body: some View {
    HStack(spacing: 0) {
      Text("WINEY ")
        .foregroundColor(.wineyGray50)
      Text(title)
        .foregroundColor(.wineyMain3)
      Spacer()
      Text(count.description)
        .foregroundColor(.wineyMain3)
      Text("개")
        .foregroundColor(.wineyGray50)
    }
    .wineyFont(.headLine)
  }
}

public struct BadgeBlock: View {
  let title: String
  let date: String
  let isRead: Bool
  let imgUrl: String?
  
  public init(
    title: String = "배지 이름",
    date: String = "취득일",
    isRead: Bool = true,
    imgUrl: String? = nil
  ) {
    self.title = title
    self.date = date
    self.isRead = isRead
    self.imgUrl = imgUrl
  }
  
  public var body: some View {
    VStack(alignment: .center, spacing: 0) {
      HStack {
        Spacer()
        
        Circle()
          .fill(.wineyMain2)
          .frame(width: 8)
      }
      .padding(.bottom, 6)
      .opacity(!isRead ? 1.0 : 0.0)
      
      ZStack(alignment: .center) {
        RoundedRectangle(cornerRadius: 4.85)
          .fill(Color(red: 63/255, green: 63/255, blue: 63/255).opacity(0.4))
          .overlay(
            RoundedRectangle(cornerRadius: 4.85)
              .stroke(
                LinearGradient(
                  gradient: Gradient(
                    colors: [
                      .wineyMain3,
                      .wineyMain3.opacity(0.2)
                    ]
                  ),
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                ),
                lineWidth: 0.69
              )
          )
          .frame(width: 100, height: 100)
        
        // Wine Badge Image
        if let imgUrl = imgUrl {
          CachedImageView(url: imgUrl)
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
        } else {
          Text("이미지를 불러오지 못했습니다.")
            .wineyFont(.captionM1)
            .padding(.horizontal, 10)
            .frame(width: 100, height: 100)
        }
      }
      .frame(width: 100, height: 100)
      .padding(.bottom, 10)
      
      VStack(alignment: .center, spacing: 3) {
        Text(title)
          .wineyFont(.bodyB2)
          .foregroundColor(date == "미취득 뱃지" ? .wineyGray600 : .wineyGray50)
          .lineLimit(1)
        
        Text(date)
          .wineyFont(.captionM2)
          .foregroundColor(.wineyGray700)
          .lineLimit(1)
      }
    }
    .frame(width: 100)
  }
}

#Preview {
  UserBadgeView(
    store: .init(
      initialState: .init(userId: 1),
      reducer: {
        UserBadge()
      }
    )
  )
}

#Preview {
  BadgeBlock()
}

#Preview {
  BadgeSectionTitle(title: .sommelier, count: 0)
}
