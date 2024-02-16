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
    ZStack {
      WineyKitAsset.mainBackground.swiftUIColor.ignoresSafeArea()
      
      VStack(spacing: 0) {
        NavigationBar(
          title: "WINEY 뱃지",
          leftIcon: /*WineyAsset.Assets.navigationBackButton.swiftUIImage,*/ // Asset 적용 후 활성화
          Image(systemName: "chevron.backward"),
          leftIconButtonAction: {
            viewStore.send(.tappedBackButton)
          },
          backgroundColor: WineyKitAsset.mainBackground.swiftUIColor
        )
        .padding(.bottom, 10)
        
        
        if !viewStore.errorMsg.isEmpty {
          Text(viewStore.errorMsg)
            .wineyFont(.bodyB1)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .offset(y: -68)
        } else {
          Group {
            BadgeSectionTitle(
              title: .sommelier,
              count: viewStore.sommelierBadgeList.filter({ $0.acquiredAt != nil }).count
            )
            .padding(.bottom, 20)
            
            ScrollView(.horizontal) {
              LazyHGrid(rows: [.init(.flexible())], spacing: 14) {
                ForEach(viewStore.state.sommelierBadgeList, id: \.badgeId) { badge in
                  BadgeBlock(
                    title: badge.name,
                    date: extractDate(badge.acquiredAt) ?? "미취득 뱃지",
                    isRead: badge.isRead ?? true,
                    imgUrl: badge.imgUrl
                  )
                  .onTapGesture {
                    viewStore.send(.tappedBadge(badge))
                  }
                }
              }
              .padding(.horizontal, 1)
              .padding(.bottom, 20)
            }
            .frame(height: 160)
          }
          .padding(
            .horizontal,
            WineyGridRules
              .globalHorizontalPadding
          )
          
          Divider()
            .padding(.vertical, 20)
          
          Group {
            BadgeSectionTitle(
              title: .activity,
              count: viewStore.activityBadgeList.filter({ $0.acquiredAt != nil }).count
            )
            .padding(.bottom, 20)
            
            ScrollView(.horizontal) {
              LazyHGrid(rows: rows, spacing: 14) {
                ForEach(viewStore.state.activityBadgeList, id: \.badgeId) { badge in
                  BadgeBlock(
                    title: badge.name,
                    date: extractDate(badge.acquiredAt) ?? "미취득 뱃지",
                    isRead: badge.isRead ?? true,
                    imgUrl: badge.imgUrl
                  )
                  .onTapGesture {
                    viewStore.send(.tappedBadge(badge))
                  }
                }
              }
              .padding(.horizontal, 1)
              .padding(.bottom, 20)
            }
            .frame(height: 340)
          }
          .padding(
            .horizontal,
            WineyGridRules
              .globalHorizontalPadding
          )
          
          Spacer()
        }
      }
    }
    .bottomSheet(
      backgroundColor: WineyKitAsset.gray950.swiftUIColor,
      isPresented: viewStore.binding(
        get: \.isTappedBadge,
        send: .tappedBadgeClosed
      ),
      headerArea: {
        BadgeBottomSheetHeader(badgeInfo: viewStore.state.clickedBadgeInfo)
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
    .navigationBarHidden(true)
  }
  
  private func extractDate(_ dateString: String?) -> String? {
    if let dateString = dateString {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
      
      if let date = dateFormatter.date(from: dateString) {
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd"
        return outputDateFormatter.string(from: date)
      } else {
        return nil
      }
    } else {
      return nil
    }
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
        .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
      Text(title)
        .foregroundColor(WineyKitAsset.main3.swiftUIColor)
      Spacer()
      Text(count.description)
        .foregroundColor(WineyKitAsset.main3.swiftUIColor)
      Text("개")
        .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
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
      if !isRead {
        HStack {
          Spacer()
          
          Circle()
            .fill(WineyKitAsset.main2.swiftUIColor)
            .frame(width: 8)
        }
        .padding(.bottom, 6)
      } else {
        Spacer()
          .frame(height: 14)
      }
      
      ZStack(alignment: .center) {
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
          .foregroundStyle(WineyKitAsset.gray950.swiftUIColor)
          .frame(width: 100, height: 100)
        
        // Wine Badge Image
        if let imgUrl = imgUrl {
          AsyncImage(url: URL(string: imgUrl)) { image in
            image.resizable()
          } placeholder: {
            ProgressView()
          }
          .aspectRatio(contentMode: .fit)
          .frame(width: 100, height: 100)
        } else {
          Text("이미지를 불러오지 못했습니다.")
            .wineyFont(.captionM1)
            .padding(.horizontal, 10)
            .frame(width: 100, height: 100)
        }
      }
      .padding(.bottom, 10)
      
      VStack(alignment: .center, spacing: 3) {
        Text(title)
          .wineyFont(.bodyB2)
          .foregroundColor(date == "미취득 뱃지" ? WineyKitAsset.gray600.swiftUIColor : WineyKitAsset.gray50.swiftUIColor)
          .lineLimit(1)
        
        Text(date)
          .wineyFont(.captionM2)
          .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
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
