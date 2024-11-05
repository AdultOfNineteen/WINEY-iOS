//
//  ForeceUpdate.swift
//  WINEY
//
//  Created by 정도현 on 11/2/24.
//

import ComposableArchitecture
import Foundation
import UIKit

@Reducer
public struct ForeceUpdate {
  
  @ObservableState
  public struct State: Equatable {
    public var updateTitle: String = ""
    public var updateContents: [String] = []
    
    public var appVersion: String? = nil
  }
  
  public enum Action {
    
    // MARK: - UserAction
    case tappedUpdateButton
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _fetchRemoteConfigData(_ target: FirebaseRemoteConfigTarget)
    case _openAppStore
    
    // MARK: - Inner SetState Action
    case _setUpdateContents(String)
    case _setVersionName(String)
  }
  
  @Dependency(\.firebase) var firebaseService
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._viewWillAppear:
        return .run { send in
          await send(._fetchRemoteConfigData(.IOS_UPDATE_CONTENT))
          await send(._fetchRemoteConfigData(.IOS_LATEST_VERSION_NAME))
        }
        
      case let ._fetchRemoteConfigData(target):
        return .run { send in
          let contents = await firebaseService.fetchRemoteConfigData(target)
          if let contents = contents {
            switch target {
            case .IOS_UPDATE_CONTENT:
              await send(._setUpdateContents(contents))
            case .IOS_LATEST_VERSION_NAME:
              await send(._setVersionName(contents))
            default:
              return
            }
          } else {
            return
          }
        }
        
      case let ._setUpdateContents(content):
        
        let content = content.replacingOccurrences(of: "\\n", with: "\n")
        let titleSplit = content.components(separatedBy: "\n\n")
        
        // Update Title
        if let title = titleSplit.first {
          state.updateTitle = title
        }
        
        // Update Content
        if titleSplit.count > 1 {
          let contents = titleSplit[1]
          let splitLines = contents.components(separatedBy: "\n")
          
          state.updateContents = splitLines
        }
        
        return .none
        
      case let ._setVersionName(content):
        state.appVersion = content
        return .none
        
      case .tappedUpdateButton:
        return .send(._openAppStore)
        
      case ._openAppStore:
        let appId = Config.getPropertyValue(.appID)
        
        if let url = URL(string: "itms-apps://itunes.apple.com/app/\(appId)"), UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
        
        return .none
      }
    }
  }
}
