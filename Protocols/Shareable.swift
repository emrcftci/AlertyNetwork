//
//  Shareable.swift
//  AlertyNetwork
//
//  Created by Emre Çiftçi on 9.08.2020.
//

import Foundation

public protocol Shareable: class {

  static var shared: Self { get }
}
