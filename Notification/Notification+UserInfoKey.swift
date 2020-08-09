//
//  Notification+UserInfoKey.swift
//  AlertyNetwork
//
//  Created by Emre Çiftçi on 9.08.2020.
//

import Foundation

public extension Notification {

  struct UserInfoKey: ExpressibleByStringLiteral, Hashable {

    private let value: String

    public init(stringLiteral value: String) {
      self.value = value
    }

    public func hash(into hasher: inout Hasher) {
      hasher.combine(value)
    }
  }
}

// Please add more user info keys here when needed.

public extension Notification.UserInfoKey {

  static let deviceToken: Notification.UserInfoKey = "UserInfoKey.DeviceToken"
  static let ipv4Addresses: Notification.UserInfoKey = "UserInfoKey.ipv4Addresses"
  static let messageEvent: Notification.UserInfoKey = "UserInfoKey.MessageEvent"
}

// MARK: - Notification

public extension Notification {

  subscript<T: Any>(key: Notification.UserInfoKey) -> T? {
    return userInfo?[key] as? T
  }
}
