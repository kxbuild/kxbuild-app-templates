//
//  Greeter.swift
//  __NAME__
//
//  Created on __DATE__.
//

import Foundation

/// Public API of the framework. Mark everything apps should see `public`.
public final class Greeter {

    public init() {}

    public func greeting(for name: String) -> String {
        return "Hello, \(name)! — from __NAME__"
    }
}
