import Foundation
import UIKit
import PDFKit

enum PDFExportService {
    static func makePDF(from images: [UIImage]) throws -> Data {
        guard !images.isEmpty else {
            throw NSError(domain: "PDFExport", code: 1, userInfo: [NSLocalizedDescriptionKey: "No pages"])
        }
        let pdf = PDFDocument()
        for (idx, image) in images.enumerated() {
            guard let page = PDFPage(image: image) else { continue }
            pdf.insert(page, at: idx)
        }
        guard let data = pdf.dataRepresentation() else {
            throw NSError(domain: "PDFExport", code: 2, userInfo: [NSLocalizedDescriptionKey: "PDF encode failed"])
        }
        return data
    }

    static func writePDF(id: UUID, images: [UIImage]) throws -> URL {
        let data = try makePDF(from: images)
        let url = PageStorage.pdfURL(id: id)
        try data.write(to: url, options: .atomic)
        return url
    }
}
