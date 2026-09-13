import Foundation
import UIKit

enum PageStorage {
    static var rootURL: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = base.appendingPathComponent("PaperShelf", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    static func documentDir(id: UUID) -> URL {
        let dir = rootURL.appendingPathComponent("pages/\(id.uuidString)", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    static func savePages(id: UUID, images: [UIImage]) throws -> [String] {
        let dir = documentDir(id: id)
        var names: [String] = []
        for (idx, image) in images.enumerated() {
            let name = String(format: "page-%03d.jpg", idx + 1)
            let url = dir.appendingPathComponent(name)
            guard let data = image.jpegData(compressionQuality: 0.85) else {
                throw NSError(domain: "PageStorage", code: 1, userInfo: [NSLocalizedDescriptionKey: "JPEG encode failed"])
            }
            try data.write(to: url, options: .atomic)
            names.append(name)
        }
        return names
    }

    static func loadImages(id: UUID, names: [String]) -> [UIImage] {
        let dir = documentDir(id: id)
        return names.compactMap { name in
            let url = dir.appendingPathComponent(name)
            guard let data = try? Data(contentsOf: url) else { return nil }
            return UIImage(data: data)
        }
    }

    static func deleteDocumentFiles(id: UUID) {
        let dir = documentDir(id: id)
        try? FileManager.default.removeItem(at: dir)
        let pdf = rootURL.appendingPathComponent("pdfs/\(id.uuidString).pdf")
        try? FileManager.default.removeItem(at: pdf)
    }

    static func pdfURL(id: UUID) -> URL {
        let dir = rootURL.appendingPathComponent("pdfs", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("\(id.uuidString).pdf")
    }
}
