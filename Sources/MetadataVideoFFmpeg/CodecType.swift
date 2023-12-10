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
            return NSLocalizedString("Video", comment: "Title")
        case .audio:
            return NSLocalizedString("Audio", comment: "Title")
        case .data:
            return NSLocalizedString("Data", comment: "Title")
        case .subtitle:
            return NSLocalizedString("Subtitle", comment: "Title")
        }
    }
}
