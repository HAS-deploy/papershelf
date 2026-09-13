import Foundation
import UIKit
import SwiftData

enum ScanPipeline {
    struct Result {
        let document: ShelfDocument
        let images: [UIImage]
        let ocrEmpty: Bool
    }

    static func process(
        images: [UIImage],
        importSource: String?,
        modelContext: ModelContext
    ) async throws -> Result {
        guard !images.isEmpty else {
            throw NSError(domain: "ScanPipeline", code: 1, userInfo: [NSLocalizedDescriptionKey: "No pages to save."])
        }
        let id = UUID()
        let ocr = await OCRService.recognizeText(in: images)
        let ocrEmpty = ocr.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        // Never destroy scan on OCR failure — still title/file/save pages + PDF.
        let suggested = TitleSuggestor.suggest(from: ocr)
        let category = CategoryClassifier.classify(ocr: ocr, title: suggested)
        let pageNames = try PageStorage.savePages(id: id, images: images)
        let pdfURL = try PDFExportService.writePDF(id: id, images: images)

        let doc = ShelfDocument(
            id: id,
            title: suggested,
            suggestedTitle: suggested,
            category: category,
            ocrText: ocr,
            pageCount: images.count,
            pageFileNames: pageNames,
            pdfFileName: pdfURL.lastPathComponent,
            importSource: importSource
        )
        modelContext.insert(doc)
        try modelContext.save()
        return Result(document: doc, images: images, ocrEmpty: ocrEmpty)
    }
}
