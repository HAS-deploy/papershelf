import Foundation
import SwiftData

@Model
final class ShelfDocument {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var modifiedAt: Date
    var title: String
    var suggestedTitle: String
    var categoryRaw: String
    var ocrText: String
    var pageCount: Int
    /// Relative paths under Application Support/PaperShelf/pages/{id}/
    var pageFileNames: [String]
    var pdfFileName: String?
    var importSource: String?

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        modifiedAt: Date = Date(),
        title: String,
        suggestedTitle: String,
        category: DocumentCategory,
        ocrText: String = "",
        pageCount: Int = 0,
        pageFileNames: [String] = [],
        pdfFileName: String? = nil,
        importSource: String? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.title = title
        self.suggestedTitle = suggestedTitle
        self.categoryRaw = category.rawValue
        self.ocrText = ocrText
        self.pageCount = pageCount
        self.pageFileNames = pageFileNames
        self.pdfFileName = pdfFileName
        self.importSource = importSource
    }

    var category: DocumentCategory {
        get { DocumentCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }

    var searchableBlob: String {
        "\(title) \(ocrText) \(category.displayName)"
    }
}
