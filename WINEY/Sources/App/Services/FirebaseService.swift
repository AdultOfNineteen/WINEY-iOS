//
//  FirebaseService.swift
//  WINEY
//
//  Created by 정도현 on 11/5/24.
//

import Foundation
import Dependencies
import FirebaseRemoteConfig

public enum FirbaseUpdateStrategy: Int {
  case NONE = 0
  case FORCE = 1
  case SOFT = 2
}

public struct FirebaseService {
  public var checkAppVersion: () async -> FirbaseUpdateStrategy
  public var fetchUpdateContent: () async -> String?
}

public extension FirebaseService {
  
  static let live = {
    
    let controller = FirebaseController()
    
    return Self(
      checkAppVersion: {
        await controller.checkAppVersion()
      },
      fetchUpdateContent: {
        await controller.fetchUpdateContent()
      }
    )
  }()
}

final class FirebaseController {
  
  private let IOS_LATEST_VERSION = "ios_latest_version"
  private let IOS_MINIMUM_VERSION = "ios_minimum_version"
  private let IOS_UPDATE_CONTENT = "ios_update_content"
  private let IOS_UPDATE_STRATEGY = "ios_update_strategy"
  
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
            
            // BundleVersionString or BundleVersion 선택
            guard let info = Bundle.main.infoDictionary, let currentVersion = info["CFBundleShortVersionString"] as? String else {
              return continuation.resume(returning: .NONE)
            }
            
            let latestVersion = self.remoteConfig[self.IOS_LATEST_VERSION].stringValue
            let minimumUpdateVersion = self.remoteConfig[self.IOS_MINIMUM_VERSION].stringValue
            
            print(currentVersion, "!!!!!!!!!!!!!!!!!!!!!!!")
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
  
  func fetchUpdateContent() async -> String? {
    return await withUnsafeContinuation { continuation in
      self.remoteConfig.fetch() { [weak self] (status, error) -> Void in
        guard let self = self else { return }
        
        if status == .success {
          self.remoteConfig.activate() { (changed, error) in
            let content = self.remoteConfig[self.IOS_UPDATE_CONTENT].stringValue
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

