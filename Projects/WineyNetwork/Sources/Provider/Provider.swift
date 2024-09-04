//
//  Provider.swift
//  Core
//
//  Created by 박혜운 on 2023/09/15.
//

import Foundation

fileprivate var isRefreshingTokenFail: Bool = false

public struct Provider<Target: EndPointType> {
  private let session: URLSessionProtocol
  private let responseLogger = NetworkLogger()
  
  public init(
    session: URLSessionProtocol = Session.shared.session
  ) {
    self.session = session
  }
  
  public func request<T: Decodable>(
    _ endPoint: EndPointType,
    type: T.Type
  ) async -> Result<T, Error> {
    return await requestObject(endPoint, type: type)
  }
}

// MARK: Private Request Methods
private extension Provider {
  func requestObject<T: Decodable>(_ endPoint: EndPointType, type: T.Type) async -> Result<T, Error> {
    
    guard let request = endPoint.asURLRequest() else {
      let error = ProviderError(
        code: .failedDecode,
        userInfo: ["endPoint" : endPoint]
      )
      return .failure(error)
    }
    
    let task = try? await session.data(for: request)
    
    guard let (data, response) = task else {
      let error = ProviderError(
        code: .failedRequest,
        userInfo: ["endPoint" : endPoint]
      )
      return .failure(error)
    }
    
    // 임시
//    responseLogger.logResponse(response: response, data: data)
    
    if let httpResponse = response as? HTTPURLResponse,
    httpResponse.statusCode == 401 {
      return await refreshToken(endPoint, type: type)
    }
    
    guard let httpResponse = response as? HTTPURLResponse,
    200..<300 ~= httpResponse.statusCode else {
      let error = ProviderError(
        code: .isNotSuccessful,
        userInfo: ["endPoint" : endPoint],
        task: (data, response)
      )
      return .failure(error)
    }
    
    let targetModel = try? JSONDecoder().decode(ResponseDTO.ExistData<T>.self, from: data)
    
    guard let targetModel = targetModel, let model = targetModel.result else {
      let error = ProviderError(
        code: .failedDecode,
        userInfo: ["endPoint" : endPoint],
        task: (data, response)
      )
      return .failure(error)
    }
    
    return .success(model)
  }
  
  func refreshToken<T: Decodable>(_ endPoint: EndPointType, type: T.Type) async -> Result<T, Error> {
    if isRefreshingTokenFail {
      return .failure(ProviderError(code: .authenticationFailed, userInfo: nil))
    }
    
    isRefreshingTokenFail = true
    
    UserDefaults.standard.removeObject(forKey: "accessToken")
    
    let refreshResult = await Provider<TokenAPI>
      .init()
      .request(
        TokenAPI.refreshToken,
        type: TokenDTO.self
      )

    isRefreshingTokenFail = false
    switch refreshResult {
    case .success(let result):
      UserDefaults.standard.set(result.accessToken, forKey: "accessToken")
      return await requestObject(endPoint, type: type)
    case .failure(let error):
      UserDefaults.standard.removeObject(forKey: "refreshToken")
      UserDefaults.standard.removeObject(forKey: "userID")
      UserDefaults.standard.set(false, forKey: "hasLaunched") // 이걸 NotificationCenter로 구현
      NotificationCenter.default.post(name: .userDidLogin, object: nil, userInfo: ["userDidLogin": false])
      return .failure(error)
    }
  }
}
