import SwiftUI
import SwiftData
import VisionKit

struct ArchiveView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var entitlements: EntitlementStore
    @Query(sort: \ShelfDocument.createdAt, order: .reverse) private var documents: [ShelfDocument]

    @State private var searchText = ""
    @State private var selectedCategory: DocumentCategory?
    @State private var showScanner = false
    @State private var showImporter = false
    @State private var showPaywall = false
    @State private var isProcessing = false
    @State private var processingError: String?
    @State private var infoMessage: String?
    @State private var showCameraDenied = false
    @State private var scannerAvailable = VNDocumentCameraViewController.isSupported

    var body: some View {
        NavigationStack {
            Group {
                if filtered.isEmpty {
                    if documents.isEmpty {
                        ContentUnavailableView {
                            Label("Your shelf is empty", systemImage: "books.vertical")
                        } description: {
                            Text("Scan a document or import photos. PaperShelf names, files, and makes them searchable on-device.")
                        } actions: {
                            if scannerAvailable {
                                Button {
                                    Task { await beginCapture(scan: true) }
                                } label: {
                                    Label("Scan document", systemImage: "doc.text.viewfinder")
                                }
                                .buttonStyle(.borderedProminent)
                                .accessibilityLabel("Scan document")
                                .accessibilityHint("Opens the camera document scanner")
                            } else {
                                Text("Document camera isn’t available on this device. You can still import photos.")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            Button {
                                Task { await beginCapture(scan: false) }
                            } label: {
                                Label("Import photos", systemImage: "photo.on.rectangle")
                            }
                            .accessibilityLabel("Import photos")
                            .accessibilityHint("Choose photos to add as a document")
                        }
                        .accessibilityIdentifier("archive.empty")
                    } else {
                        ContentUnavailableView.search(text: searchText.isEmpty ? (selectedCategory?.displayName ?? "filter") : searchText)
                            .accessibilityIdentifier("archive.noResults")
                    }
                } else {
                    List {
                        if !entitlements.hasUnlimited {
                            let left = max(0, EntitlementStore.freeDocumentLimit - documents.count)
                            Section {
                                Text(left == 0
                                     ? "Free limit reached (\(EntitlementStore.freeDocumentLimit) documents). Upgrade for Unlimited."
                                     : "Free plan · \(left) of \(EntitlementStore.freeDocumentLimit) slots left.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .accessibilityLabel("Free plan status")
                            }
                        }
                        ForEach(filtered, id: \.id) { doc in
                            NavigationLink(value: doc.id) {
                                DocumentRowView(document: doc)
                            }
                            .accessibilityHint("Opens document details")
                        }
                    }
                    .navigationDestination(for: UUID.self) { id in
                        if let doc = documents.first(where: { $0.id == id }) {
                            DocumentDetailView(document: doc)
                        }
                    }
                }
            }
            .navigationTitle("PaperShelf")
            .searchable(text: $searchText, prompt: "Search title or text")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("All categories") { selectedCategory = nil }
                        ForEach(DocumentCategory.allCases) { cat in
                            Button(cat.displayName) { selectedCategory = cat }
                        }
                    } label: {
                        Label(selectedCategory?.displayName ?? "Categories", systemImage: "line.3.horizontal.decrease.circle")
                    }
                    .accessibilityLabel("Filter by category")
                    .accessibilityValue(selectedCategory?.displayName ?? "All")
                }
                ToolbarItemGroup(placement: .primaryAction) {
                    if scannerAvailable {
                        Button {
                            Task { await beginCapture(scan: true) }
                        } label: {
                            Label("Scan", systemImage: "doc.text.viewfinder")
                        }
                        .accessibilityIdentifier("archive.scan")
                        .accessibilityLabel("Scan document")
                        .accessibilityHint("Opens the camera document scanner")
                    }
                    Button {
                        Task { await beginCapture(scan: false) }
                    } label: {
                        Label("Import", systemImage: "photo.on.rectangle")
                    }
                    .accessibilityIdentifier("archive.import")
                    .accessibilityLabel("Import photos")
                    .accessibilityHint("Choose photos to add as a document")
                }
            }
            .overlay {
                if isProcessing {
                    ZStack {
                        Color.primary.opacity(0.25).ignoresSafeArea()
                        ProgressView("Saving…")
                            .padding()
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                            .accessibilityLabel("Saving document")
                    }
                }
            }
            .alert("Couldn’t save", isPresented: Binding(
                get: { processingError != nil },
                set: { if !$0 { processingError = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(processingError ?? "")
            }
            .alert("Saved without readable text", isPresented: Binding(
                get: { infoMessage != nil },
                set: { if !$0 { infoMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(infoMessage ?? "")
            }
            .alert("Camera access needed", isPresented: $showCameraDenied) {
                Button("Open Settings") { CameraAuth.openSettings() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("PaperShelf needs camera access to scan documents. You can enable Camera in Settings, or import photos instead.")
            }
            .fullScreenCover(isPresented: $showScanner) {
                DocumentScannerView(
                    onFinish: { images in
                        showScanner = false
                        Task { await ingest(images, source: "scan") }
                    },
                    onCancel: { showScanner = false },
                    onFail: { message in
                        showScanner = false
                        processingError = message
                    }
                )
                .ignoresSafeArea()
            }
            .sheet(isPresented: $showImporter) {
                PhotoImporter(
                    onPick: { images in
                        showImporter = false
                        Task { await ingest(images, source: "photos") }
                    },
                    onCancel: { showImporter = false }
                )
                .ignoresSafeArea()
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }

    private var filtered: [ShelfDocument] {
        documents.filter { doc in
            if let selectedCategory, doc.category != selectedCategory { return false }
            let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            if q.isEmpty { return true }
            return doc.searchableBlob.localizedCaseInsensitiveContains(q)
        }
    }

    private func beginCapture(scan: Bool) async {
        guard entitlements.canAddDocument(currentCount: documents.count) else {
            showPaywall = true
            return
        }
        if scan {
            guard scannerAvailable else {
                processingError = "Document camera isn’t available on this device. Try Import photos."
                return
            }
            let status = await CameraAuth.requestAccess()
            switch status {
            case .authorized:
                showScanner = true
            case .notDetermined:
                showScanner = true
            case .denied, .restricted:
                showCameraDenied = true
            case .unsupported:
                processingError = "Camera isn’t available. Try Import photos."
            }
        } else {
            showImporter = true
        }
    }

    private func ingest(_ images: [UIImage], source: String) async {
        isProcessing = true
        defer { isProcessing = false }
        do {
            let result = try await ScanPipeline.process(images: images, importSource: source, modelContext: modelContext)
            if result.ocrEmpty {
                infoMessage = "Your document was saved, but no readable text was found. You can still rename it, file it, and share the PDF."
            }
        } catch {
            processingError = error.localizedDescription
        }
    }
}
