//
//  Project+Environment.swift
//  MyPlugin
//
//  Created by 박혜운 on 2023/11/15.
//

import ProjectDescription

public extension Project {
  enum Environment {
    public static let appName = "Winey"
    public static let deploymentTarget: ProjectDescription.DeploymentTarget =
      .iOS(targetVersion: "16.4", devices: [.iphone])
    public static let bundlePrefix = "com.winey."
  }
}
