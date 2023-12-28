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
  private let store: StoreOf<UserBadge>
  @ObservedObject var viewStore: ViewStoreOf<UserBadge>
  let rows: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0), count: 2)
  
  public init(store: StoreOf<UserBadge>) {
    self.store = store
    self.viewStore = ViewStore(
      self.store,
      observe: { $0 }
    )
  }
  
  public var body: some View {
    GeometryReader { _ in
      VStack(spacing: 0) {
        NavigationBar(
          title: "WINYE 뱃지",
          leftIcon: /*WineyAsset.Assets.navigationBackButton.swiftUIImage,*/ // Asset 적용 후 활성화
          Image(systemName: "chevron.backward"),
          leftIconButtonAction: {
            viewStore.send(.tappedBackButton)
          },
          backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
        )
        .padding(.bottom, 10)
        
        Group {
          BadgeSectionTitle(title: .sommelier, count: "0")
            .padding(.bottom, 20)
          
          ScrollView(.horizontal) {
            LazyHGrid(rows: [.init(.flexible())], spacing: 14) {
              ForEach(viewStore.state.sommelierBadgeList) { badge in
                BadgeBlock(
                  title: badge.title,
                  date: badge.date
                )
                .onTapGesture {
                  viewStore.send(.tappedBadge(badge))
                }
              }
            }
            .frame(height: 160)
            .padding(.bottom, 20)
          }
        }
        .padding(
          .horizontal,
          WineyGridRules
            .globalHorizontalPadding
        )
        
        Divider()
          .padding(.bottom, 20)
        
        Group {
          BadgeSectionTitle(title: .activity, count: "0")
            .padding(.bottom, 20)
          
          ScrollView(.horizontal) {
            LazyHGrid(rows: rows, spacing: 14) {
              ForEach(viewStore.state.activityBadgeList) { badge in
                BadgeBlock(
                  title: badge.title,
                  date: badge.date
                )
                .onTapGesture {
                  viewStore.send(.tappedBadge(badge))
                }
              }
            }
            .frame(height: 340)
          }
          .padding(.bottom, 10)
        }
        .padding(
          .horizontal,
          WineyGridRules
            .globalHorizontalPadding
        )
      }
    }
    .bottomSheet(
      backgroundColor: WineyKitAsset.gray950.swiftUIColor,
      isPresented: viewStore.binding(
        get: \.isTappedBadge,
        send: .tappedBadgeClosed
      ),
      headerArea: {
        BadgeBottomSheetHeader()
      },
      content: {
        BadgeBottomSheetContent(
          badgeInfo: viewStore.state.clickedBadgeInfo
        )
      },
      bottomArea: {
        BadgeBottomSheetFooter(
          tappedYesOption: {
            viewStore.send(.tappedBadgeClosed)
          }
        )
      }
    )
    .onAppear {
      viewStore.send(._viewWillAppear)
    }
    .background(WineyKitAsset.mainBackground.swiftUIColor)
    .navigationBarHidden(true)
  }
}

struct BadgeSectionTitle: View {
  enum SectionType: String {
    case sommelier = "소믈리에"
    case activity = "활동뱃지"
  }
  
  let title: String
  let count: String
  
  init(title: SectionType, count: String) {
    self.title = title.rawValue
    self.count = count
  }
  
  var body: some View {
    HStack(spacing: 0) {
      Text("WINEY ")
        .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
      Text(title)
        .foregroundColor(WineyKitAsset.main3.swiftUIColor)
      Spacer()
      Text(count)
        .foregroundColor(WineyKitAsset.main3.swiftUIColor)
      Text("개")
        .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
    }
    .wineyFont(.headLine)
  }
}

struct BadgeBlock: View {
  let title: String
  let date: String
  let isNew: Bool
  
  init(
    title: String = "배지 이름",
    date: String = "취득일",
    isNew: Bool = true
  ) {
    self.title = title
    self.date = date
    self.isNew = isNew
  }
  
  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      HStack {
        Spacer()
        Circle()
          .fill(WineyKitAsset.main2.swiftUIColor)
          .frame(width: 8)
      }
      .padding(.bottom, 6)
      
      ZStack(alignment: .center) {
        // Badge 이미지 들어갈 자리
        
        RoundedRectangle(cornerRadius: 4.85)
          .fill(WineyKitAsset.gray950.swiftUIColor)
          .frame(width: 99, height: 99)
          .overlay(
            RoundedRectangle(cornerRadius: 4.85)
              .stroke(
                LinearGradient(
                  gradient: Gradient(
                    colors: [
                      WineyKitAsset.main3.swiftUIColor,
                      WineyKitAsset.main3.swiftUIColor.opacity(0.2)
                    ]
                  ),
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                ),
                lineWidth: 0.69
              )
          )
      }
      .padding(.bottom, 10)
      
      VStack(alignment: .center, spacing: 3) {
        Text(title)
          .wineyFont(.bodyB2)
          .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
        
        Text(date)
          .wineyFont(.captionM2)
          .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
      }
    }
    .frame(width: 100, height: 160)
  }
}

#Preview {
  UserBadgeView(
    store: .init(
      initialState: .init(),
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
  BadgeSectionTitle(title: .sommelier, count: "0")
}
