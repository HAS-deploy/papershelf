import Foundation

enum DocumentCategory: String, Codable, CaseIterable, Identifiable, Sendable {
    case home = "HOME"
    case auto = "AUTO"
    case medical = "MEDICAL"
    case school = "SCHOOL"
    case financial = "FINANCIAL"
    case other = "OTHER"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .home: return "Home"
        case .auto: return "Auto"
        case .medical: return "Medical"
        case .school: return "School"
        case .financial: return "Financial"
        case .other: return "Other"
        }
    }
}
