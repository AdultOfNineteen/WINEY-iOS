import Foundation

public struct WineyGridRules {
  /// Winey View에 적용하는 일반적인 좌우 간격을 의미합니다
  public static let globalHorizontalPadding: CGFloat = 24.0
  /// 키보드가 올라왔을 때 최하단의 UI가 키보드와 가져야 하는 간격을 의미합니다
  public static let keyboardTopPadding: CGFloat = 20.0
  /// SafeArea 간격을 포함한 최하단 UI 배치 간격입니다. keyboardTopPadding과 같이 20.0을 가집니다 
  public static let bottomButtonPadding: CGFloat = 20.0
  /// SafeArea 간격을 포함하지 않은 최하단 UI 배치 간격입니다.
  public static let ignoreBottomSafeAreaButtonPadding: CGFloat = 54.0
}
