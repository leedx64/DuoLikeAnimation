//
//  ContentView.swift
//  DuoLikeAnimation
//

import SwiftUI

struct ContentView: View {
    @State private var motion = FoldMotionModel()
    @State private var showsControls = false
    @State private var selectedChat: ChatPreview?

    var body: some View {
        GeometryReader { proxy in
            let insets = proxy.safeAreaInsets
            DemoContentView(selectedChatID: selectedChat?.id)
                .safeAreaPadding(insets)
                .frame(width: proxy.size.width + insets.leading + insets.trailing,
                       height: proxy.size.height + insets.top + insets.bottom)
                .clipped()
                .foldEffect(angle: motion.tiltAngle)
                .allowsHitTesting(false)
                .ignoresSafeArea()
                .overlay {
                    ChatTapLayer { selectedChat = $0 }
                        .safeAreaPadding(insets)
                        .frame(width: proxy.size.width + insets.leading + insets.trailing,
                               height: proxy.size.height + insets.top + insets.bottom)
                        .ignoresSafeArea()
                }
        }
        .overlay(alignment: .bottomTrailing) { controls }
        .onAppear { motion.start() }
        .onDisappear { motion.stop() }
        .sheet(item: $selectedChat) { ChatDetailView(chat: $0) }
    }

    private var controls: some View {
        VStack(alignment: .trailing, spacing: 10) {
            if showsControls {
                controlPanel
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            Button {
                withAnimation(.snappy) { showsControls.toggle() }
            } label: {
                Image(systemName: showsControls ? "xmark" : "slider.horizontal.3")
                    .font(.headline)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .background(.ultraThinMaterial, in: .circle)
        }
        .padding()
    }

    private var controlPanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(motion.tiltAngle * 180 / .pi, format: .number.precision(.fractionLength(1)))
                    .monospacedDigit()
                Text("°")
                Spacer()
                Button("Recalibrate", systemImage: "scope") { motion.recalibrate() }
                    .disabled(motion.usesManualTilt || !motion.isMotionAvailable)
            }
            .font(.subheadline.weight(.medium))

            Toggle("Manual tilt", isOn: $motion.usesManualTilt)
                .disabled(!motion.isMotionAvailable)

            Slider(value: $motion.manualDegrees, in: -45...45, step: 0.5) {
                Text("Tilt")
            } minimumValueLabel: {
                Text("-45°").font(.caption2)
            } maximumValueLabel: {
                Text("45°").font(.caption2)
            }
            .disabled(!motion.usesManualTilt)
        }
        .padding(16)
        .frame(width: 280)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 20))
    }
}

/// Keeps hit testing outside the shader-rendered layer, so chat rows remain tappable.
private struct ChatTapLayer: View {
    let openChat: (ChatPreview) -> Void

    var body: some View {
        VStack(spacing: 0) {
            Color.clear.frame(height: 68)
            ForEach(chats) { chat in
                Button { openChat(chat) } label: {
                    Color.clear.frame(maxWidth: .infinity, minHeight: 77)
                }
                .buttonStyle(.plain)
                Divider().padding(.leading, 78)
            }
            Spacer()
        }
    }
}

private struct ChatDetailView: View {
    let chat: ChatPreview
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 14) {
                Text(chat.message)
                    .padding(14)
                    .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 14))
                Spacer()
            }
            .padding()
            .navigationTitle(chat.name)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
