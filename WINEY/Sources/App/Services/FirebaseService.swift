//
//  FirebaseService.swift
//  WINEY
//
//  Created by 정도현 on 11/5/24.
//

import Foundation
import Dependencies
import FirebaseRemoteConfig

@frozen public enum FirbaseUpdateStrategy: Int {
  case NONE = 0
  case FORCE = 1
  case SOFT = 2
}

@frozen public enum FirebaseRemoteConfigTarget: String {
  case IOS_LATEST_VERSION = "ios_latest_version"
  case IOS_MINIMUM_VERSION = "ios_minimum_version"
  case IOS_UPDATE_CONTENT = "ios_update_content"
  case IOS_UPDATE_STRATEGY = "ios_update_strategy"
  case IOS_LATEST_VERSION_NAME = "ios_latest_version_name"
}

public struct FirebaseService {
  public var checkAppVersion: () async -> FirbaseUpdateStrategy
  public var fetchRemoteConfigData: (_ target: FirebaseRemoteConfigTarget) async -> String?
}

public extension FirebaseService {
  
  static let live = {
    
    let controller = FirebaseController()
    
    return Self(
      checkAppVersion: {
        await controller.checkAppVersion()
      },
      fetchRemoteConfigData: { target in
        await controller.fetchRemoteConfigData(target: target)
      }
    )
  }()
}

final class FirebaseController {
  
  private let remoteConfig: RemoteConfig
  private let settings: RemoteConfigSettings
  
  init() {
    self.remoteConfig = RemoteConfig.remoteConfig()
    self.settings = RemoteConfigSettings()
    self.settings.minimumFetchInterval = 0
    self.remoteConfig.configSettings = settings
  }
  
  func checkAppVersion() async -> FirbaseUpdateStrategy {
    return await withUnsafeContinuation { continuation in
      self.remoteConfig.fetch() { [weak self] (status, error) -> Void in
        guard let self = self else { return }
        
        if status == .success {
          self.remoteConfig.activate() { (changed, error) in
            
            // MARK: Force Update Test
            // continuation.resume(returning: .FORCE)
            
            // TODO: BundleVersionString or BundleVersion 선택
            guard let info = Bundle.main.infoDictionary, let currentVersion = info["CFBundleShortVersionString"] as? String else {
              return continuation.resume(returning: .NONE)
            }
            
            let latestVersion = self.remoteConfig[FirebaseRemoteConfigTarget.IOS_LATEST_VERSION.rawValue].stringValue
            let minimumUpdateVersion = self.remoteConfig[FirebaseRemoteConfigTarget.IOS_MINIMUM_VERSION.rawValue].stringValue
            
            if currentVersion < minimumUpdateVersion {
              continuation.resume(returning: .FORCE)
            } else if currentVersion < latestVersion {
              continuation.resume(returning: .SOFT)
            } else {
              continuation.resume(returning: .NONE)
            }
          }
        } else {
          continuation.resume(returning: .NONE)
          print("Error: \(error?.localizedDescription ?? "No error available.")")
        }
      }
    }
  }
  
  func fetchRemoteConfigData(target: FirebaseRemoteConfigTarget) async -> String? {
    return await withUnsafeContinuation { continuation in
      self.remoteConfig.fetch() { [weak self] (status, error) -> Void in
        guard let self = self else { return }
        
        if status == .success {
          self.remoteConfig.activate() { (changed, error) in
            let content = self.remoteConfig[target.rawValue].stringValue
            continuation.resume(returning: content)
          }
        } else {
          print("Error: \(error?.localizedDescription ?? "No error available.")")
          continuation.resume(returning: nil)
        }
      }
    }
  }
}

extension FirebaseService: DependencyKey {
  public static var liveValue = Self.live
  // public static var previewValue = Self.mock
}

public extension DependencyValues {
  var firebase: FirebaseService {
    get { self[FirebaseService.self] }
    set { self[FirebaseService.self] = newValue }
  }
}

