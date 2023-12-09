//
//  CodecType.swift
//  GrabShot
//
//  Created by Denis Dmitriev on 07.12.2023.
//

import Foundation

/// Codec type of stream in video.
public enum CodecType: String, Codable, CustomStringConvertible {
    /// Video stream
    case video
    
    /// Audio stream
    case audio
    
    /// Data stream
    case data
    
    /// Subtitle stream
    case subtitle
    
    /// Name of codec type
    public var description: String {
        self.rawValue.capitalized(with: Locale.current)
    }
}
