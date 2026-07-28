import Darwin
import Foundation

public enum HerdrGraphicsFormat: String, Codable, Sendable {
    case png
    case rgb
    case rgba
}

public struct HerdrGraphicsPlacement: Codable, Equatable, Sendable {
    public let viewportColumn: Int
    public let viewportRow: Int
    public let gridColumns: Int
    public let gridRows: Int

    public init(
        viewportColumn: Int,
        viewportRow: Int,
        gridColumns: Int,
        gridRows: Int
    ) {
        self.viewportColumn = viewportColumn
        self.viewportRow = viewportRow
        self.gridColumns = gridColumns
        self.gridRows = gridRows
    }

    private enum CodingKeys: String, CodingKey {
        case viewportColumn = "viewport_col"
        case viewportRow = "viewport_row"
        case gridColumns = "grid_cols"
        case gridRows = "grid_rows"
    }
}

public struct HerdrGraphicsFrame: Sendable {
    public let format: HerdrGraphicsFormat
    public let imageWidth: Int
    public let imageHeight: Int
    public let placement: HerdrGraphicsPlacement
    public let data: Data

    public init(
        format: HerdrGraphicsFormat,
        imageWidth: Int,
        imageHeight: Int,
        placement: HerdrGraphicsPlacement,
        data: Data
    ) {
        self.format = format
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.placement = placement
        self.data = data
    }
}

public final class HerdrPaneGraphicsStream: @unchecked Sendable {
    private let descriptor: Int32
    private let lock = NSLock()
    private var closed = false

    init(descriptor: Int32) {
        self.descriptor = descriptor
    }

    deinit {
        close()
    }

    public func send(_ frame: HerdrGraphicsFrame) throws {
        try lock.withLock {
            guard !closed else {
                throw HerdrAPIError(
                    code: "graphics_stream_closed",
                    message: "The pane graphics stream is closed."
                )
            }
            let header = GraphicsFrameHeader(
                format: frame.format,
                imageWidth: frame.imageWidth,
                imageHeight: frame.imageHeight,
                dataLength: frame.data.count,
                placement: frame.placement
            )
            var headerData = try JSONEncoder().encode(header)
            headerData.append(0x0A)
            try HerdrSocketTransport.writeAll(headerData, to: descriptor)
            try HerdrSocketTransport.writeAll(frame.data, to: descriptor)
        }
    }

    public func close() {
        let shouldClose = lock.withLock {
            guard !closed else { return false }
            closed = true
            return true
        }
        guard shouldClose else { return }
        Darwin.shutdown(descriptor, SHUT_RDWR)
        Darwin.close(descriptor)
    }
}

private struct GraphicsFrameHeader: Encodable {
    let format: HerdrGraphicsFormat
    let imageWidth: Int
    let imageHeight: Int
    let dataLength: Int
    let placement: HerdrGraphicsPlacement

    enum CodingKeys: String, CodingKey {
        case format
        case imageWidth = "image_width"
        case imageHeight = "image_height"
        case dataLength = "data_length"
        case placement
    }
}
