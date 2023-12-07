//
//  File.swift
//  
//
//  Created by Denis Dmitriev on 07.12.2023.
//

import Foundation

protocol Keyable: Identifiable, CustomStringConvertible, Hashable {
    var index: Int { get }
}

protocol DictionaryKeyValueable {
    associatedtype Key: CodingKey, CaseIterable, Keyable
    var dictionary: [Key: String?] { get }
    func value(for key: Key) -> String?
}
