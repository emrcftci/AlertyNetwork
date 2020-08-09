//
//  Reachability+ConnectionTrackable.swift
//  AlertyNetwork
//
//  Created by Emre Çiftçi on 9.08.2020.
//

import Reachability

// MARK: - Reachability + Trackable

extension Reachability: ConnectionTrackable {

  public func track(with delegate: TrackableDelegate) {
    whenReachable = { [weak delegate, unowned self] _ in
      delegate?.trackerDidConnect(self)
    }

    whenUnreachable = { [weak delegate, unowned self] _ in
      delegate?.trackerDidDisconnect(self)
    }

    switch connectivity {
    case .offline:
      delegate.trackerDidDisconnect(self)
    case .online:
      delegate.trackerDidConnect(self)
    default:
      break
    }
  }

  public var connectivity: ConnectivityService.Status {
    switch connection {
    case .cellular, .wifi:
      return .online
    case .none, .unavailable:
      return .offline
    }
  }

  public var interface: ConnectivityService.Interface {
    switch connection {
    case .cellular:
      return .cellular
    case .none, .unavailable:
      return .unavailable
    case .wifi:
      return .wifi
    }
  }

  public func start(queue: DispatchQueue) {
    stopNotifier()
    try? startNotifier()
  }

  public func stop() {
    stopNotifier()
  }
}
