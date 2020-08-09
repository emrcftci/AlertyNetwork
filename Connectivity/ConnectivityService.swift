//
//  ConnectivityService.swift
//  AlertyNetwork
//
//  Created by Emre Çiftçi on 9.08.2020.
//

import Network
import Reachability

public final class ConnectivityService: Shareable {

  public static let shared = ConnectivityService(notifier: .services)

  public enum Status: String {
    case online, offline, notDetermined
  }

  public enum Interface: String {
    case wifi, cellular, unavailable, notDetermined
  }

  public var isConnected: Bool {
    return status == .online
  }

  public var isDisconnected: Bool {
    return status == .offline
  }

  private var _interface: ConnectivityService.Interface = .notDetermined {
    didSet {
      guard oldValue != _interface else { return }
      guard oldValue != .notDetermined else { return }

      notifier.enqueue(name: .connectivityTypeChanged, object: self)
    }
  }

  private(set) public var status: Status = .notDetermined {
    didSet {
      guard oldValue != status else { return }
      guard oldValue != .notDetermined || status != .online else { return }

      notifier.enqueue(name: .connectivityChanged, object: self)
    }
  }

  private lazy var networkTracker: ConnectionTrackable = {
    if #available(iOS 12.0, *) {
      return NWPathMonitor()
    }
    else {
      return try! Reachability(targetQueue: queue)
    }
  }()

  public var interface: ConnectivityService.Interface {
    return networkTracker.interface
  }

  private let executor: ExecutorService
  private let notifier: NotificationCenter
  private let queue: DispatchQueue

  private var fetchedIPv4Addresses: Set<String> {
    didSet {
      if (!fetchedIPv4Addresses.isEmpty) && (fetchedIPv4Addresses != oldValue) {
        notifier.enqueue(name: .ipv4AddressChanged, object: self, userInfo: [.ipv4Addresses: fetchedIPv4Addresses])
      }
    }
  }

  public init(notifier: NotificationCenter) {
    self.notifier = notifier
    self.queue = DispatchQueue(label: "com.benzinlitre.connectivityservice")
    self.executor = ExecutorService(queue: .init(label: "com.benzinlitre.connectivityservice.executor"))
    self.fetchedIPv4Addresses = []
  }

  public func start() {
    networkTracker.start(queue: queue)
    networkTracker.track(with: self)

    executor.add(job: ExecutorService.Job(repeatMode: .every(Constants.ipv4AddressFetchInterval), runsAt: .now) { [unowned self] _ in

        self.ipv4Addresses { [weak self] in
          self?.fetchedIPv4Addresses = $0
        }
    })
  }

  public func ipv4Addresses(_ completion: @escaping Callback<Set<String>>) {
    var addresses = Set<String>()
    var ifAddresses: UnsafeMutablePointer<ifaddrs>?

    guard getifaddrs(&ifAddresses) == 0, let firstAddress = ifAddresses else {
      completion(addresses)
      return
    }
    for ptr in sequence(first: firstAddress, next: { $0.pointee.ifa_next }) {
      let flags = Int32(ptr.pointee.ifa_flags)
      let addr = ptr.pointee.ifa_addr.pointee

      if
        (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) &&
          addr.sa_family == UInt8(AF_INET)
      {
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        if getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname,
                       socklen_t(hostname.count), .none, socklen_t(0), NI_NUMERICHOST) == 0
        {
          addresses.insert(String(cString: hostname))
        }
      }
    }
    freeifaddrs(ifAddresses)
    completion(addresses)
  }

  deinit {
    networkTracker.stop()
  }
}

// MARK: - Notification handling

public extension ConnectivityService {

  func addConnectivityHandler(_ handler: @escaping Callback<Notification>) -> NotificationToken {
    return notifier.observe(name: .connectivityChanged, object: self, using: handler)
  }

  func addConnectivityTypeHandler(_ handler: @escaping Callback<Notification>) -> NotificationToken {
    return notifier.observe(name: .connectivityTypeChanged, object: self, using: handler)
  }

  func addIPv4AddressChangeHandler(_ handler: @escaping Callback<Notification>) -> NotificationToken {
    return notifier.observe(name: .ipv4AddressChanged, object: self, using: handler)
  }
}

// MARK: - TrackableDelegate

extension ConnectivityService: TrackableDelegate {

  public func trackerDidConnect(_ tracker: ConnectionTrackable) {
    safeSync {
      self._interface = tracker.interface
      self.status = .online
    }
  }

  public func trackerDidDisconnect(_ tracker: ConnectionTrackable) {
    safeSync {
      self._interface = tracker.interface
      self.status = .offline
    }
  }
}

// MARK: - Constants

private struct Constants {
  public static let ipv4AddressFetchInterval: TimeInterval = 6.0
}
