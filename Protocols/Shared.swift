//
//  Shared.swift
//  AlertyNetwork
//
//  Created by Emre Çiftçi on 9.08.2020.
//

import Foundation

@propertyWrapper
public struct Shared<T: Shareable> {

  public var wrappedValue: T

  public init() {
    wrappedValue = T.shared
  }
}
