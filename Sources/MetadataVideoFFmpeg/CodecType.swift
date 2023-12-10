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
        string
    }
    
    public var string: String {
        switch self {
        case .video:
            return String(localized: "Video", bundle: .module, comment: "Title")
        case .audio:
            return String(localized: "Audio", bundle: .module, comment: "Title")
        case .data:
            return String(localized: "Data", bundle: .module, comment: "Title")
        case .subtitle:
            return String(localized: "Subtitle", bundle: .module, comment: "Title")
        }
    }
}
