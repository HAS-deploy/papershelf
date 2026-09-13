import XCTest
@testable import PaperShelf

final class TitleSuggestorTests: XCTestCase {
    func testSuggestUsesHeadingLine() {
        let ocr = """
        STATE FARM
        Auto Insurance Card
        Policy 123
        """
        let title = TitleSuggestor.suggest(from: ocr)
        XCTAssertTrue(title.lowercased().contains("state") || title.lowercased().contains("auto"))
    }

    func testEmptyFallsBack() {
        let title = TitleSuggestor.suggest(from: "   \n  ")
        XCTAssertTrue(title.hasPrefix("Scan "))
    }
}
