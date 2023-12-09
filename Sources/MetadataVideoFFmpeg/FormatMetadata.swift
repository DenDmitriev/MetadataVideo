//
//  FormatMetadata.swift
//  GrabShot
//
//  Created by Denis Dmitriev on 07.12.2023.
//

import Foundation

public struct FormatMetadata: Codable, Identifiable, DictionaryKeyValueable {
    public let id: UUID = UUID()
    public let fileName: String?
    public let numberStreams: Int?
    public let formatName: String?
    public let formatLongName: String?
    public let startTime: Duration?
    public let duration: Duration?
    public let size: Int?
    public let bitRate: Int?
    public let probeScore: Int?
    public let tags: Tags?
    
    /// Dictionary of all keys with values
    ///
    /// The library is created using all the keys of the `CodingKeys` enumeration.
    /// Example:
    ///
    ///     let metadata = try JSONDecoder().decode(MetadataVideo.self, from: data)
    ///     let dictionary = metadata.format.dictionary
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
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<FormatMetadata.CodingKeys> = try decoder.container(keyedBy: FormatMetadata.CodingKeys.self)
        self.fileName = try container.decodeIfPresent(String.self, forKey: FormatMetadata.CodingKeys.fileName)
        self.numberStreams = try container.decodeIfPresent(Int.self, forKey: FormatMetadata.CodingKeys.numberStreams)
        self.formatName = try container.decodeIfPresent(String.self, forKey: FormatMetadata.CodingKeys.formatName)
        self.startTime = try MetadataVideo.decodeIfPresentDuration(container: container, key: .startTime)
        self.duration = try MetadataVideo.decodeIfPresentDuration(container: container, key: .duration)
        self.size = try MetadataVideo.decodeIfPresentInt(container: container, key: .size)
        self.bitRate = try MetadataVideo.decodeIfPresentInt(container: container, key: .bitRate)
        self.probeScore = try container.decodeIfPresent(Int.self, forKey: FormatMetadata.CodingKeys.probeScore)
        self.formatLongName = try container.decodeIfPresent(String.self, forKey: FormatMetadata.CodingKeys.formatLongName)
        self.tags = try container.decodeIfPresent(FormatMetadata.Tags.self, forKey: FormatMetadata.CodingKeys.tags)
    }
    
    /// Value by key
    ///
    /// Example:
    ///
    ///     let metadata = try JSONDecoder().decode(MetadataVideo.self, from: data)
    ///     let fileName = metadata.format.value(for: .fileName) // "Video.mov"
    ///
    /// > Warning: The return value is not localized.
    ///
    /// - Parameter key: `String, CodingKey, CaseIterable, Keyable`.
    ///
    /// - Returns: String Type value by  key.
    public func value(for key: CodingKeys) -> String? {
        switch key {
        case .fileName:
            return fileName
        case .numberStreams:
            return numberStreams?.formatted()
        case .formatName:
            return formatName
        case .startTime:
            return startTime?.formatted(.time(pattern: .hourMinuteSecond))
        case .duration:
            return duration?.formatted(.time(pattern: .hourMinuteSecond))
        case .size:
            return MetadataVideo.fileSizeFormatted(value: size, unit: .byte)
        case .bitRate:
            return MetadataVideo.fileSizeFormatted(value: bitRate, unit: .bit, rule: .down)
        case .probeScore:
            return probeScore?.formatted()
        case .tags:
            return nil
        case .formatLongName:
            return formatLongName
        }
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable, Keyable {
        case fileName = "filename"
        case numberStreams = "nb_streams"
        case formatName = "format_name"
        case formatLongName = "format_long_name"
        case startTime = "start_time"
        case duration = "duration"
        case size = "size"
        case bitRate = "bit_rate"
        case probeScore = "probe_score"
        case tags
        
        public var id: String {
            self.rawValue
        }
        
        public var index: Int {
            Self.allCases.firstIndex(of: self) ?? .zero
        }
        
        public var description: String {
            switch self {
            case .fileName:
                return "File name"
            case .numberStreams:
                return "Number streams"
            case .formatName:
                return "Format name"
            case .startTime:
                return "Start time"
            case .duration:
                return "Duration"
            case .size:
                return "File size"
            case .bitRate:
                return "Bit rate"
            case .probeScore:
                return "Probe score"
            case .tags:
                return "Tags"
            case .formatLongName:
                return "Format long name"
            }
        }
    }
}

extension FormatMetadata {
    public struct Tags: Codable, Identifiable, DictionaryKeyValueable {
        public let id: UUID = UUID()
        public let title: String?
        public let encoder: String?
        public let creationTime: Date?
        
        static private let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            return dateFormatter
        }()
        
        /// Dictionary of all format tags keys with values
        ///
        /// The library is created using all the keys of the `CodingKeys` enumeration.
        /// Example:
        ///
        ///     let metadata = try JSONDecoder().decode(MetadataVideo.self, from: data)
        ///     let dictionary = metadata.format.tags.dictionary
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
        ///     let fileName = metadata.format.tags?.value(for: .fileName) // "Video.mov"
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
            case .encoder:
                return encoder
            case .creationTime:
                if let creationTime {
                    return Self.dateFormatter.string(from: creationTime)
                } else {
                    return nil
                }
            }
        }
        
        public enum CodingKeys: String, CodingKey, CaseIterable, Keyable {
            case title
            case encoder = "encoder"
            case creationTime = "creation_time"
            
            public var id: String {
                self.rawValue
            }
            
            public var index: Int {
                Self.allCases.firstIndex(of: self) ?? .zero
            }
            
            public var description: String {
                switch self {
                case .title:
                    return "Title"
                case .encoder:
                    return "Encoder"
                case .creationTime:
                    return "Creation time"
                }
            }
        }
        
        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<FormatMetadata.Tags.CodingKeys> = try decoder.container(keyedBy: FormatMetadata.Tags.CodingKeys.self)
            self.title = try container.decodeIfPresent(String.self, forKey: FormatMetadata.Tags.CodingKeys.title)
            self.encoder = try container.decodeIfPresent(String.self, forKey: FormatMetadata.Tags.CodingKeys.encoder)
            if let creationTime = try container.decodeIfPresent(String.self, forKey: FormatMetadata.Tags.CodingKeys.creationTime) {
                let formatter = MetadataVideo.dateFormatterDecoder
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                self.creationTime = formatter.date(from: creationTime)
            } else {
                self.creationTime = nil
            }
        }
    }
}
