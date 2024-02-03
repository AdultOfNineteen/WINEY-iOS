import ProjectDescription

public enum Const {
  public static let workspaceName = "Winey"
  public static let bundlePrefix = "com.winey"
  public static let iphoneDeploymentTarget = DeploymentTarget.iOS(
    targetVersion: "17.0",
    devices: [.iphone]
  )
}
