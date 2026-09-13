import Foundation
import LocalAuthentication

@MainActor
final class AppLockService: ObservableObject {
    private let key = "papershelf.lock.enabled"
    @Published var isEnabled: Bool {
        didSet { UserDefaults.standard.set(isEnabled, forKey: key) }
    }
    @Published var isUnlocked = false

    init() {
        isEnabled = UserDefaults.standard.bool(forKey: key)
        if !isEnabled { isUnlocked = true }
    }

    func authenticate() async -> Bool {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
                || context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            // No biometrics / passcode — allow access but keep setting.
            isUnlocked = true
            return true
        }
        do {
            let ok = try await context.evaluatePolicy(
                .deviceOwnerAuthentication,
                localizedReason: "Unlock PaperShelf"
            )
            isUnlocked = ok
            return ok
        } catch {
            isUnlocked = false
            return false
        }
    }

    func lockIfNeeded() {
        if isEnabled { isUnlocked = false }
    }
}
