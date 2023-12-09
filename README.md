# MetadataVideoFFmpeg
File video content metadata decoder from FFmpeg media information

## Usage
Before use MetadataVideoFFmpeg you need install [ffmpeg-kit](https://github.com/arthenica/ffmpeg-kit) or manual get media information from command line FFmpeg. 
Example with [ffmpeg-kit](https://github.com/arthenica/ffmpeg-kit) wrapper.
```swift
        let videoURL = URL(string: "/Users/Username/Movies/Video.mov")
        let path = videoURL.relativePath
        let mediaInformation = FFprobeKit.getMediaInformation(path)
        let metadataRaw = mediaInformation?.getOutput()
        if let metadataRaw {
            do {
                let data = MetadataVideo.convertMediaInformationToJSON(metadataRaw)
                guard let data else { return }
                let metadataVideo = try JSONDecoder().decode(MetadataVideo.self, from: data) // metadata of Video.mov
            } catch {
                print(error.localizedDescription)
            }
        }
```

## Install

### Swift Package Manager

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding MetadataVideoFFmpeg as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```swift
dependencies: [
    .package(url: "https://github.com/DenDmitriev/MetadataVideoFFmpeg.git", .upToNextMajor(from: "2.0.0"))
]
```

