//
//  StreamMetadata.swift
//  GrabShot
//
//  Created by Denis Dmitriev on 07.12.2023.
//

import Foundation

public struct StreamMetadata: Codable, Identifiable, DictionaryKeyValueable {
    public typealias Key = CodingKeys
    
    public let id: UUID = UUID()
    public let index: Int? // 0
    public let codecName: String? // h264
    public let codecLongName: String? // unknown
    public let profile: String? // 100
    public let codecType: CodecType? // video
    public let codecTagString: String? // video
    public let width: Int? // 1920
    public let height: Int? // 1080
    public let colorRange: String? // tv
    public let colorSpace: String? // bt709
    public let fieldOrder: String? // progressive
    public let displayAspectRatio: String? // 16:9
    public let pixelFormat: String? // yuv420p
    public let frameRate: Double? // 2997/125
    public let duration: Duration? // 5.000000
    public let startTime: Duration? // 0.0
    public let bitRate: Int? // 42934
    public let bitsPerRawSample: Int? // 8
    public let numberFrames: String? // 120
    public let sampleRate: Int? // "sample_rate": "48000",
    public let channels: Int? // "channels": 6,
    public let channelLayout: String? // "channel_layout": "5.1(side)",
    public let bitsPerSample: Int? // "bits_per_sample": 0,
    public let timeBase: String? // "time_base": "1/1000"
    public let tags: Tags?
    
    /// Dictionary of all stream keys with values
    ///
    /// The library is created using all the keys of the `CodingKeys` enumeration.
    /// Example:
    ///
    ///     let metadata = try JSONDecoder().decode(MetadataVideo.self, from: data)
    ///     let dictionary = metadata.streams.first?.dictionary
    ///     // [Bit rate: Optional("953 685 B"), Duration: Optional("0:56:22"), Start time: Optional("0:00:00"), File name: Optional("/Users/me/Movies/Video.mkv")]
    ///
    /// > Warning: The values is optional.
    ///
    public var dictionary: [CodingKeys: String?] {
        var dictionary = [CodingKeys: String?]()
        for key in CodingKeys.allCases {
            if let value = value(for: key) {
                dictionary[key] = value
            }
        }
        return dictionary
    }
    
