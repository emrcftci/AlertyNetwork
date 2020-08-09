//
//  ExecutorService+Job.swift
//  AlertyNetwork
//
//  Created by Emre Çiftçi on 9.08.2020.
//

import Foundation

public extension ExecutorService {

  struct Job {

    public let repeatMode: Repeat
    public let runsAt: Date
    public let executable: Callback<Job>

    public var remainingSeconds: TimeInterval {
      return runsAt.timeIntervalSinceNow
    }

    public func runningAt(_ runsAt: Date) -> Job {
      return Job(repeatMode: repeatMode, runsAt: runsAt, executable: executable)
    }

    public func execute() {
      executable(self)
    }

    public var allowsExecution: Bool {
      return remainingSeconds >= 0
    }

    public var isRepetative: Bool {
      switch repeatMode {

      case .every:
        return true

      case .never:
        return false
      }
    }

    public enum Repeat {
      case never
      case every(TimeInterval)
    }
  }
}
