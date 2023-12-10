//
//  HertzFormatStyle.swift
//  GrabShot
//
//  Created by Denis Dmitriev on 07.12.2023.
//

import Foundation

public struct HertzFormatStyle: FormatStyle {
    public func format(_ value: Int) -> String {
        return value.formatted() + " " + String(localized: "Hz", bundle: .module, comment: "FormatStyle")
    }
}

extension FormatStyle where Self == HertzFormatStyle {
  static public var hertz: HertzFormatStyle { .init() }
}
