import SwiftUI
import PDFKit

struct DocumentDetailView: View {
    @Bindable var document: ShelfDocument
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var shareURL: URL?
    @State private var showShare = false
    @State private var showDelete = false
    @State private var shareError: String?

    var body: some View {
        List {
            Section("Details") {
                TextField("Title", text: $document.title)
                    .accessibilityLabel("Document title")
                Picker("Category", selection: Binding(
                    get: { document.category },
                    set: { document.category = $0; document.modifiedAt = Date() }
                )) {
                    ForEach(DocumentCategory.allCases) { cat in
                        Text(cat.displayName).tag(cat)
                    }
                }
                .accessibilityLabel("Category")
                LabeledContent("Pages", value: "\(document.pageCount)")
                LabeledContent("Created", value: document.createdAt.formatted(date: .abbreviated, time: .shortened))
            }

            Section("Pages") {
                let images = PageStorage.loadImages(id: document.id, names: document.pageFileNames)
                ForEach(Array(images.enumerated()), id: \.offset) { idx, image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 320)
                        .listRowInsets(EdgeInsets())
                        .accessibilityLabel("Page \(idx + 1) of \(images.count)")
                }
            }

            Section("OCR text") {
                if document.ocrText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text("No readable text detected for this document. The scan and PDF are still saved.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } else {
                    Text(document.ocrText)
                        .font(.footnote)
                        .textSelection(.enabled)
                }
            }
        }
        .navigationTitle(document.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    sharePDF()
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                .accessibilityLabel("Share PDF")
                .accessibilityHint("Opens the system share sheet")
                Button(role: .destructive) { showDelete = true } label: {
                    Label("Delete", systemImage: "trash")
                }
                .accessibilityLabel("Delete document")
            }
        }
        .sheet(isPresented: $showShare) {
            if let shareURL {
                ActivityView(items: [shareURL])
            }
        }
        .alert("Couldn’t share PDF", isPresented: Binding(
            get: { shareError != nil },
            set: { if !$0 { shareError = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(shareError ?? "")
        }
        .confirmationDialog("Delete this document?", isPresented: $showDelete, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                PageStorage.deleteDocumentFiles(id: document.id)
                modelContext.delete(document)
                try? modelContext.save()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        }
        .onDisappear {
            document.modifiedAt = Date()
            try? modelContext.save()
        }
    }

    private func sharePDF() {
        let images = PageStorage.loadImages(id: document.id, names: document.pageFileNames)
        do {
            let url = try PDFExportService.writePDF(id: document.id, images: images)
            shareURL = url
            showShare = true
        } catch {
            shareError = error.localizedDescription
        }
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
