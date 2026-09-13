import Foundation

enum TitleSuggestor {
    /// Conservative title from OCR — never invents facts not present in text.
    static func suggest(from ocr: String, fallbackDate: Date = Date()) -> String {
        let cleaned = ocr
            .replacingOccurrences(of: "\r", with: "\n")
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        guard !cleaned.isEmpty else {
            return defaultTitle(date: fallbackDate)
        }

        // Prefer a short early line that looks like a heading (not all caps microprint).
        let candidates = cleaned.prefix(12)
        for line in candidates {
            let words = line.split(separator: " ").count
            if line.count >= 4, line.count <= 64, words <= 10 {
                // Skip pure numbers / barcodes-ish
                let digits = line.filter(\.isNumber).count
                if Double(digits) / Double(max(line.count, 1)) > 0.6 { continue }
                return String(line.prefix(64))
            }
        }

        let joined = cleaned.prefix(2).joined(separator: " — ")
        if joined.count >= 4 {
            return String(joined.prefix(64))
        }
        return defaultTitle(date: fallbackDate)
    }

    static func defaultTitle(date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return "Scan \(f.string(from: date))"
    }
}
