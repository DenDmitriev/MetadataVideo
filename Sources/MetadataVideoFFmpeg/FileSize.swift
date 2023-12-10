//
//  FileSize.swift
//  GrabShot
//
//  Created by Denis Dmitriev on 01.12.2023.
//

import Foundation

/// Size of file
public struct FileSize {
    /// Numerical `Double` size in the specified `unit`.
    public var size: Double
    
    /// File size unit.
    public let unit: Unit
    
    public init(size: Double, unit: Unit) {
        self.size = size
        self.unit = unit
    }
    
    public init(size: Int, unit: Unit) {
        let sizeDouble = Double(size)
        self.size = sizeDouble
        self.unit = unit
    }
    
    /// Converting file size to the desired dimension.
    /// - Returns: Size in`Double`.
    public func size(in unit: Unit) -> Double {
        return size * Double(self.unit.factor) / Double(unit.factor)
    }
    
    /// Optimal `FileSize`.
    ///
    /// Following
    /// An example shows the results of rounding a size using this rule:
    ///
    ///     let byte = 1000
    ///     let size = FileSize(size: byte, unit: .byte)
    ///     size.optimal(rule: .down)
    ///     // 1,000 B
    ///     size.optimal(rule: .up)
    ///     // 1 KB
    ///
    ///
    /// - Parameter rule: A rule for rounding a dimension `size`.
    ///
    /// - Returns: The optimal `FileSize` based on the dimension `size`.
    public func optimal(rule: FloatingPointRoundingRule? = nil) -> Self {
        let bytes = size * self.unit.factor
        let optimal: Self
        
        switch rule {
        case .down:
            switch bytes {
            case 0..<10:
                optimal = .init(size: size(in: .bit), unit: .bit)
            case 10..<10000:
                optimal = .init(size: size(in: .byte), unit: .byte)
            case 10000..<10000000:
                optimal = .init(size: size(in: .kiloByte), unit: .kiloByte)
            case 10000000..<10000000000:
                optimal = .init(size: size(in: .megaByte), unit: .megaByte)
            case 10000000000..<10000000000000:
                optimal = .init(size: size(in: .gigaByte), unit: .gigaByte)
            case 10000000000000...:
                optimal = .init(size: size(in: .teraByte), unit: .teraByte)
            default:
                return self
            }
        case .up:
            switch bytes {
            case 0..<0.1:
                optimal = .init(size: size(in: .bit), unit: .bit)
            case 0.1..<100:
                optimal = .init(size: size(in: .byte), unit: .byte)
            case 100..<100000:
                optimal = .init(size: size(in: .kiloByte), unit: .kiloByte)
            case 100000..<100000000:
                optimal = .init(size: size(in: .megaByte), unit: .megaByte)
            case 100000000..<100000000000:
                optimal = .init(size: size(in: .gigaByte), unit: .gigaByte)
            case 100000000000...:
                optimal = .init(size: size(in: .teraByte), unit: .teraByte)
            default:
                return self
            }
        default:
            switch bytes {
            case 0..<1:
                optimal = .init(size: size(in: .bit), unit: .bit)
            case 1..<1000:
                optimal = .init(size: size(in: .byte), unit: .byte)
            case 1000..<1000000:
                optimal = .init(size: size(in: .kiloByte), unit: .kiloByte)
            case 1000000..<1000000000:
                optimal = .init(size: size(in: .megaByte), unit: .megaByte)
            case 1000000000..<1000000000000:
                optimal = .init(size: size(in: .gigaByte), unit: .gigaByte)
            case 1000000000000...:
                optimal = .init(size: size(in: .teraByte), unit: .teraByte)
            default:
                return self
            }
        }
        
        return optimal
    }
}

extension FileSize {
    /// File size units.
    public enum Unit {
        case bit
        case byte
        case kiloByte
        case megaByte
        case gigaByte
        case teraByte
        
        /// Dimension factor.
        public var factor: Double {
            switch self {
            case .bit:
                return 1/8
            case .byte:
                return 1
            case .kiloByte:
                return 1000
            case .megaByte:
                return 1000000
            case .gigaByte:
                return 1000000000
            case .teraByte:
                return 1000000000000
            }
        }
        
        /// Symbolic designation of the dimension factor.
        public var designation: String {
            switch self {
            case .bit:
                return String(localized: "bit", bundle: .module, comment: "FileSize")
            case .byte:
                return String(localized: "B", bundle: .module, comment: "FileSize")
            case .kiloByte:
                return String(localized: "KB", bundle: .module, comment: "FileSize")
            case .megaByte:
                return String(localized: "MB", bundle: .module, comment: "FileSize")
            case .gigaByte:
                return String(localized: "GB", bundle: .module, comment: "FileSize")
            case .teraByte:
                return String(localized: "TB", bundle: .module, comment: "FileSize")
            }
        }
    }
}

extension FileSize: CustomStringConvertible {
    
    /// File size description with dimension symbol
    public var description: String {
        let rounded = (size * 100).rounded() / 100
        return rounded.formatted() + " " + self.unit.designation
    }
    
    /// File size description with dimension symbol
    public func formatted() -> String {
        return description
    }
}
