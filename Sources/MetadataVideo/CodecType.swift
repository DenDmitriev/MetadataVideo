//
//  CodecType.swift
//  GrabShot
//
//  Created by Denis Dmitriev on 07.12.2023.
//

import Foundation

public enum CodecType: String, Codable, CustomStringConvertible {
    case video, audio, data, subtitle
    
    public var description: String {
        self.rawValue.capitalized(with: Locale.current)
    }
}
