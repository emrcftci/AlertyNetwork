//
//  ConnectionTrackable.swift
//  AlertyNetwork
//
//  Created by Emre Çiftçi on 9.08.2020.
//

public protocol ConnectionTrackable {

  func track(with delegate: TrackableDelegate)
  func start(queue: DispatchQueue)
  func stop()

  var connectivity: ConnectivityService.Status { get }
  var interface: ConnectivityService.Interface { get }
}

public protocol TrackableDelegate: class {

  func trackerDidConnect(_ tracker: ConnectionTrackable)
  func trackerDidDisconnect(_ tracker: ConnectionTrackable)
}
