import ProjectDescription

public enum Const {
  public static let workspaceName = "Winey"
  public static let bundlePrefix = "com.winey"
  public static let iphoneDeploymentTarget = DeploymentTarget.iOS(
    targetVersion: "16.4",
    devices: [.iphone]
  )
}
