import SwiftUI

struct DocumentRowView: View {
    let document: ShelfDocument

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.secondary.opacity(0.15))
                .frame(width: 44, height: 56)
                .overlay {
                    Text("\(document.pageCount)")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(document.title)
                    .font(.body.weight(.semibold))
                    .lineLimit(2)
                Text("\(document.category.displayName) · \(document.createdAt.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(document.title), \(document.category.displayName), \(document.pageCount) pages, \(document.createdAt.formatted(date: .abbreviated, time: .omitted))")
    }
}
