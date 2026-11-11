//
//  Greeter.swift
//  __NAME__
//
//  Created on __DATE__.
//

import Foundation

/// A Swift class used from Objective-C (see ViewController.m). It calls back
/// into Objective-C through the bridging header (__NAME__-Bridging-Header.h).
@objc class Greeter: NSObject {

    @objc func greeting(for name: String) -> String {
        return "Hello, \(name)!"
    }

    @objc func tappedMessage(_ count: Int) -> String {
        let formatter = TapFormatter()
        return formatter.message(forCount: count)
    }
}
