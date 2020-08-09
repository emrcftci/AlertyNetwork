//
//  NotificationToken.swift
//  AlertyNetwork
//
//  Created by Emre Çiftçi on 9.08.2020.
//

import Foundation

public final class NotificationToken: NSObject {

  public let notificationCenter: NotificationCenter
  public let token: Any

  public init(notificationCenter: NotificationCenter = .default, token: Any) {
    self.notificationCenter = notificationCenter
    self.token = token
  }

  deinit {
    notificationCenter.removeObserver(token)
  }
}
