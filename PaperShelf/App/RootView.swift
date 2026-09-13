import SwiftUI

struct RootView: View {
    @EnvironmentObject private var lock: AppLockService
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Group {
            if lock.isEnabled && !lock.isUnlocked {
                VStack(spacing: 20) {
                    Image(systemName: "lock.fill")
                        .font(.largeTitle)
                        .accessibilityHidden(true)
                    Text("PaperShelf is locked")
                        .font(.title2.bold())
                    Text("Use Face ID or your device passcode to open your shelf.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Button("Unlock") {
                        Task { _ = await lock.authenticate() }
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityLabel("Unlock PaperShelf")
                    .accessibilityHint("Authenticates with Face ID or passcode")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(Color(.systemBackground))
            } else {
                TabView(selection: .constant(ProcessInfo.processInfo.arguments.contains("-ScreenshotSettings") ? 1 : 0)) {
                    ArchiveView()
                        .tabItem { Label("Shelf", systemImage: "books.vertical") }
                        .accessibilityLabel("Shelf tab")
                        .tag(0)
                    SettingsView()
                        .tabItem { Label("Settings", systemImage: "gearshape") }
                        .accessibilityLabel("Settings tab")
                        .tag(1)
                }
            }
        }
        .task {
            if lock.isEnabled && !lock.isUnlocked {
                _ = await lock.authenticate()
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .background {
                lock.lockIfNeeded()
            }
        }
    }
}
