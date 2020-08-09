//
//  NotificationToken+NSObject.swift
//  AlertyNetwork
//
//  Created by Emre Çiftçi on 9.08.2020.
//

import Foundation

public extension NSObject {

  private struct AssociationKeys {
    public static var notificationTokens = "ws_notificationTokens"
  }

  private func ws_setNotificationTokens(_ tokens: [NotificationToken]) {
    objc_setAssociatedObject(
      self, &AssociationKeys.notificationTokens, tokens, .OBJC_ASSOCIATION_COPY_NONATOMIC
    )
  }

  func removeAllNotifications() {
    ws_setNotificationTokens(.empty())
  }

  func addNotifications(_ tokens: [NotificationToken]) {
    if var notificationTokens =
      objc_getAssociatedObject(self, &AssociationKeys.notificationTokens) as? [NotificationToken]
    {
      notificationTokens.append(contentsOf: tokens)
      ws_setNotificationTokens(notificationTokens)
    }
    else {
      ws_setNotificationTokens(tokens)
    }
  }

  func addNotifications(_ tokens: NotificationToken...) {
    addNotifications(tokens)
  }
}
