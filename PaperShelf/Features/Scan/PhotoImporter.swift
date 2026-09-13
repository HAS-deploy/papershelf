import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct PhotoImporter: UIViewControllerRepresentable {
    var onPick: ([UIImage]) -> Void
    var onCancel: () -> Void

    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 20
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoImporter
        init(parent: PhotoImporter) { self.parent = parent }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard !results.isEmpty else {
                parent.onCancel()
                return
            }
            var images: [UIImage] = []
            let group = DispatchGroup()
            for result in results {
                group.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                    if let image = object as? UIImage {
                        images.append(image)
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                if images.isEmpty {
                    self.parent.onCancel()
                } else {
                    self.parent.onPick(images)
                }
            }
        }
    }
}
