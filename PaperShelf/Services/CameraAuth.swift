import AVFoundation
import UIKit

enum CameraAuth {
    enum Status {
        case authorized
        case denied
        case restricted
        case notDetermined
        case unsupported
    }

    static var documentCameraSupported: Bool {
        // VisionKit check is done at call site; keep here for clarity
        true
    }

    static func currentStatus() -> Status {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: return .authorized
        case .denied: return .denied
        case .restricted: return .restricted
        case .notDetermined: return .notDetermined
        @unknown default: return .denied
        }
    }

    static func requestAccess() async -> Status {
        let status = currentStatus()
        if status != .notDetermined { return status }
        let granted = await AVCaptureDevice.requestAccess(for: .video)
        return granted ? .authorized : .denied
    }

    static func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
