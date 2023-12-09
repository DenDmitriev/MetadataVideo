import XCTest
@testable import MetadataVideoFFmpeg

final class MetadataVideoTests: XCTestCase {
    func testFormat() throws {
        let url = Bundle.module.url(forResource: "MediaInformation", withExtension: "txt")
        guard let url else { return XCTExpectFailure("Test media information not exist in module.") }
        do {
            let string = try String(contentsOf: url)
            let data = MetadataVideo.convertMediaInformationToJSON(string)
            guard let data else { return XCTExpectFailure("Unable to convert URL content to JSON.") }
            let metadata = try JSONDecoder().decode(MetadataVideo.self, from: data)
            
            let numberStreamsExpectation = 3
            let durationExpectation: Duration = .init(secondsComponent: 5, attosecondsComponent: 0)
            let fileSizeExpectation = 990502 // bytes
            let bitRateExpectation = 1584803 // bytes
            
            XCTAssertTrue(metadata.format.numberStreams == numberStreamsExpectation)
            XCTAssertTrue((metadata.format.duration ?? .zero) == durationExpectation)
            XCTAssertTrue((metadata.format.size ?? .zero) == fileSizeExpectation)
            XCTAssertTrue((metadata.format.bitRate ?? .zero) == bitRateExpectation)
        } catch {
            XCTExpectFailure("Test decode media information failure: \(error.localizedDescription).")
        }
    }
    
    func testStreamVideo() throws {
        let url = Bundle.module.url(forResource: "MediaInformation", withExtension: "txt")
        guard let url else { return XCTExpectFailure("Test media information not exist in module.") }
        do {
            let string = try String(contentsOf: url)
            let data = MetadataVideo.convertMediaInformationToJSON(string)
            guard let data else { return XCTExpectFailure("Unable to convert URL content to JSON.") }
            let metadata = try JSONDecoder().decode(MetadataVideo.self, from: data)
            
            
            if let streamVideo = metadata.streams.first(where: { $0.codecType! == .video }) {
                print(streamVideo.dictionary)
                let pixelFormatExpectation = "yuv420p"
                let colorSpaceExpectation = "bt709"
                let widthExpectation = 1920
                let heightExpectation = 1080
                let bitsPerRawSampleExpectation = 8
                let aspectRatioExpectation = "16:9"
                let codecNameExpectation = "h264"
                let numberFramesExpectation = "120"
                let frameRateExpectation = 24.0
                
                XCTAssertTrue(streamVideo.pixelFormat == pixelFormatExpectation)
                XCTAssertTrue(streamVideo.colorSpace ?? "" == colorSpaceExpectation)
                XCTAssertTrue(streamVideo.width ?? .zero == widthExpectation)
                XCTAssertTrue(streamVideo.height ?? .zero == heightExpectation)
                XCTAssertTrue(streamVideo.bitsPerRawSample ?? .zero == bitsPerRawSampleExpectation)
                XCTAssertTrue(streamVideo.displayAspectRatio ?? "" == aspectRatioExpectation)
                XCTAssertTrue(streamVideo.codecName ?? "" == codecNameExpectation)
                XCTAssertTrue(streamVideo.numberFrames ?? "" == numberFramesExpectation)
                XCTAssertTrue(streamVideo.frameRate ?? .zero == frameRateExpectation)
            } else {
                XCTExpectFailure("Video stream not exist")
            }
        } catch {
            XCTExpectFailure("Test decode media information failure: \(error.localizedDescription).")
        }
    }
}
