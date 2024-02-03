//
//  Target+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by 박혜운 on 2023/11/15.
//

import Foundation
import ProjectDescription
import EnvPlugin
import ConfigPlugin

let commonScripts: [TargetScript] = [
  .pre(
    script: """
    ROOT_DIR=\(ProcessInfo.processInfo.environment["TUIST_ROOT_DIR"] ?? "")
    
    ${ROOT_DIR}/swiftlint --config ${ROOT_DIR}/.swiftlint.yml
    
    """,
    name: "SwiftLint",
    basedOnDependencyAnalysis: false
  )
]

extension Target {
  public static func make(
    name: String,
    platform: Platform = .iOS,
    product: Product,
    bundleId: String,
    deploymentTarget: DeploymentTarget = Project.Environment.deploymentTarget,
    infoPlist: InfoPlist? = .default,
    sources: SourceFilesList,
    resources: ResourceFileElements? = nil,
    dependencies: [TargetDependency] = [],
    settings: Settings? = nil,
//      .settings(configurations: XCConfig.module),
    scripts: [TargetScript] = [],
    useSwiftLint: Bool = true
  ) -> Target {
    return Target(
      name: name,
      platform: platform,
      product: product,
      bundleId: bundleId,
      deploymentTarget: deploymentTarget,
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      entitlements: "../../Tuist/Winey.entitlements",
      scripts: useSwiftLint ? commonScripts + scripts : scripts,
      dependencies: dependencies,
      settings: settings
    )
  }
}

// MARK: Target + Template

public struct TargetFactory {
  var name: String
  var platform: Platform
  var product: Product
  var productName: String?
  var bundleId: String?
  var deploymentTarget: DeploymentTarget?
  var infoPlist: InfoPlist?
  var sources: SourceFilesList?
  var resources: ResourceFileElements?
  var copyFiles: [CopyFilesAction]?
  var headers: Headers?
  var entitlements: Entitlements?
  var scripts: [TargetScript]
  var dependencies: [TargetDependency]
  var settings: Settings?
  var coreDataModels: [CoreDataModel]
  var environment: [String: String]
  var launchArguments: [LaunchArgument]
  var additionalFiles: [FileElement]
  
  public init(
    name: String = "",
    platform: Platform = .iOS,
    product: Product = .framework,
    productName: String? = nil,
    bundleId: String? = nil,
    deploymentTarget: DeploymentTarget? = nil,
    infoPlist: InfoPlist? = InfoPlist.basicWiney(),
    sources: SourceFilesList? = .sources,
    resources: ResourceFileElements? = nil,
    copyFiles: [CopyFilesAction]? = nil,
    headers: Headers? = nil,
    entitlements: Entitlements? = nil,
    scripts: [TargetScript] = [],
    dependencies: [TargetDependency] = [],
    settings: Settings? = nil,
    coreDataModels: [CoreDataModel] = [],
    environment: [String : String] = [:],
    launchArguments: [LaunchArgument] = [],
    additionalFiles: [FileElement] = []) {
      self.name = name
      self.platform = platform
      self.product = product
      self.productName = productName
      self.deploymentTarget = Project.Environment.deploymentTarget
      self.bundleId = bundleId
      self.infoPlist = infoPlist
      self.sources = sources
      self.resources = resources
      self.copyFiles = copyFiles
      self.headers = headers
      self.entitlements = entitlements
      self.scripts = scripts + commonScripts
      self.dependencies = dependencies
      self.settings = settings
      self.coreDataModels = coreDataModels
      self.environment = environment
      self.launchArguments = launchArguments
      self.additionalFiles = additionalFiles
    }
}

public extension Target {
  private static func make(factory: TargetFactory) -> Self {
    return .init(
      name: factory.name,
      platform: factory.platform,
      product: factory.product,
      productName: factory.productName,
      bundleId: factory.bundleId ?? Project.Environment.bundlePrefix + "\(factory.name.lowercased())",
      deploymentTarget: factory.deploymentTarget,
      infoPlist: factory.infoPlist,
      sources: factory.sources,
      resources: factory.resources,
      copyFiles: factory.copyFiles,
      headers: factory.headers,
      entitlements: factory.entitlements,
      scripts: factory.scripts,
      dependencies: factory.dependencies,
      settings: factory.settings,
      coreDataModels: factory.coreDataModels,
      environment: factory.environment,
      launchArguments: factory.launchArguments,
      additionalFiles: factory.additionalFiles
    )
  }
}


// MARK: Target + Feature

public extension Target {
  static func feature(factory: TargetFactory) -> Self {
    var newFactory = factory
    newFactory.name = ModulePath.Feature.name
    
    return make(factory: newFactory)
  }
  
  static func feature(implements module: ModulePath.Feature, factory: TargetFactory) -> Self {
    var newFactory = factory
    newFactory.name = module.rawValue + ModulePath.Feature.name
    
    return make(factory: newFactory)
  }
  
  static func feature(interface module: ModulePath.Feature, factory: TargetFactory) -> Self {
    var newFactory = factory
    newFactory.name = module.rawValue + ModulePath.Feature.name + "Interface"
    newFactory.sources = .interface
    
    return make(factory: newFactory)
  }
  
  static func feature(demo module: ModulePath.Feature, factory: TargetFactory) -> Self {
    var newFactory = factory
    newFactory.name = module.rawValue + "Demo"
    newFactory.sources = .demoSources
    newFactory.product = .app
    
    return make(factory: newFactory)
  }
}

// MARK: - Target + Domain

public extension Target {
  static func domain(implements module: ModulePath.Domain, factory: TargetFactory) -> Self {
    var newFactory = factory
    newFactory.name = module.rawValue + ModulePath.Domain.name
    // newFactory.product = .staticLibrary
    newFactory.sources = ["\(module.rawValue+ModulePath.Domain.name)/**"]
    
    return make(factory: newFactory)
  }
}
