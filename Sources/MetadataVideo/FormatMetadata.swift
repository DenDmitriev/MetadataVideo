//
//  FormatMetadata.swift
//  GrabShot
//
//  Created by Denis Dmitriev on 07.12.2023.
//

import Foundation

public struct FormatMetadata: Codable, Identifiable, DictionaryKeyValueable {
    public let id: UUID = UUID()
    let fileName: String?
    let numberStreams: Int?
    let formatName: String?
    let startTime: Duration?
    let duration: Duration?
    let size: Int?
    let bitRate: Int?
    let probeScore: Int?
    let tags: Tags?
    
    var dictionary: [CodingKeys: String?] {
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
        self.tags = try container.decodeIfPresent(FormatMetadata.Tags.self, forKey: FormatMetadata.CodingKeys.tags)
    }
    
    func value(for key: CodingKeys) -> String? {
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
            return MetadataVideo.fileSizeFormatted(value: size, unit: .byte, rule: .up)
        case .bitRate:
            return MetadataVideo.fileSizeFormatted(value: bitRate, unit: .bit, rule: .down)
        case .probeScore:
            return probeScore?.formatted()
        case .tags:
            return nil
        }
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable, Keyable {
        case fileName = "filename"
        case numberStreams = "nb_streams"
        case formatName = "format_name"
        case startTime = "start_time"
        case duration = "duration"
        case size = "size"
        case bitRate = "bit_rate"
        case probeScore = "probe_score"
        case tags
        
        var id: String {
            self.rawValue
        }
        
        var index: Int {
            Self.allCases.firstIndex(of: self) ?? .zero
        }
        
        var description: String {
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
            }
        }
    }
}

extension FormatMetadata {
    struct Tags: Codable, Identifiable, DictionaryKeyValueable {
        let id: UUID = UUID()
        let title: String?
        let encoder: String?
        let creationTime: Date?
        
        static let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            return dateFormatter
        }()
        
        var dictionary: [CodingKeys: String?] {
            var dictionary = [CodingKeys: String?]()
            for key in CodingKeys.allCases {
                if let value = value(for: key) {
                    dictionary[key] = value
                }
            }
            return dictionary
        }
        
        func value(for key: CodingKeys) -> String? {
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
        
        enum CodingKeys: String, CodingKey, CaseIterable, Keyable {
            case title
            case encoder = "encoder"
            case creationTime = "creation_time"
            
            var id: String {
                self.rawValue
            }
            
            var index: Int {
                Self.allCases.firstIndex(of: self) ?? .zero
            }
            
            var description: String {
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
        
        init(from decoder: Decoder) throws {
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
