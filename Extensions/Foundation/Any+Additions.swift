//
//  Any+Additions.swift
//  AlertyNetwork
//
//  Created by Emre Çiftçi on 9.08.2020.
//

import Foundation

// MARK: - Closure Extensions

public typealias Callback<T> = (_: T) -> Void
public typealias VoidCallback = () -> Void

// MARK: - Array

public extension Array {

  static func empty() -> Array {
    return []
  }
}

// MARK: - Date

public extension Date {

  static var now: Date {
    return Date()
  }
}
