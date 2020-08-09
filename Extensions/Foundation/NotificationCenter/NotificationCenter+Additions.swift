//
//  NotificationCenter+Additions.swift
//  AlertyNetwork
//
//  Created by Emre Çiftçi on 9.08.2020.
//

import Foundation

public extension NotificationCenter {

  static let services = NotificationCenter()

  @discardableResult
  func observe(name: Notification.Name, object: Any? = nil,
               queue: OperationQueue = .main,
               using block: @escaping Callback<Notification>)

    -> NotificationToken
  {
    let token = addObserver(forName: name, object: object, queue: queue, using: block)
    return NotificationToken(notificationCenter: self, token: token)
  }

  func enqueue(name: Notification.Name, object: Any? = nil, userInfo: [Notification.UserInfoKey: Any]? = nil) {
    let queue = NotificationQueue(notificationCenter: self)
    let notification = name.notification(object: object, userInfo: userInfo)

    queue.enqueue(notification, postingStyle: .asap, coalesceMask: .onName, forModes: .none)
  }
}

// MARK: Notification.Name

public extension Notification.Name {

  func notification(object: Any? = nil, userInfo: [Notification.UserInfoKey: Any]? = nil) -> Notification {
    return Notification(name: self, object: object, userInfo: userInfo)
  }
}
