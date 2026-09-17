//
//  DemoContentView.swift
//  DuoLikeAnimation
//

import SwiftUI

struct ChatPreview: Identifiable {
    let id = UUID()
    let name: String
    let message: String
    let time: String
    let symbol: String
    let tint: Color
    let unread: Int
}

let chats: [ChatPreview] = [
    ChatPreview(name: "Mia", message: "The prototype is ready to review.", time: "09:41", symbol: "person.crop.circle.fill", tint: .mint, unread: 2),
    ChatPreview(name: "Weekend plans", message: "I found a great spot for brunch.", time: "08:16", symbol: "figure.2.and.child.holdinghands", tint: .orange, unread: 0),
    ChatPreview(name: "Alex Chen", message: "Perfect — see you there!", time: "Yesterday", symbol: "person.crop.circle.fill", tint: .blue, unread: 0),
    ChatPreview(name: "Design team", message: "Sam: I added the latest screens.", time: "Yesterday", symbol: "paintpalette.fill", tint: .purple, unread: 5),
    ChatPreview(name: "Family", message: "Mum: Dinner is at 7.", time: "Mon", symbol: "house.fill", tint: .pink, unread: 0)
]

/// A compact, pure-SwiftUI chat list that can be safely rasterized by `layerEffect`.
struct DemoContentView: View {
    let selectedChatID: ChatPreview.ID?

    var body: some View {
        VStack(spacing: 0) {
            header
            ForEach(chats) { chat in
                ChatRow(chat: chat, isSelected: chat.id == selectedChatID)
                Divider().padding(.leading, 78)
            }
            Spacer()
        }
        .background(Color(.systemGroupedBackground))
    }

    private var header: some View {
        HStack {
            Text("Chats")
                .font(.largeTitle.bold())
            Spacer()
            Image(systemName: "plus")
                .font(.title3.weight(.semibold))
                .frame(width: 36, height: 36)
                .background(.background, in: .circle)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

private struct ChatRow: View {
    let chat: ChatPreview
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: chat.symbol)
                .font(.system(size: 34))
                .foregroundStyle(chat.tint)
                .frame(width: 54, height: 54)
                .background(chat.tint.opacity(0.15), in: .rect(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 4) {
                Text(chat.name).font(.body.weight(.semibold))
                Text(chat.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 7) {
                Text(chat.time).font(.caption2).foregroundStyle(.secondary)
                if chat.unread > 0 {
                    Text("\(chat.unread)")
                        .font(.caption2.bold())
                        .foregroundStyle(.white)
                        .frame(minWidth: 18, minHeight: 18)
                        .background(.red, in: .circle)
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 76)
        .background(isSelected ? Color.accentColor.opacity(0.12) : .clear)
    }
}

#Preview {
    DemoContentView(selectedChatID: chats[0].id)
}
