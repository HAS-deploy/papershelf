import Foundation

enum CategoryClassifier {
    /// Deterministic keyword scoring. Low confidence → OTHER.
    static func classify(ocr: String, title: String = "") -> DocumentCategory {
        let blob = (title + "\n" + ocr).lowercased()
        guard blob.count >= 8 else { return .other }

        var scores: [DocumentCategory: Int] = [
            .home: 0, .auto: 0, .medical: 0, .school: 0, .financial: 0, .other: 0
        ]

        let rules: [(DocumentCategory, [String])] = [
            (.home, ["lease", "landlord", "mortgage", "utility", "electric", "gas bill", "water bill", "hoa", "homeowner", "appliance", "warranty", "rent"]),
            (.auto, ["vin", "vehicle", "automobile", "registration", "dmv", "driver", "insurance card", "policy number", "odometer", "carfax", "motor vehicle"]),
            (.medical, ["patient", "diagnosis", "pharmacy", "prescription", "lab result", "clinic", "hospital", "hipaa", "physician", "medical record", "health plan", "copay"]),
            (.school, ["permission slip", "student", "school", "teacher", "grade", "classroom", "enrollment", "transcript", "homework", "pta"]),
            (.financial, ["statement", "account ending", "apr", "credit card", "bank", "routing", "balance", "invoice", "payment due", "irs", "tax", "brokerage", "portfolio"])
        ]

        for (category, keywords) in rules {
            for kw in keywords where blob.contains(kw) {
                scores[category, default: 0] += 2
            }
        }

        let ranked = scores.sorted { lhs, rhs in lhs.value > rhs.value }
        guard let best = ranked.first, best.value >= 2 else { return .other }
        // Tie or weak lead → OTHER
        if ranked.count > 1, ranked[1].value == best.value { return .other }
        return best.key
    }
}
