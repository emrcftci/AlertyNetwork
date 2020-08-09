//
//  ExecutorService.swift
//  AlertyNetwork
//
//  Created by Emre Çiftçi on 9.08.2020.
//

import Foundation

public final class ExecutorService: NSObject {

  private let queue: DispatchQueue
  private var executions: [JobIdentifier: Execution]

  public init(queue: DispatchQueue) {
    self.queue = queue
    self.executions = [JobIdentifier: Execution]()

    super.init()
    self.prepareNotifications()
  }

  private convenience override init() {
    self.init(queue: DispatchQueue(label: "com.benzinlitre.executorservice", qos: .userInitiated))
  }

  // MARK: Public

  public func job(identifier: JobIdentifier) -> Job? {
    return executions[identifier]?.job
  }

  @discardableResult public func add(job: Job) -> JobIdentifier {
    return add(execution: Execution(job: job))
  }

  public func invalidate(jobIdentifier: JobIdentifier) {
    executions.removeValue(forKey: jobIdentifier)?.cancel()
  }

  public func invalidateAll() {
    Array(executions.keys).forEach { identifier in
      invalidate(jobIdentifier: identifier)
    }
  }

  // MARK: Private

  @discardableResult
  private func add(execution: Execution) -> JobIdentifier {
    executions[execution.identifier] = execution

    after(on: queue, seconds: execution.job.remainingSeconds) {
      [weak self, weak execution] in

      if let execution = execution, execution.work.isCancelled == false {
        self?.execute(execution)
      }
    }
    return execution.identifier
  }

  private func execute(_ execution: Execution) {
    // Note: This code can run on a background queue.
    execution.work.perform()
    safeSync {
      self.invalidate(jobIdentifier: execution.identifier)

      if let newExecution = execution.repeated() {
        self.add(execution: newExecution)
      }
    }
  }

  deinit {
    invalidateAll()
  }
}

// MARK: - Notifications

private extension ExecutorService {

  func prepareNotifications() {
    addNotifications(
      NotificationCenter.default.observe(name: .applicationWillEnterForeground) {
        [unowned self] notification in
        self.willEnterForegroundNotification(notification)
      },
      NotificationCenter.default.observe(name: .applicationDidEnterBackground) {
        [unowned self] notification in
        self.didEnterBackgroundNotification(notification)
      }
    )
  }

  func willEnterForegroundNotification(_ notification: Notification) {
    for execution in executions.values {
      if let execution = execution.resumed() {
        add(execution: execution)
      }
      else if execution.job.isRepetative {
        execution.job.execute()
        execute(execution)
      }
      else {
        invalidate(jobIdentifier: execution.identifier)
      }
    }
  }

  func didEnterBackgroundNotification(_ notification: Notification) {
    executions.values.forEach { $0.cancel() }
  }
}

// MARK: - Execution

public extension ExecutorService {

  typealias JobIdentifier = UUID

  fileprivate final class Execution {

    public let identifier: JobIdentifier

    public let job: Job
    public let work: DispatchWorkItem

    public convenience init(job: Job) {
      self.init(identifier: UUID(), job: job)
    }

    private init(identifier: JobIdentifier, job: Job) {
      self.identifier = identifier
      self.work = DispatchWorkItem(block: job.execute)
      self.job = job
    }

    public func cancel() {
      work.cancel()
    }

    public func resumed() -> Execution? {
      guard job.allowsExecution else { return nil }
      return Execution(identifier: identifier, job: job)
    }

    public func repeated() -> Execution? {
      guard case .every(let interval) = job.repeatMode else { return nil }

      let runsAt = Date.now.addingTimeInterval(interval)
      return Execution(identifier: identifier, job: job.runningAt(runsAt))
    }
  }
}
