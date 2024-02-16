//
//  EmailController.swift
//  MyPageFeature
//
//  Created by 정도현 on 2/4/24.
//

import Foundation
import MessageUI

class EmailController: NSObject, MFMailComposeViewControllerDelegate {
  public var emailValidateDevice: Bool = true
  
  public static let shared = EmailController()
  
  private override init() { }
  
  func sendEmail(subject: String, body: String, to: String) {
    if !MFMailComposeViewController.canSendMail() {
      print("해당 기기에서 메일 기능을 제공하지 않습니다.")
      self.emailValidateDevice = false
      return
    }
    
    self.emailValidateDevice = true
    let mailComposer = MFMailComposeViewController()
    mailComposer.mailComposeDelegate = self
    mailComposer.setToRecipients([to])
    mailComposer.setSubject(subject)
    mailComposer.setMessageBody(body, isHTML: false)
    EmailController.getRootViewController()?.present(mailComposer, animated: true, completion: nil)
  }
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    EmailController.getRootViewController()?.dismiss(animated: true, completion: nil)
  }
  
  static func getRootViewController() -> UIViewController? {
    UIApplication.shared.windows.first?.rootViewController
  }
}
