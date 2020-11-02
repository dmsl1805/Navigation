//
//  Signals.swift
//  DMSLNavigation
//
//  Created by Dmytro Shulzhenko on 02.11.2020.
//

import Foundation

public struct Signals<Source> {
    public let source: Source
    
    public init(_ source: Source) { self.source = source}
}

public protocol SignalsSource { }

public extension SignalsSource {
    var signals: Signals<Self> { Signals(self) }
}