    /// Value by key
    ///
    /// Example:
    ///
    ///     let metadata = try JSONDecoder().decode(MetadataVideo.self, from: data)
    ///     let fileName = metadata.streams.first?.value(for: .fileName) // "Video.mov"
    ///
    /// > Warning: The return value is not localized.
    ///
    /// - Parameter key: `String, CodingKey, CaseIterable, Keyable`.
    ///
    /// - Returns: String Type value by  key.
    public func value(for key: CodingKeys) -> String? {
        switch key {
        case .index:
            return self.index?.formatted()
        case .codecName:
            return self.codecName
        case .codecLongName:
            return self.codecLongName
        case .profile:
            return self.profile
        case .codecType:
            return self.codecType?.rawValue
        case .codecTagString:
            return self.codecTagString
        case .width:
            return self.width?.formatted()
        case .height:
            return self.height?.formatted()
        case .colorRange:
            return self.colorRange
        case .colorSpace:
            return self.colorSpace
        case .displayAspectRatio:
            return self.displayAspectRatio
        case .pixelFormat:
            return self.pixelFormat
        case .frameRate:
            return self.frameRate?.formatted()
        case .tags:
            return nil
        case .duration:
            return self.duration?.formatted(.time(pattern: .hourMinuteSecond))
        case .startTime:
            return self.startTime?.formatted(.time(pattern: .hourMinuteSecond))
        case .bitRate:
            return MetadataVideo.fileSizeFormatted(value: bitRate, unit: .byte, rule: .down)
        case .bitsPerRawSample:
            return MetadataVideo.fileSizeFormatted(value: bitsPerRawSample, unit: .bit, rule: .down)
        case .numberFrames:
            return self.numberFrames
        case .fieldOrder:
            return self.fieldOrder
        case .sampleRate:
            return self.sampleRate?.formatted(.hertz)
        case .channels:
            return self.channels?.formatted()
        case .channelLayout:
            return self.channelLayout
        case .timeBase:
            return self.timeBase
        case .bitsPerSample:
            return MetadataVideo.fileSizeFormatted(value: bitsPerSample, unit: .bit, rule: .down)
        }
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable, Keyable {
        case index = "index"
        case codecName = "codec_name"
        case codecLongName = "codec_long_name"
        case profile = "profile"
        case codecType = "codec_type"
        case codecTagString = "codec_tag_string"
        case width = "width"
        case height = "height"
        case colorRange = "color_range"
        case colorSpace = "color_space"
        case displayAspectRatio = "display_aspect_ratio"
        case pixelFormat = "pix_fmt"
        case fieldOrder = "field_order"
        case frameRate = "r_frame_rate"
        case duration = "duration"
        case startTime = "start_time"
        case bitRate = "bit_rate"
        case bitsPerRawSample = "bits_per_raw_sample"
        case numberFrames = "nb_frames"
        case sampleRate = "sample_rate"
        case channels = "channels"
        case channelLayout = "channel_layout"
        case bitsPerSample = "bits_per_sample"
        case timeBase = "time_base"
        case tags
        
        public var id: String {
            self.rawValue
        }
        
        public var index: Int {
            Self.allCases.firstIndex(of: self) ?? .zero
        }
        
        public var description: String {
            switch self {
            case .index:
                return String(localized: "Index", bundle: .module, comment: "Metadata key")
            case .codecName:
                return String(localized: "Codec name", bundle: .module, comment: "Metadata key")
            case .codecLongName:
                return String(localized: "Codec long name", bundle: .module, comment: "Metadata key")
            case .profile:
                return String(localized: "Profile", bundle: .module, comment: "Metadata key")
            case .codecType:
                return String(localized: "Codec type", bundle: .module, comment: "Metadata key")
            case .width:
                return String(localized: "Width", bundle: .module, comment: "Metadata key")
            case .height:
                return String(localized: "Height", bundle: .module, comment: "Metadata key")
            case .displayAspectRatio:
                return String(localized: "Aspect ratio", bundle: .module, comment: "Metadata key")
            case .pixelFormat:
                return String(localized: "Pixel format", bundle: .module, comment: "Metadata key")
            case .frameRate:
                return String(localized: "Frame rate", bundle: .module, comment: "Metadata key")
            case .tags:
                return String(localized: "Tags", bundle: .module, comment: "Metadata key")
            case .codecTagString:
                return String(localized: "Codec Tag String", bundle: .module, comment: "Metadata key")
            case .colorRange:
                return String(localized: "Color range", bundle: .module, comment: "Metadata key")
            case .colorSpace:
                return String(localized: "Color space", bundle: .module, comment: "Metadata key")
            case .startTime:
                return String(localized: "Start time", bundle: .module, comment: "Metadata key")
            case .duration:
                return String(localized: "Duration", bundle: .module, comment: "Metadata key")
            case .bitRate:
                return String(localized: "Bit rate", bundle: .module, comment: "Metadata key")
            case .bitsPerRawSample:
                return String(localized: "Bits Per Raw Sample", bundle: .module, comment: "Metadata key")
            case .numberFrames:
                return String(localized: "Number of frames", bundle: .module, comment: "Metadata key")
            case .fieldOrder:
                return String(localized: "Field order", bundle: .module, comment: "Metadata key")
            case .sampleRate:
                return String(localized: "Sample rate", bundle: .module, comment: "Metadata key")
            case .channels:
                return String(localized: "Channels", bundle: .module, comment: "Metadata key")
            case .channelLayout:
                return String(localized: "Channel layout", bundle: .module, comment: "Metadata key")
            case .bitsPerSample:
                return String(localized: "Bits per sample", bundle: .module, comment: "Metadata key")
            case .timeBase:
                return String(localized: "Time base", bundle: .module, comment: "Metadata key")
            }
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<StreamMetadata.CodingKeys> = try decoder.container(keyedBy: StreamMetadata.CodingKeys.self)
        self.index = try container.decodeIfPresent(Int.self, forKey: StreamMetadata.CodingKeys.index)
        self.codecName = try container.decodeIfPresent(String.self, forKey: StreamMetadata.CodingKeys.codecName)
        self.codecLongName = try container.decodeIfPresent(String.self, forKey: StreamMetadata.CodingKeys.codecLongName)
        self.profile = try container.decodeIfPresent(String.self, forKey: StreamMetadata.CodingKeys.profile)
        self.codecType = try container.decodeIfPresent(CodecType.self, forKey: StreamMetadata.CodingKeys.codecType)
        self.codecTagString = try container.decodeIfPresent(String.self, forKey: StreamMetadata.CodingKeys.codecTagString)
        self.width = try container.decodeIfPresent(Int.self, forKey: StreamMetadata.CodingKeys.width)
        self.height = try container.decodeIfPresent(Int.self, forKey: StreamMetadata.CodingKeys.height)
        self.colorRange = try container.decodeIfPresent(String.self, forKey: StreamMetadata.CodingKeys.colorRange)
        self.colorSpace = try container.decodeIfPresent(String.self, forKey: StreamMetadata.CodingKeys.colorSpace)
        self.fieldOrder = try container.decodeIfPresent(String.self, forKey: StreamMetadata.CodingKeys.fieldOrder)
        self.displayAspectRatio = try container.decodeIfPresent(String.self, forKey: StreamMetadata.CodingKeys.displayAspectRatio)
        self.pixelFormat = try container.decodeIfPresent(String.self, forKey: StreamMetadata.CodingKeys.pixelFormat)
        let frameRateRaw = try container.decodeIfPresent(String.self, forKey: StreamMetadata.CodingKeys.frameRate)
        if let fraction = frameRateRaw?.split(separator: "/").map({ Double($0) ?? .zero }), let numerator = fraction.first, let denominator = fraction.last, denominator != .zero
        {
            self.frameRate = numerator / denominator
        } else {
            self.frameRate = nil
        }
        self.duration = try MetadataVideo.decodeIfPresentDuration(container: container, key: .duration)
        self.startTime = try MetadataVideo.decodeIfPresentDuration(container: container, key: .startTime)
        self.bitRate = try MetadataVideo.decodeIfPresentInt(container: container, key: .bitRate)
        self.bitsPerRawSample = try MetadataVideo.decodeIfPresentInt(container: container, key: .bitsPerRawSample)
        self.numberFrames = try container.decodeIfPresent(String.self, forKey: StreamMetadata.CodingKeys.numberFrames)
        self.sampleRate = try MetadataVideo.decodeIfPresentInt(container: container, key: .sampleRate)
        self.channels = try container.decodeIfPresent(Int.self, forKey: StreamMetadata.CodingKeys.channels)
        self.channelLayout = try container.decodeIfPresent(String.self, forKey: StreamMetadata.CodingKeys.channelLayout)
        self.bitsPerSample = try container.decodeIfPresent(Int.self, forKey: StreamMetadata.CodingKeys.bitsPerSample)
        self.timeBase = try container.decodeIfPresent(String.self, forKey: StreamMetadata.CodingKeys.timeBase)
        self.tags = try container.decodeIfPresent(StreamMetadata.Tags.self, forKey: StreamMetadata.CodingKeys.tags)
    }
}

extension StreamMetadata {
    public struct Tags: Codable, Identifiable, DictionaryKeyValueable {
        public let id: UUID = UUID()
        public let language: String?
        public let title: String?
        public let duration: String? // 00:47:09.622000000
        public let numberOfFrames: Int? // 67843
        public let numberOfBytes: Int? // 2404223327
        public let creationTime: Date? // "2023-11-29T14:41:04.000000Z"
        public let handlerName: String? // "VideoHandler"
        public let vendorId: String? //
        public let encoder: String? // "H.264"
        public let timecode: String? // "01:00:00:00"
        
        /// Dictionary of all stream tags keys with values
        ///
        /// The library is created using all the keys of the `CodingKeys` enumeration.
        /// Example:
        ///
        ///     let metadata = try JSONDecoder().decode(MetadataVideo.self, from: data)
        ///     let dictionary = metadata.streams.first?.tags
        ///     // [Bit rate: Optional("953 685 B"), Duration: Optional("0:56:22"), Start time: Optional("0:00:00"), File name: Optional("/Users/me/Movies/Video.mkv")]
        ///
        /// > Warning: The values is optional.
        ///
        public var dictionary: [CodingKeys: String?] {
            var dictionary = [CodingKeys: String?]()
            for key in CodingKeys.allCases {
                if let value = value(for: key) {
                    dictionary[key] = value
                }
            }
            return dictionary
        }
        
        /// Value by key
        ///
        /// Example:
        ///
        ///     let metadata = try JSONDecoder().decode(MetadataVideo.self, from: data)
        ///     let fileName = metadata.streams.first?.tags?.value(for: .fileName) // "Video.mov"
        ///
        /// > Warning: The return value is not localized.
        ///
        /// - Parameter key: `String, CodingKey, CaseIterable, Keyable`.
        ///
        /// - Returns: String Type value by  key.
        public func value(for key: CodingKeys) -> String? {
            switch key {
            case .title:
                return title
            case .language:
                return language
            case .duration:
                return duration
            case .numberOfFrames:
                return numberOfFrames?.formatted()
            case .numberOfBytes:
                if let numberOfBytes {
                    let size = FileSize(size: Double(numberOfBytes), unit: .byte)
                    return size.optimal().description
                } else {
                    return nil
                }
            case .creationTime:
                if let creationTime {
                    let stringDate = MetadataVideo.dateFormatter.string(from: creationTime)
                    return stringDate
                } else {
                    return nil
                }
            case .handlerName:
                return self.handlerName
            case .vendorId:
                return self.vendorId
            case .encoder:
                return self.encoder
            case .timecode:
                return self.timecode
            }
        }
        
        public enum CodingKeys: String, CodingKey, CaseIterable, Keyable {
            case language
            case title
            case duration = "DURATION"
            case numberOfFrames = "NUMBER_OF_FRAMES"
            case numberOfBytes = "NUMBER_OF_BYTES"
            case creationTime = "creation_time"
            case handlerName = "handler_name"
            case vendorId = "vendor_id"
            case encoder = "encoder"
            case timecode = "timecode"
            
            public var id: String {
                self.rawValue
            }
            
            public var index: Int {
                Self.allCases.firstIndex(of: self) ?? .zero
            }
            
            public var description: String {
                switch self {
                case .title:
                    return String(localized: "Title", bundle: .module, comment: "Metadata key")
                case .language:
                    return String(localized: "Language", bundle: .module, comment: "Metadata key")
                case .duration:
                    return String(localized: "Duration", bundle: .module, comment: "Metadata key")
                case .numberOfFrames:
                    return String(localized: "Number of frames", bundle: .module, comment: "Metadata key")
                case .numberOfBytes:
                    return String(localized: "Size", bundle: .module, comment: "Metadata key")
                case .creationTime:
                    return String(localized: "Creation time", bundle: .module, comment: "Metadata key")
                case .handlerName:
                    return String(localized: "Handler name", bundle: .module, comment: "Metadata key")
                case .vendorId:
                    return String(localized: "Vendor ID", bundle: .module, comment: "Metadata key")
                case .encoder:
                    return String(localized: "Encoder", bundle: .module, comment: "Metadata key")
                case .timecode:
                    return String(localized: "Timecode", bundle: .module, comment: "Metadata key")
                }
            }
        }
        
        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<StreamMetadata.Tags.CodingKeys> = try decoder.container(keyedBy: StreamMetadata.Tags.CodingKeys.self)
            self.title = try container.decodeIfPresent(String.self, forKey: StreamMetadata.Tags.CodingKeys.title)
            self.language = try container.decodeIfPresent(String.self, forKey: StreamMetadata.Tags.CodingKeys.language)
            self.duration = try container.decodeIfPresent(String.self, forKey: StreamMetadata.Tags.CodingKeys.duration)
            self.numberOfFrames = try MetadataVideo.decodeIfPresentInt(container: container, key: .numberOfFrames)
            self.numberOfBytes = try MetadataVideo.decodeIfPresentInt(container: container, key: .numberOfBytes)
            if let creationTime = try container.decodeIfPresent(String.self, forKey: StreamMetadata.Tags.CodingKeys.creationTime) {
                let formatter = MetadataVideo.dateFormatterDecoder
                self.creationTime = formatter.date(from: creationTime)
            } else {
                self.creationTime = nil
            }
            self.handlerName = try container.decodeIfPresent(String.self, forKey: StreamMetadata.Tags.CodingKeys.handlerName)
            self.vendorId = try container.decodeIfPresent(String.self, forKey: StreamMetadata.Tags.CodingKeys.vendorId)
            self.encoder = try container.decodeIfPresent(String.self, forKey: StreamMetadata.Tags.CodingKeys.encoder)
            self.timecode = try container.decodeIfPresent(String.self, forKey: StreamMetadata.Tags.CodingKeys.timecode)
        }
    }
}
