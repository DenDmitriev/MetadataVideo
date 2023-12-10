//
//  MetadataVideoTestsLocalization.swift
//
//
//  Created by Denis Dmitriev on 10.12.2023.
//

import XCTest
@testable import MetadataVideoFFmpeg

final class MetadataVideoTestsLocalization: XCTestCase {
    func testFormat() throws {
        let url = Bundle.module.url(forResource: "MediaInformation", withExtension: "txt")
        guard let url else { return XCTExpectFailure("Test media information not exist in module.") }
        do {
            let string = try String(contentsOf: url)
            let data = MetadataVideo.convertMediaInformationToJSON(string)
            guard let data else { return XCTExpectFailure("Unable to convert URL content to JSON.") }
            let metadata = try JSONDecoder().decode(MetadataVideo.self, from: data)
            
            print("🇷🇺", metadata.format.dictionary)
        } catch {
            XCTExpectFailure("Test decode media information failure: \(error.localizedDescription).")
        }
    }
}
