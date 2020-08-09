//
//  Dispatch+Additions.swift
//  AlertyNetwork
//
//  Created by Emre Çiftçi on 9.08.2020.
//

import Dispatch
import Foundation

public func after(on queue: DispatchQueue = .main, seconds: Double, execute: @escaping VoidCallback) {
  let time: DispatchTime = .now() + seconds
  queue.asyncAfter(deadline: time, execute: execute)
}

@discardableResult
public func safeSync<T>(execute: (() -> T)) -> T {
  if Thread.isMainThread {
    return execute()
  }
  else {
    return DispatchQueue.main.sync(execute: execute)
  }
}
