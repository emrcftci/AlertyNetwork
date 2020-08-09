//
//  NWPathMonitor+ConnectionTrackable.swift
//  AlertyNetwork
//
//  Created by Emre Çiftçi on 9.08.2020.
//

import Network

// MARK: - NWPathMonitor + ConnectionTrackable

@available(iOS 12.0, *)
extension NWPathMonitor: ConnectionTrackable {

  public func track(with delegate: TrackableDelegate) {

    pathUpdateHandler = { [weak delegate, unowned self] path in
      switch path.status {

      case .satisfied:
        delegate?.trackerDidConnect(self)

      case .unsatisfied:
        delegate?.trackerDidDisconnect(self)

      case .requiresConnection:
        break

      @unknown default:
        break
      }
    }
  }

  public var connectivity: ConnectivityService.Status {
    switch currentPath.status {
    case .satisfied:
      return .online

    case .requiresConnection, .unsatisfied:
      return .offline

    @unknown default:
      return .offline
    }
  }

  public var interface: ConnectivityService.Interface {
    if currentPath.usesInterfaceType(.wifi) {
      return .wifi
    }
    else if currentPath.usesInterfaceType(.cellular) {
      return .cellular
    }
    else {
      return .unavailable
    }
  }

  public func stop() {
    cancel()
  }
}
