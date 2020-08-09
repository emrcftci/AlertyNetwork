//
//  ConnectivityUIService.swift
//  AlertyNetwork
//
//  Created by Emre Çiftçi on 9.08.2020.
//

import SwiftMessages
import UIKit

/// Visual content of the message.
/// - Parameters
///
/// text:  The message of the alert
///
/// backgroundColor:  The background color of the alert
public typealias VisualContent = (text: String, backgroundColor: UIColor)

public final class ConnectivityUIService: NSObject, Shareable {

  public static let shared = ConnectivityUIService(service: .shared)

  private let messages = SwiftMessages()
  private let service: ConnectivityService
  private var config: Config = .empty

  private init(service: ConnectivityService) {
    self.service = service
    super.init()
  }

  public func start(with config: Config) {
    self.config = config

    removeAllNotifications()

    addNotifications(service.addConnectivityHandler { [unowned self] notification in
      if let service = notification.object as? ConnectivityService {
        self.showNotificationView(with: service.status)
      }
    })
  }

  private func showNotificationView(with status: ConnectivityService.Status) {
    messages.hide()

    if let (view, config) = makeNotificationView(status: status) {
      messages.show(config: config, view: view)
    }
  }

  private func makeNotificationView(status: ConnectivityService.Status) -> (MessageView, SwiftMessages.Config)? {
    let view = MessageView.viewFromNib(layout: .statusLine)

    view.bottomLayoutMarginAddition = 4.0
    view.configureTheme(.warning)

    var messageConfig = SwiftMessages.Config()
    messageConfig.presentationContext = .window(windowLevel: .normal)

    switch status {
    case .online:
      messageConfig.interactiveHide = true
      messageConfig.duration = .seconds(seconds: 3)

      view.configureNotificationView(status: status, with: config)
      view.tapHandler = { [unowned self] _ in self.messages.hide() }

    case .offline:
      messageConfig.interactiveHide = false
      messageConfig.duration = .forever
      view.configureNotificationView(status: status, with: config)

    case .notDetermined:
      return .none
    }
    return (view, messageConfig)
  }
}

// MARK: - ConnectivityUIService + Config

public extension ConnectivityUIService {

  struct Config {

    public var onlineText: String
    public var onlineBackgroundColor: UIColor

    public var offlineText: String
    public var offlineBackgroundColor: UIColor

    init(onlineText: String, onlineBackgroundColor: UIColor,
         offlineText: String, offlineBackgroundColor: UIColor) {
      self.onlineText = onlineText
      self.offlineText = offlineText

      self.onlineBackgroundColor = onlineBackgroundColor
      self.offlineBackgroundColor = offlineBackgroundColor
    }

    init() {
      onlineText = ""
      offlineText = ""

      onlineBackgroundColor = .green
      offlineBackgroundColor = .red
    }

    public static let empty = Config()
  }

}

// MARK: - MessageView

fileprivate extension MessageView {

  func configureNotificationView(status: ConnectivityService.Status, with config: ConnectivityUIService.Config) {

    let visual = visualContent(for: status, with: config)
    bodyLabel?.text = visual.text
    backgroundColor = visual.backgroundColor
  }

  func visualContent(for status: ConnectivityService.Status, with config: ConnectivityUIService.Config) -> VisualContent {

    switch status {
    case .online:
      return VisualContent(config.onlineText, config.onlineBackgroundColor)

    case .offline:
      return VisualContent(config.offlineText, config.offlineBackgroundColor)

    case .notDetermined:
      // There is no chance for this case
      return VisualContent("", .clear)
    }
  }
}
