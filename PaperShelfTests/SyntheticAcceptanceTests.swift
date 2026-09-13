import XCTest
import UIKit
@testable import PaperShelf

/// Stage 3 non-physical synthetic corpus harness.
/// PHYSICAL_CAMERA remains UNVERIFIED — these images are PIL-generated.
final class SyntheticAcceptanceTests: XCTestCase {
    struct Expectation: Decodable {
        let id: String
        let expectedCategory: String
        let searchTerms: [String]
        let cleanPrinted: Bool?
        let pageIndex: Int?
        let pageCount: Int?
    }

    struct Row: Codable {
        let id: String
        let expectedCategory: String
        let predictedCategory: String
        let categoryOK: Bool
        let ocrChars: Int
        let termsTotal: Int
        let termsFound: Int
        let termsOK: Bool
        let pdfBytes: Int
        let pdfOK: Bool
        let cleanPrinted: Bool
    }

    func testSyntheticCorpusAcceptance() async throws {
        let corpusURL = try XCTUnwrap(Self.corpusDirectory(), "factory/corpus missing from test bundle")
        let jsonFiles = try FileManager.default.contentsOfDirectory(at: corpusURL, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension == "json" && $0.lastPathComponent != "manifest.json" }
            .sorted { lhs, rhs in lhs.lastPathComponent < rhs.lastPathComponent }

        XCTAssertGreaterThanOrEqual(jsonFiles.count, 50, "Need ≥50 synthetic samples")

        var rows: [Row] = []
        var cleanTermHits = 0
        var cleanTermTotal = 0
        var specificCatHits = 0
        var specificCatTotal = 0
        var pdfHits = 0

        for jsonURL in jsonFiles {
            let data = try Data(contentsOf: jsonURL)
            let exp = try JSONDecoder().decode(Expectation.self, from: data)
            let pngURL = corpusURL.appendingPathComponent("\(exp.id).png")
            guard let image = UIImage(contentsOfFile: pngURL.path) else {
                XCTFail("Missing image for \(exp.id)")
                continue
            }

            let ocr = await OCRService.recognizeText(in: [image])
            let predicted = CategoryClassifier.classify(ocr: ocr, title: TitleSuggestor.suggest(from: ocr))
            let expected = DocumentCategory(rawValue: exp.expectedCategory) ?? .other

            let found = exp.searchTerms.filter { term in
                ocr.range(of: term, options: [.caseInsensitive, .diacriticInsensitive]) != nil
            }
            let termsOK = found.count == exp.searchTerms.count
            let categoryOK: Bool = {
                if expected == .other { return predicted == .other }
                // OTHER wrong if expected specific
                return predicted == expected
            }()

            var pdfBytes = 0
            var pdfOK = false
            do {
                let pdf = try PDFExportService.makePDF(from: [image])
                pdfBytes = pdf.count
                pdfOK = pdfBytes > 1000
            } catch {
                pdfOK = false
            }

            let clean = exp.cleanPrinted ?? true
            if clean {
                cleanTermTotal += exp.searchTerms.count
                cleanTermHits += found.count
            }
            if expected != .other {
                specificCatTotal += 1
                if categoryOK { specificCatHits += 1 }
            }
            if pdfOK { pdfHits += 1 }

            rows.append(Row(
                id: exp.id,
                expectedCategory: expected.rawValue,
                predictedCategory: predicted.rawValue,
                categoryOK: categoryOK,
                ocrChars: ocr.count,
                termsTotal: exp.searchTerms.count,
                termsFound: found.count,
                termsOK: termsOK,
                pdfBytes: pdfBytes,
                pdfOK: pdfOK,
                cleanPrinted: clean
            ))
        }

        let termRate = cleanTermTotal == 0 ? 0.0 : Double(cleanTermHits) / Double(cleanTermTotal)
        let catRate = specificCatTotal == 0 ? 0.0 : Double(specificCatHits) / Double(specificCatTotal)
        let pdfRate = rows.isEmpty ? 0.0 : Double(pdfHits) / Double(rows.count)

        // Emit machine-readable summary for host report scraping
        let summary: [String: Any] = [
            "physical_camera": "UNVERIFIED",
            "samples": rows.count,
            "clean_term_hits": cleanTermHits,
            "clean_term_total": cleanTermTotal,
            "clean_term_rate": termRate,
            "specific_category_hits": specificCatHits,
            "specific_category_total": specificCatTotal,
            "specific_category_rate": catRate,
            "pdf_hits": pdfHits,
            "pdf_rate": pdfRate,
            "targets": [
                "clean_ocr_terms": 0.95,
                "specific_category": 0.85,
                "pdf_valid": 1.0
            ]
        ]
        let summaryData = try JSONSerialization.data(withJSONObject: summary, options: [.prettyPrinted, .sortedKeys])
        let summaryText = String(data: summaryData, encoding: .utf8) ?? "{}"
        print("STAGE3_SYNTHETIC_SUMMARY_BEGIN")
        print(summaryText)
        print("STAGE3_SYNTHETIC_SUMMARY_END")

        // Also write into XCTest attachment-friendly one-liner
        print(String(format: "STAGE3_RATES term=%.4f cat=%.4f pdf=%.4f n=%d", termRate, catRate, pdfRate, rows.count))

        XCTAssertGreaterThanOrEqual(termRate, 0.95, "Clean printed search-term OCR rate below 95% (\(cleanTermHits)/\(cleanTermTotal))")
        XCTAssertGreaterThanOrEqual(catRate, 0.85, "Specific-category accuracy below 85% (\(specificCatHits)/\(specificCatTotal))")
        XCTAssertEqual(pdfHits, rows.count, "PDF generation failed for some samples")

        // Persist per-row JSON beside corpus when sandbox allows (best-effort)
        let out = corpusURL.appendingPathComponent("_last_results.json")
        if let encoded = try? JSONEncoder().encode(rows) {
            try? encoded.write(to: out)
        }
    }

    private static func corpusDirectory() -> URL? {
        let bundle = Bundle(for: SyntheticAcceptanceTests.self)
        let candidates: [URL?] = [
            bundle.resourceURL?.appendingPathComponent("Corpus"),
            bundle.resourceURL?.appendingPathComponent("corpus"),
            bundle.url(forResource: "manifest", withExtension: "json")?.deletingLastPathComponent(),
            bundle.bundleURL.appendingPathComponent("Corpus"),
            bundle.bundleURL.appendingPathComponent("corpus")
        ]
        for case let u? in candidates {
            let manifest = u.appendingPathComponent("manifest.json")
            if FileManager.default.fileExists(atPath: manifest.path) { return u }
            // any paired png/json
            if let files = try? FileManager.default.contentsOfDirectory(at: u, includingPropertiesForKeys: nil),
               files.contains(where: { $0.pathExtension == "png" }) {
                return u
            }
        }
        if let urls = bundle.urls(forResourcesWithExtension: "json", subdirectory: "Corpus"), let first = urls.first {
            return first.deletingLastPathComponent()
        }
        if let urls = bundle.urls(forResourcesWithExtension: "png", subdirectory: nil),
           let first = urls.first(where: { $0.lastPathComponent.contains("ins_letter") || $0.lastPathComponent.contains("auto_card") }) {
            return first.deletingLastPathComponent()
        }
        return nil
    }
}
