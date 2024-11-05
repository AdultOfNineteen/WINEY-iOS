//
//  Config.swift
//  WINEY
//
//  Created by 정도현 on 11/6/24.
//

import Foundation

public enum Config {
  public enum Keys {
    public enum Plist: String {
      case appID = "AppID"
      case amplitudeKey = "AmplitudeAPIKey"
      case baseURL = "BaseURL"
      case kakaoAPIKey = "KakaoAPIKey"
      case fakeUserToken = "FakeUserToken"
      case fakeUserID = "FakeUserID"
    }
  }
  
  private static let infoDictionary: [String: Any] = {
    guard let dict = Bundle.main.infoDictionary else {
      fatalError("plist cannot found.")
    }
    return dict
  }()
}

extension Config {
  public static func getPropertyValue(_ target: Config.Keys.Plist) -> String {
    guard let key = Config.infoDictionary[target.rawValue] as? String else {
      fatalError("\(target.rawValue) is not set in plist for this configuration.")
    }
    
    return key
  }
}
