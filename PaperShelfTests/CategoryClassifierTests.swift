import XCTest
@testable import PaperShelf

final class CategoryClassifierTests: XCTestCase {
    func testMedicalKeywords() {
        let cat = CategoryClassifier.classify(ocr: "Patient name Jane Doe Clinic lab result physician notes")
        XCTAssertEqual(cat, .medical)
    }

    func testFinancialKeywords() {
        let cat = CategoryClassifier.classify(ocr: "Credit card statement account ending 1234 payment due")
        XCTAssertEqual(cat, .financial)
    }

    func testLowConfidenceOther() {
        let cat = CategoryClassifier.classify(ocr: "hello")
        XCTAssertEqual(cat, .other)
    }
}
