//
//  AlertyNetwork.swift
//  AlertyNetwork
//
//  Created by Emre Çiftçi on 9.08.2020.
//

import Foundation

public final class AlertyNetwork {

  @Shared public var connectivityService: ConnectivityService
  @Shared public var connectivityUIService: ConnectivityUIService

  public func start() {
    connectivityService.start()
    connectivityUIService.start()
  }
}
