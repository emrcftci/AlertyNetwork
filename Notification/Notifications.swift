//
//  Notifications.swift
//  AlertyNetwork
//
//  Created by Emre Çiftçi on 9.08.2020.
//

import UIKit

public struct Notifications {

  public struct Connectivity {
    public static let connectivityChanged = Notification.Name("DidChangeConnectivityNotification")
    public static let connectivityTypeChanged = Notification.Name("DidChangeConnectivityTypeNotification")
    public static let ipv4AddressChanged = Notification.Name("DidChangeIPv4AddressNotification")
  }

  public struct Message {
    public static let messageWillDisplay = Notification.Name("WillDisplayMessageNotification")
    public static let messageClosed = Notification.Name("DidCloseMessageNotification")
  }
}

///
/// Attention: Syntactic sugar happening here.
///
/// This part is totally optional. If you add your notification keys here,
/// they will be treated as variables of type `Notification.Name`, enabling you
/// to do the following:
///
/// NotificationCenter.default.enqueue(.userLoggedIn)
///
/// instead of
///
/// NotificationCenter.default.enqueue(Notifications.Authentication.loggedIn)
///

public extension Notification.Name {

  // UIApplication

  static let applicationDidEnterBackground = UIApplication.didEnterBackgroundNotification
  static let applicationWillEnterForeground = UIApplication.willEnterForegroundNotification

  // Connectivity

  static let connectivityChanged = Notifications.Connectivity.connectivityChanged
  static let connectivityTypeChanged = Notifications.Connectivity.connectivityTypeChanged
  static let ipv4AddressChanged = Notifications.Connectivity.ipv4AddressChanged

  // Message

  static let messageWillDisplay = Notifications.Message.messageWillDisplay
  static let messageClosed = Notifications.Message.messageClosed
}
