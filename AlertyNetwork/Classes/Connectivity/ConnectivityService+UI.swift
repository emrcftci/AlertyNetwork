//
//  ConnectivityUIService.swift
//  AlertyNetwork
//
//  Created by Emre Çiftçi on 9.08.2020.
//

import SwiftMessages
import UIKit

public final class ConnectivityUIService: NSObject, Shareable {

  public static let shared = ConnectivityUIService(service: .shared)

  private let messages = SwiftMessages()
  private let service: ConnectivityService

  public init(service: ConnectivityService) {
    self.service = service
    super.init()
  }

  public func start() {
    removeAllNotifications()

    addNotifications(service.addConnectivityHandler { [unowned self] notification in
      if let service = notification.object as? ConnectivityService {
        self.showNotificationView(status: service.status)
      }
    })
  }

  private func showNotificationView(status: ConnectivityService.Status) {
    messages.hide()

    if let (view, config) = makeNotificationView(status: status) {
      messages.show(config: config, view: view)
    }
  }

  private func makeNotificationView(status: ConnectivityService.Status) -> (MessageView, SwiftMessages.Config)? {
    let view = MessageView.viewFromNib(layout: .statusLine)

    view.bottomLayoutMarginAddition = 4.0
    view.configureTheme(.warning)

    var config = SwiftMessages.Config()
    config.presentationContext = .window(windowLevel: .normal)

    switch status {
    case .online:
      config.interactiveHide = true
      config.duration = .seconds(seconds: 3)

      view.configureNotificationView(status: status)
      view.tapHandler = { [unowned self] _ in self.messages.hide() }

    case .offline:
      config.interactiveHide = false
      config.duration = .forever
      view.configureNotificationView(status: status)

    case .notDetermined:
      return .none
    }
    return (view, config)
  }
}

// MARK: - MessageView

fileprivate extension MessageView {

  func configureNotificationView(status: ConnectivityService.Status) {

      let visual = visualContent(for: status)
      bodyLabel?.text = visual.text
      backgroundColor = visual.backgroundColor
  }

  typealias VisualContent = (text: String, backgroundColor: UIColor)

  func visualContent(for status: ConnectivityService.Status) -> VisualContent {

    switch status {
    case .online:
      return VisualContent(Localizable.shared.online, UIColor.online)

    case .offline:
      return VisualContent(Localizable.shared.offline, UIColor.offline)

    case .notDetermined:
      // There is no chance for this case
      return VisualContent(.empty, .clear)
    }
  }
}
